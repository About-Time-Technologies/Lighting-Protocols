from itertools import chain
import os
from pprint import pprint
import tomllib
from typing import Annotated, List, Optional
import subprocess
from pydantic import BaseModel
import yaml
import time

START_TIME = time.time()

class SearchSection(BaseModel):
    """
    pydantic validator for the [search] section of the global .pages.toml 
    configuration

    exclude:
        is a list of strings which mark certain folders for exclusion from the 
        search. This allows folders containing ksy files without compiliing 
        them into the reference page
    """
    exclude: Optional[List[str]] = None

class GlobalConfig(BaseModel):
    """
    pydantic validator for the .pages.toml file in the root of the project
    
    search:
        configures the searching mechanics of the pages builder, see 
        SearchSection for detail
        """
    search: Optional[SearchSection] = None

class PageConfig(BaseModel):
    """
    pydantic validator for the pages section of the folder configuration

    heading:
        replaces the inferred header for this folders section. this is inserted
        as-is into the sidebar list
    """
    heading: Optional[str] = None

class FolderConfig(BaseModel):
    """
    pydantic validator for the folder configuration files
    
    page:
        configures the page generation for this folder. See PageConfig for 
        detail
    """
    page: Optional[PageConfig] = None

TEMPLATE: Annotated[str, "The base HTML template into which the listings will be injected"] = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reference Viewer</title>

    <style>
        html,body{
            padding: 0;
            margin: 0;
            width: 100%;
            height: 100%;
        }

        .content{
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: row;
        }

        .listing{
            flex-basis: 20%;
            display: flex;
            flex-direction: column;
            flex-grow: 0;
            flex-shrink: 0;
            overflow-y: auto;
            font-family: sans-serif;
            box-shadow: rgba(0, 0, 0, 0.15) 1.95px 1.95px 2.6px;
            border-right: 1px solid gainsboro;
            z-index: 100;
        }

        .listing .header, .listing a{
            padding: 10px;
        }

        .listing a:hover{
            background: gainsboro;
        }

        .listing a.active{
            font-weight: bold;
            background: rgb(251, 239, 254);
        }

        .listing .header{
            font-weight: bold;
            font-size: 1.3em;
        }

        iframe{
            flex-grow: 1;
            border: none;
            outline: none;
        }
    </style>
</head>
<body>
    <div class="content">
        <div class="listing">
            [[LISTINGS]]
        </div>
        <iframe src=""></iframe>
    </div>

    <script>
        const iframe = document.querySelector('iframe');
        const links = document.querySelectorAll('a');
        
        links.forEach((e) => {
            const location = e.getAttribute('data-href');
            e.addEventListener('click', () => {
                document.querySelector('a.active')?.classList.remove('active');
                iframe.src = location;
                e.classList.add('active');
            })
        })
    </script>
</body>
</html>
"""


ROOT: Annotated[str, "The root of the cloned project from which all files should be relative"] = os.path.join(os.path.dirname(__file__), '..')
KSC_EXECUTABLE: Annotated[str, "The location of the kaitai struct compiler to be invoked to compile the formats into html"] = "/tmp/kaitai/kaitai-struct-compiler-0.10/bin/kaitai-struct-compiler"

def get_title(file: str) -> Optional[str]:
    """
    Attempts to fetch a title from the provided file at the meta.title path 
    from the loaded YAML. If there is no title in the file it will fallback
    to the basename of the file without extension. If there are any errors
    it will return None indicating that processing should stop

    :param file: The location of the YAML file to load and extract a title
    :type file: str
    """
    try:
        with open(file, 'r', encoding='utf8') as f:
            document = yaml.safe_load(f)

        if 'meta' in document:
            if 'title' in document['meta']:
                if type(document['meta']['title']) == str:
                    return document['meta']['title']
                else:
                    print(f"Failed to fetch title from document for '{file}' - invalid type, required string and got {type(document['meta']['title'])}")
                    return None
            
        return os.path.splitext(os.path.basename(file))[0]
    except yaml.YAMLError as exc:
        print(f'Failed to parse the yaml specification of "{file}"')

def quote(s: str) -> str:
    """
    Wraps the provided string in quotes (ie quote("a") => "\"a\"")
    
    :param s: the string to wrap
    :type s: str
    
    :returns: The wrapped string
    :rtype: str
    """
    return f'"{s}"'

def file(f: str) -> str:
    """
    Returns the absolute location of the file from the root (joins it with the ROOT path)

    :param f: the file to join to the ROOT path
    :type f: str

    :returns: the absolute path of the file
    :rtype: str
    """
    return os.path.join(ROOT, f)

def get_immediate_subdirectories(a_dir) -> List[str]:
    """
    Returns all subdirectories of the provided path

    :param a_dir: the directory to list
    :type a_dir: str

    :returns: a list of file names within this folder (not joined with the parent path)
    :rtype: List[str]
    """
    return [name for name in os.listdir(a_dir)
            if os.path.isdir(os.path.join(a_dir, name))]

def get_ksy_files(dir) -> List[str]:
    """
    Finds all .ksy files within the provided folder recursively and returns the absolute path to the files

    :param dir: the directory to search
    :type dir: str

    :returns: a list of absolute file names that end in .ksy within the dir folder
    :rtype: List[str]
    """
    files = list(chain.from_iterable([[os.path.realpath(os.path.join(x[0], y)) for y in x[2]] for x in os.walk(dir, True, None, True)]))
    files = [x for x in files if x.endswith('.ksy')]
    return files

exclude_tlds: Annotated[str, "The list of folders (basenames) which should be excluded from the root folder"] = []

# Search for a .pages.toml file and load the excluded paths into it if it is present in the file
print("Searching for a config file")
if os.path.exists(file('.pages.toml')):
    print("Found .pages.toml")
    with open(file('.pages.toml'), 'rb')  as f:
        config = tomllib.load(f)
    
    cfd = GlobalConfig(**config)
    exclude_tlds = cfd.search.exclude
    if cfd.search != None and cfd.search.exclude != None:
        exclude_tlds = cfd.search.exclude
        print(f"Excluding the following directories: {', '.join(map(quote, exclude_tlds))}")

# List all subdirectories, excluding any that start with . or are in the excluded array
directories = [x for x in get_immediate_subdirectories(ROOT) if x not in exclude_tlds and not x.startswith(".")]
dir_count = len(directories)
print(f"Found {dir_count} candidate {'directories' if dir_count > 1 else 'directory'}")

# Try to find ksy files in each directory and filter out any folders that don't contain any
directories = [{
    "path": x,
    "files": get_ksy_files(file(x))
} for x in directories]
directories = [x for x in directories if len(x['files']) > 0]
print(f"Found {len(directories)} with ksy files, omitting {dir_count - len(directories)} folder(s)")

# Create the build folder if needed which will contain the site
build_folder = file('build')
if not os.path.exists(build_folder):
    print("Making output directory (/build)")
    os.mkdir(build_folder)

# This script will try and do as much as possible before building and continue after errors to try and
# produce the most amount of errors possible
exit_with_error: bool = False 

# Holds the list of directories and files that have been loaded and compiled
# { 'heading': str, 'pages': List[{'display': str, 'file': str}] }
directory_listing = []
for folder in directories:
    print(f"Descending into '{folder['path']}'")
    output_dir = file(os.path.join(build_folder, folder['path']))

    # Create the output folder if required
    if not os.path.exists(output_dir):
        print(f"Making output directory for {folder['path']} ({output_dir})")
        os.mkdir(output_dir)

    # Compile all found ksy files into html files into the output folder
    print(f"Compiling {len(folder['files'])} ksy files")
    result = subprocess.run([KSC_EXECUTABLE, "-t", "html", "--outdir", output_dir, ] + folder['files'], capture_output=True, encoding='utf8')

    # If the compilation fails, log it with the errors and mark that this should fail once everything is built. This means
    # we will build all ksy files and collect all errors before exiting
    if result.returncode != 0:
        print(f"Compilation failed (exit code {result.returncode}! Waiting to all files are compiled and then failing the action")
        print("[stdout]")
        print(result.stdout)
        print("[stderr]")
        print(result.stderr)

        exit_with_error = True
        continue

    print("Successfully compiled")

    # Check if there is a configuration file in this folder and if so load it, merging it with the base specification
    toml_location = os.path.join(file(folder['path']), '.pages.toml')
    config = {
        'heading': folder['path'],
        'pages': []
    }

    if os.path.exists(toml_location):
        with open(toml_location, 'rb') as f:
            cfg = FolderConfig(**tomllib.load(f))
        if cfg.page is not None:
            if cfg.page.heading is not None:
                config['heading'] = cfg.page.heading

    # For each file, load a title and convert each compiled file into its new location in the output
    # This should be right if kaitai doesn't do anything weird with the names
    for file in folder['files']:
        title = get_title(file)
        if title is None:
            exit_with_error = True
            break

        config['pages'] += [{
            'display': title,
            'file': os.path.relpath(os.path.join(output_dir, os.path.splitext(os.path.basename(file))[0] + '.html'), start=build_folder)
        }]

    directory_listing += [config]

if exit_with_error:
    print("Encountered errors in processing, exiting")
    exit(1)

# Convert the headings and files into HTML and then populate the template
listings = ''.join([f'<div class="header">{x["heading"]}</div>' + ''.join([f'<a href="#" data-href="{y["file"]}">{y["display"]}</a>' for y in x['pages']]) for x in directory_listing])
result = TEMPLATE.replace('[[LISTINGS]]', listings)

# Write the template to file, and finish!
with open(os.path.join(build_folder, 'index.html'), 'w', encoding='utf8') as f:
    f.write(result)

print(f"Generated setup into '{os.path.relpath(build_folder)}' in {round(time.time() - START_TIME, 2)}s")

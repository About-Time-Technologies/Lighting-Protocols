# Development nodes
#   * esta_manufacturer has a misleading description in the spec. It is listed as going Hi Lo, however the description of the fields themselves describe Lo Hi. Based on experimentation, I am pretty sure its Lo Hi however this may need correcting

meta:
  id: artcommand

doc: |
  The ArtCommand packet is used to send property set style commands. The packet can be unicast or broadcast, the decision being application specific

  The Data field contains the command text. The text is ASCII encoded and is null terminated and is case insensitive. It is legal, although inefficient, to set the Data array size to the maximum of 512 and null pad unused entries.
  
  The command text may contain multiple commands and adheres to the following syntax:

  ```
  Command=Data&
  ```

  The ampersand is a break between commands. Also note that the text is capitalised for readability; it is case insensitive.

  Thus far, two commands are defined by Art-Net. It is anticipated that additional commands will be added as other manufacturers register commands which have industry wide relevance.
  
  These commands shall be transmitted with EstaMan = 0xFFFF

  |Command  |Meaning                                                                                                                      |
  |---------|-----------------------------------------------------------------------------------------------------------------------------|
  |SwoutText|This command is used to re-programme the label associated with the ArtPollReply->Swout fields. Syntax: "SwoutText=Playback&" |
  |SwinText |This command is used to re-programme the label associated with the ArtPollReply->Swin fields. Syntax: "SwinText=Record&"     |

  All:
    Receive: Application Specific
    Unicast Transmit: Application Specific
    Broadcast: Application Specific

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x24]
    doc: OpCommand (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: esta_manufacturer
    type: u2le
    doc: |
      The ESTA manufacturer code. These codesare used to represent equipment manufacturer.
      They are assigned by ESTA. This field can be interpreted as two ASCII octetsrepresenting the manufacturer initials.

  - id: length
    type: u2be
    doc: The length of the text array below

  - id: data
    type: str
    encoding: ASCII
    size: length
    doc: ASCII text command string, null terminated. Max length is 512 octetsincluding the null term.

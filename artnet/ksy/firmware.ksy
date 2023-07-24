# Development notes:
#   * Note: this is not a packet but is formally defined
#   * Username is assumed ASCII but not explicitly specified

meta:
  id: firmware
  title: Firmware Format

doc: |
  All firmware and UBEA upload files should be of the following format.

  The firmware file extension is .alf

  The UBEA file extension is .alu

seq:
  - id: checksum
    type: u2be
    doc: This is a 16 bit, one's completement checksum of the firmware data area

  - id: version_info
    type: u2be
    doc: Node's firmware revision number. The Controllershould only use this field to decide if a firmware update should proceed. The convention is that a higher number is a more recent release of firmware

  - id: username
    type: str
    encoding: ASCII
    size: 30
    doc: 30 byte field of user name information. This information is not checked by the Node. It is purely for display by the Controller. It should contain a human readable description of file and version number. Whilst this is a fixed length field, it must contain a null termination. (Note - assumed ASCII)

  - id: oem
    type: u2be
    repeat: expr
    repeat-expr: 256
    doc: |
      An array of 256 words. Each wordis hi byte first and represents an Oem code for which this file is valid.
      Unused entries must be filled with 0x0000
    
  - size: 510
    doc: An array of 255 words. Currently unused and should be set to zero

  - id: len_data
    type: u4be
    doc: The total lenght in words of the firmware information following this field

  - id: data
    size: len_data
    doc: The firmware data as an array of 16 bit values ordered hi byte first. The actual data is manufacturer specific

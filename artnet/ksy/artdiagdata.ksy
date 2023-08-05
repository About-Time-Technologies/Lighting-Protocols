# Development Notes

meta:
  id: artdiagdata
  title: ArtDiagData

doc: |
  ArtDiagData is a general purpose packet that allows a node or controller to send diagnostics data for display.
  The ArtPoll packet sent by controllers defines the destination to which these messages should be sent.

  Controller: 
    Receive: Application specific
    Unicase Transmit: As defined by ArtPoll (Allowed, with Targeted Mode)
    Broadcast: As defined by ArtPoll (Allowed)

  Node:
    Receive: No Action
    Unicast Transmit: As defined by ArtPoll (Allowed, with Targeted Mode)
    Broadcast: As defined by ArtPoll (Allowed)

  Media Server:
    Receive: No Action
    Unicast Transmit: As defined by ArtPoll (Allowed, with Targeted Mode)
    Broadcast: As defined by ArtPoll (Allowed)

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00
    
  - id: opcode
    contents: [0x00, 0x60]
    doc: OpAddress (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 1
    doc: Filler1 - Ignore by receiver, set to zero by sender

  - id: diag_priority
    type: u1
    enum: priority_codes
    doc: The priority of this diagnostic data. See Table 5.

  - id: logical_port
    type: u1
    doc: The logical DMX port of the product to which the message relates. Set to zero for general messages. This field if purely informational and is designedto allow development tools to filter diagnostics.

  - size: 1
    doc: Filler3 - Ignore by receiver, set to zero by sender

  - id: data_len
    type: u2be
    doc: The length of the text array below

  - id: data
    type: str
    encoding: ascii
    size: data_len
    doc: ASCII text array, null terminated. Max length is 512 bytes including the null terminator

enums:
  priority_codes:
    16:
      id: dp_low
      doc: Low priority message

    64: 
      id: dp_med
      doc: Medium priority message

    128:
      id: dp_high
      doc: High priority message

    224:
      id: dp_critical
      doc: Critical priority message

    240:
      id: dp_volatile
      doc: Volatile message. Messages of this type are displayed on a single line in the DMX-Workshop diagnostics display. All other types are displayed in a list box

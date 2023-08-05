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

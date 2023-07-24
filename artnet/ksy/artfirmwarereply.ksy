meta:
  id: artfirmwarereply
  title: ArtFirmwareReply

doc: |
  This packet is sent by the Node to the Controller in acknowledgement of each OpFirmwareMaster packet.
  
  Controller: 
    Receive: Send next OpFirmwareMaster
    Unicase Transmit: Not allowed
    Broadcast: Not allowed

  Node:
    Receive: No Action
    Unicast Transmit: Node transmits to specfic controller IP address
    Broadcast: Not Allowed

  Media Server:
    Receive: No Action
    Unicast Transmit: Node transmits to specific controller IPI address
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0xf3]
    doc: OpFirmwareReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 2
    doc: Filler, pad length to match ArtPoll

  - id: type
    type: u1
    enum: types
    doc: Defines the packet contents

  - size: 21
    doc: Spare, node sets to zero, controller does not test

enums:
  types:
    0:
      id: firm_block_good
      doc: Last packet received successfully
    
    1:
      id: firm_all_good
      doc: All firmware received successfully

    255: 
      id: firm_fail
      doc: Frmware upload failed (all error conditions)

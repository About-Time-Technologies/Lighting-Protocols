# Development Notes

meta:
  id: arttodrequest
  title: ArtTodRequest

doc: |
  This packet is used to request the Table of RDM Devices (TOD). A Node receiving this packet
  must not interpret it as forcing full discovery. Full discovery is only initiated at power on, or when an ArtTodControl.AtcFlush is received. The response is ArtTodData.

  Controller:
    Receive: No Action
    Unicase Transmit: Not Allowed
    Broadcast: Controller Directed Broadcast to all nodes

  Node Output Gateway:
    Receive: Reply with ArtTodData
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

  Node Input Gateway:
    Receive: No action
    Unicast Transmit: Not Allowed
    Broadcast: Input Gateway Directed Broadcasts to all nodes

  Media Server:
    Receive: No Action
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = ‘A’ ‘r’ ‘t’ ‘-‘ ‘N’ ‘e’ ‘t’ 0x00
    
  - id: opcode
    contents: [0x00, 0x80]
    doc: OpIpProgReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 2
    doc: Filler (pad length to match ArtPoll)

  - size: 7
    doc: Spare, transmit as 0, receivers don't test

  - id: net
    type: u1
    doc: The top 7 bits of the 15 bit Port-Address of Nodes that must respond

  - id: command
    contents: [0x00]
    doc: 0x00 is TodFull, send the entire TOD

  - id: len_address
    type: u1
    doc: The number of entries in Address that are used. Max value is 32

  - id: address
    size: len_address
    doc: Array of low bytes for the Port-Address of Nodes that must respond. Combined with Net to give full Port-Address

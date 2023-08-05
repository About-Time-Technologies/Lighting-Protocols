# Development Notes

meta:
  id: arttodcontrol
  title: ArtTodControl

doc: |
  The ArtTodControl packet is used to send RDM control parameters over Art-Net. The response is ArtTodData.

  Controller: 
    Receive: No Action
    Unicase Transmit: Allowed
    Broadcast: Allowed

  Node Output Gateway:
    Receive: Reply with ArtTodData
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed
    
  Node Input Gateway:
    Receive: No Action
    Unicast Transmit: Not Allowed
    Broadcast: The Input Gateway Directed Broadcasts to all nodes

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
    contents: [0x00, 0x82]
    doc: OpIpProgReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)
    
  - size: 2
    doc: Pad length to match ArtPoll
    
  - size: 7
    doc: Spare transmitted as zerom receivers don't test
    
  - id: net
    type: u1
    doc: The top 7 bits of the Port-Address of the Output Gateway DMX Port that should action this command
    
  - id: command_response
    type: u1
    doc:  Defines the packet action
    enum: packet_action
    
  - id: address
    type: u1
    doc: The low 8 bits of the Port-Address of the Output Gateway DMX Port that should action this command

enums:
  packet_action:
    0x00:
      id: atc_none
      doc: No action
    
    0x01:
      id: atc_flush
      doc: The node fluses its TOD and instigates full discovery

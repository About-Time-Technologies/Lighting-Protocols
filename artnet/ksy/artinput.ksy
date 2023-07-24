# Development nodes
#  * should input be type u1, its technically b1 but with 7 dead bits

meta:
  id: artinput
  title: ArtInput

doc: |
  A Controller or monitoring device on the network can enable or disable  individual DMX512 inputs on any of the network nodes. This allows the Controller to directly control network traffic and ensures that unused inputs are disabled and therefore not wasting bandwidth. 

  All nodes power on with all inputs enabled. 

  Caution should be exercised when implementing this function in the controller. Keep in mind that some network traffic may be operating on a node to node basis.
  
  Controller: 
    Receive: No Action
    Unicase Transmit: Controller transmits to a specific node IP address
    Broadcast: Not allowed

  Node:
    Receive: Reply with ArtPollReply
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

  Media Server:
    Receive: Reply with ArtPollReply
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x70]
    doc: OpInput (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 1
    doc: Filler, pad length to match ArtPoll

  - id: bind_index
    type: u1
    doc: The BindIndex defines the bound node which originated this packet and is used to uniquely identify the bound node when identical IP addresses are in use. This number represents the order of bound devices. A lower number me ans closer to root device. A value of 1 means root device.

  - id: num_ports
    type: u2be
    doc: Describes the number of input or output ports. Currently limited to 4 but with room for expansion

  - id: input
    type: u1
    enum: input_status
    repeat: expr
    repeat-expr: 4

enums:
  input_status:
    0: enabled
    1: disabled

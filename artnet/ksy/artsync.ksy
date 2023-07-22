meta:
  id: artsync
  title: ArtSync

doc: |
  The ArtSync packet can be used to force nodes to synchronously output ArtDmx packets to their outputs. This is useful in video and media-wall applications. 

  A controller that wishes to implement synchronous transmission will unicast multiple universes of ArtDmx and then broadcast an ArtSync to synchronously transfer all the ArtDmx packets to the nodes' outputs at the same time. 

  ## Managing Synchronous and non-Synchronous modes 

  At power on or reset a node shall operate in non-synchronous mode. This means that ArtDmx packets will be immediately processed and output. 

  When a node receives an ArtSync packet it should transfer to synchronous operation. This means that received ArtDmx packets will be buffered and output when the next ArtSync is received. 

  In order to allow transition between synchronous and non-synchronous modes, a node shall time out to non-synchronous operation if an ArtSync is not received for 4 seconds or more.

  ## Multiple controllers 
  
  In order to allow for multiple controllers on a network, a node shall compare the source  IP of the ArtSync to the source IP of the most recent ArtDmx packet. The ArtSync shall be  ignored if the IP addresses do not match. 

  When a port is merging multiple streams of ArtDmx from different IP addresses, ArtSync  packets shall be ignored

  Controller: 
    Receive: No Action
    Unicase Transmit: Not Allowed
    Broadcast: Controller broadcasts this packet to synchronously transfer previous ArtDmx packets to Node's output

  Node:
    Receive: Transfer previous ArtDmx packets to output
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

  Media Server:
    Receive: Transfer previous ArtDmx packets to output
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x52]
    doc: OpSync (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: aux
    type: u1
    repeat: expr
    repeat-expr: 2
    doc: Transmit as zero
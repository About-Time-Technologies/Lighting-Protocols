meta:
  id: artnzs
  title: ArtNzs

doc: |
  ArtNzs is the data packet used to transfer DMX51 2 data with non-zero start codes (except RDM). The format is identical for Node to Controller, Node to Node and Controller to Node.

  | Handling Rules | |
  | -- | -- |
  | **Controller**   ||
  | Receive          | Application Specific |
  | Unicast Transmit | Yes |
  | Broadcast        | No |
  | **Node**         ||
  | Receive          | Application Specific |
  | Unicast Transmit | Yes |
  | Broadcast        | No |
  | **Media Server** ||
  | Receive          | Application Specific |
  | Unicast Transmit | Yes |
  | Broadcast        | No |

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x51]
    doc: OpNzs (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: sequence
    type: u1
    doc: |
      The sequence number is used to ensure that ArtNzs packets are used in the correct order. 
      When Art-Net is carried over a medium such as the Internet, it is possible that ArtNzs packets will reach the receiver out of order. 

  - id: start_code
    type: u1
    doc: The DMX512 start code of this packet. Must not be Zero or RDM

  - id: port_address
    type: u2le
    doc: 15 bit Port-Address to which this packet is destined

  - id: len_data
    type: u2be
    doc: |
      The length of the data array. This value should be a number in the range 1 - 512.  
      It represents the number of DMX512 channels encoded in packet. 

  - id: data
    size: len_data
    doc: A variable length array of DMX512 lighting data
 
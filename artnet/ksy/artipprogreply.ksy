# Development Notes

meta:
  id: artipprogreply
  title: ArtIpProgReply

doc: |
  The ArtIpProgReply packet is issued by a Node in response to an ArtIpProg packet. Nodes that do not support remote programming of IP address do not reply to ArtIpProg packets. In all scenarios, the ArtIpProgReplyis sent to the private address of the sender.

  | Handling Rules | |
  | -- | -- |
  | **Controller**   ||
  | Receive          | No Action |
  | Unicast Transmit | Not Allowed |
  | Broadcast        | Not Allowed |
  | **Node**         ||
  | Receive          | No Action |
  | Unicast Transmit | Transmits to specific Controller IP address |
  | Broadcast        | Not Allowed |
  | **Media Server** ||
  | Receive          | No Action |
  | Unicast Transmit | Transmits to specific Controller IP address |
  | Broadcast        | Not Allowed |

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00
    
  - id: opcode
    contents: [0x00, 0xf9]
    doc: OpIpProgReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 4
    doc: Filler (pad length to match ArtPoll and ArtIpProg)

  - id: prog_ip
    type: u4be
    doc: IP Address of node

  - id: prog_subnet_mask
    type: u4be
    doc: Subnet mask of node

  - id: prog_port
    type: u2be
    doc: Port (deprecated)

  - type: b1

  - id: dhcp_enabled
    type: b1
    doc: DHCP enabled

  - type: b6

  - size: 1
    doc: Spare2 transmitted as zero, receivers don't test

  - id: prog_default_gateway
    type: u4be
    doc: Default Gateway of Node

  - size: 2
    doc: Spare, transmit as 0, receivers should not test

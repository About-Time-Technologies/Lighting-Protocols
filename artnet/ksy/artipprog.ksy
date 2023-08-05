# Development Notes
#   * TODO: prog_ip, prog_subnet_mask, prog_port, prog_default_gateway can all be conditional on their entry in command however this is not implemented right now

meta:
  id: artipprog
  title: ArtIpProg

doc: |
  The ArtIpProg packet allows the IP settings of a Node to be reprogrammed.
  The ArtIpProg packet is sent by a Controllerto the private address of a Node. If the Node supports remote programming of IP address, it will respond with an ArtIpProgReply packet. In all scenarios, the ArtIpProgReply is sent to the private address of the sender.

  Controller: 
    Receive: No Action
    Unicase Transmit: Controller transmits to a specific node IP address
    Broadcast: Not Allowed

  Node:
    Receive: Reply with ArtIpProgReply
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

  Media Server:
    Receive: Reply with ArtIpProgReply
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00
    
  - id: opcode
    contents: [0x00, 0xf8]
    doc: OpIpProg (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 2
    doc: Filler

  - id: command
    type: command
    doc: Actions this packet as follows

  - size: 1
    doc: Filler (set to zero for word alignment)

  - id: prog_ip
    type: u4be
    doc: IP Address to be programmed into Node if enabled by Command Field

  - id: prog_subnet_mask
    type: u4be
    doc: Subnet mask to be programmed into Node if enabled by Command Field

  - id: prog_port
    type: u2be
    doc: Port (deprecated)

  - id: prog_default_gateway
    type: u4be
    doc: Default Gateway to be programmed into Node if enabled by Command field

  - size: 4
    doc: Spare, transmit as 0, receivers should not test

types: 
  command:
    seq:
      - id: enable_programming
        type: b1
        doc: Set to enable any programming

      - id: enable_dhcp
        type: b1
        doc: |
          Set to enable DHCP (if set, ignore the lower bits - )

      - type: b1

      - type: b5
        if: enable_dhcp == true
        doc: Used to skip 5 bits if enable_dhcp is set to true

      - id: program_default_gateway
        type: b1
        doc: Program Default gateway
        if: enable_dhcp == false

      - id: return_all_parameters
        type: b1
        doc: Set to return all three parameters to default
        if: enable_dhcp == false

      - id: program_ip
        type: b1
        doc: Program IP Address
        if: enable_dhcp == false

      - id: program_subnet_mask
        type: b1
        doc: Program Subnet Mask
        if: enable_dhcp == false

      - id: program_port
        type: b1
        doc: Program port
        if: enable_dhcp == false


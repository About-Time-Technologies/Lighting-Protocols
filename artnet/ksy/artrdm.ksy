# Development Notes

meta:
  id: artrdm
  title: ArtRdm

doc: |
  The ArtRdm packet is used to transport all non-discovery RDM messages over Art-Net

  Controller: 
    Receive: No Action
    Unicase Transmit: Yes
    Broadcast: Not Allowed

  Node Output Gateway:
    Receive: No Action
    Unicast Transmit: Yes
    Broadcast: Not Allowed
    
  Node Input Gateway:
    Receive: No Action
    Unicast Transmit: Yes
    Broadcast: Not Allowed

  Media Server:
    Receive: No Action
    Unicast Transmit: Yes
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = ‘A’ ‘r’ ‘t’ ‘-‘ ‘N’ ‘e’ ‘t’ 0x00
    
  - id: opcode
    contents: [0x00, 0x83]
    doc: OpIpProgReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)
    
  - id: rdm_version
    type: u1
    doc: Version of RDM specification supported by the device
    enum: rdm_versions
    
  - size: 1
    doc: Pad length to match ArtPoll
    
  - size: 7
    doc: Spare transmitted as zero, receivers don't test
    
  - id: net
    type: u1
    doc: The top 7 bits of the Port-Address that should action this command
    
  - id: command
    type: u1
    doc: Defines the packet action
    enum: command
  
  - id: address
    type: u1
    doc: The low 8 bits of the Port-Address that should action this packet
    
  - id: rdm_packet
    size-eos: true
    doc: The RDM packet data excluding the DMX StartCode. The maximum packet length is 255 + 2-byte checksum - 1-byte start code = 256 bytes
    valid:
      max: 256

enums:
  rdm_versions:
    0x00: 
      id: rdm_draft
      doc: Devices that support the draft 1.0 version of RDM
      
    0x01:
      id: rdm_standard
      doc: Devices that support the standard 1.0 version of RDM
      
  command:
    0x00: 
      id: ar_process
      doc: Process the RDM Packet
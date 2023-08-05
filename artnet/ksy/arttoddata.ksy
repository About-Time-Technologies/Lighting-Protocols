# Development Notes

meta:
  id: arttoddata
  title: ArtTodData

doc: |
  The ArtTodData packet is sent from Node Output Gateways in response to an ArtTodRequest from Controller. It is always sent as broadcast.

  Controller: 
    Receive: No Action
    Unicase Transmit: Not Allowed
    Broadcast: Not Allowed

  Node Output Gateway:
    Receive: No Action
    Unicast Transmit: Not Allowed
    Broadcast: Output Gateway always Directed Broadcasts this packet
    
  Node Input Gateway:
    Receive: No Action
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

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
    contents: [0x00, 0x81]
    doc: OpIpProgReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)
    
  - id: rdm_version
    type: u1
    doc: Version of RDM specification supported by the device
    enum: rdm_versions
    
  - id: port
    type: u1
    doc: |
      Physical port index in a range of 1-4. This number is used with bind_index to identify the physical port that generated the packets. 
    
      `Physical port = (BindIndex - 1)  * ArtPollReply->NumPortsLow + ArtTodDataPort`
    
      Most gateways will implmenet one universe per ArtPollReply so `ArtTodData->Port` will usually be set to a value of 1.
    valid:
      min: 1
      max: 4
  
  - size: 6
    doc: Spare transmitted as zero, receivers don't test
    
  - id: bind_index
    type: u1
    doc: The Bind Index defines the bound node which originated this packet. In combination with Port and Source IP address, it uniquely identifies the sender. This must match the BindIndex field in ArtPollReply. This number represents the order of bound devices. A lower number means close to root device. A value of 1 means root device.
    
  - id: net
    type: u1
    doc: The top 7 bits of the Port-Address of the Output Gateway DMX Port that generated this packet
    
  - id: command_response
    type: u1
    doc: Defines the packet contents according to the command_responses enum
    enum: command_responses
  
  - id: address
    type: u1
    doc: The low 8 bits of the Port-Address of the Output Gateway DMX Port that generated this packet. The high nibble is the Sub-Net switch. The low nibble corresponds to the Universe
    
  - id: uid_total
    type: u2be
    doc: The total number of RDM devices discovered by this Universe
    
  - id: block_count
    type: u1
    doc: The index number of this packet. When uid_total exceeds 200, multiple ArtTodData packets are used. block_count is set to zero and incremented for each subsquent packet containing blocks of TOD information
    
  - id: len_tod
    type: u1
    doc: The number of UIDs encoded in this packet. This is the length of the TOD array
    
  - id: tod
    type: uid
    size: len_tod * 6
    doc: The array of RDM UIDs, each of which is a 6 byte value

enums:
  rdm_versions:
    0x00: 
      id: rdm_draft
      doc: Devices that support the draft 1.0 version of RDM
      
    0x01:
      id: rdm_standard
      doc: Devices that support the standard 1.0 version of RDM
      
  command_responses:
    0x00:
      id: tod_full
      doc: The packet contains the entire TOD or is the first packet in a sequence of packets that contains the entire TOD
      
    0xFF:
      id: tod_nak
      doc: The TOD is not available or discovery is incomplete

types:
  uid:
    seq:
      - id: manufacturer_id
        type: u2be
        doc: Manufacturer ID
       
      - id: device_id
        type: u4be
        doc: Device ID
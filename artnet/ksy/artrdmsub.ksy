# Development Notes

meta:
  id: artrdmsub
  title: ArtRdmSub

doc: |
  The ArtRdmSub packet is used to transfer Get, Set, GetResponse and SetResponse data to and from multiple sub-devices within an RDM device. This packet is primarily used by Art-Net devices that proxy or emulate RDM. It offers very significant bandwidth gains over the approach of sending multiple ArtRDM packets.
  
  Please note that this packet was added at the release of Art-Net II. For backwards compatibility it is only accepable to implement this packet in addition to ArtRdm. It must not be used instead of ArtRDM

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
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = ‘A’ ‘r’ ‘t’ ‘-‘ ‘N’ ‘e’ ‘t’ 0x00
    
  - id: opcode
    contents: [0x00, 0x84]
    doc: OpIpProgReply (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)
    
  - id: rdm_version
    type: u1
    doc: Version of RDM specification supported by the device
    enum: rdm_versions
    
  - size: 1
    doc: Spare transmitted as zero, receivers don't test
    
  - id: uid
    type: uid
    doc: UID of target RDM device
   
  - size: 1
    doc: Spare transmitted as zero, receivers don't test
    
  - id: command_class
    type: u1
    doc: As per RDM specification. This field defines wether this is a Get, Set, GetResponse, or SetResponse #TODO Enums
    
  - id: parameter_id
    type: u2be
    doc: As per RDM specification. This field defines the type of parameter contained in this packet
   
  - id: sub_device
    type: u2be
    doc: Defines the first device information contained in packet. This follows the RDM convention that 0 = root device, and 1 = first sub-devices
    
  - id: sub_count
    type: u2be
    doc: The number of sub-devices packed into the packet
    valid:
      min: 1
     
  - size: 4
    doc: Spare transmit as zero, receviers don't test
    
  - id: data
    size: sub_count * 2
    doc: The size of this 16-bit big endian data array is sub_count for Set and GetResponse, and 0 for Get and SetResponse commands
    
enums:
  rdm_versions:
    0x00: 
      id: rdm_draft
      doc: Devices that support the draft 1.0 version of RDM
      
    0x01:
      id: rdm_standard
      doc: Devices that support the standard 1.0 version of RDM
      
types:
  uid:
    seq:
      - id: manufacturer_id
        type: u2be
        doc: Manufacturer ID
       
      - id: device_id
        type: u4be
        doc: Device ID
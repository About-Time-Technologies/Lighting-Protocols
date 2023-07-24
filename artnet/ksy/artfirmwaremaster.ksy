meta:
  id: artfirmwaremaster
  title: ArtFirmwareMaster

doc: |
  ## Firmware and UBEA Upgrades

  This section defines the packets used to send firmware revisions to a node. In all instances, communication is private. Under no circumstances should the broadcast address be used. 

  The transaction involves the controller sending multiple ArtFirmwareMaster packets to a Node's IP address. Each packet is acknowledged by the Node with an ArtFirmwareReply. 

  The controller allows a 30 second maximum delay for reception of the ArtFirmwareReply. 

  If the reply is not received in this time, the controller aborts the transaction. The large time period is to allow for Nodes that are writing directly to slow non-volatile memory. 

  The Node allows a 30 second delay between sending an ArtFirmwareReply and receipt of the next consecutive ArtFirmwareMaster. If the next consecutive block is not received within this time, the Node aborts the transaction. In this instance the Node returns to its previous operating system and sets ArtPollReply->Status and ArtPollReply ->NodeReport accordingly.  

  The firmware update file contains a header that defines the Node OEM codes that are valid for this update. The Controller must check this value before sending to a Node. The Node also checks this data on r eceipt of the first packet. If the Node receives a packet with an invalid code, it sends an error  response. 
  
  The UBEA is the User Bios Expansion Area. This is a limited firmware upload mechanism that allows third party firmware extensions to be added to a Node.  

  Manufacturers who implement this feature must document the software interface requirements
  
  Controller: 
    Receive: No Action
    Unicase Transmit: Controller transmits to a specific node IP address
    Broadcast: Not allowed

  Node:
    Receive: Reply with OpFirmwareReply
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

  Media Server:
    Receive: Reply with OpFirmwareReply
    Unicast Transmit: Not Allowed
    Broadcast: Not Allowed

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0xf2]
    doc: OpFirmwareMaster (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 2
    doc: Filler, pad length to match ArtPoll

  - id: type
    type: u1
    enum: types
    doc: Defines the packet contents

  - id: block_id
    type: u1
    doc: Counts the consecutive blocks of firmware upload. Starting at 0x00 for the FirmFirst or UbeaFirst packet.

  - id: firmware_length
    type: u4be
    doc: This Int64 parameter describes the total number of words (Int16) in the firmware upload plus the firmware header size. Eg a 32K word upload plus 530 words of header information == 0x00008212. This value is also the file size (in words) of the file to be uploaded.

  - size: 20
    doc: Spare, controller sets to zero, node does not test
    
  - id: data
    size: 512
    doc: This array contains the firmware or UBEA data block. The order is hi byte first. The interpretation of this data is manufacturer specific. Final packet should be null packed if less than 512 bytes needed.

enums:
  types:
    0:
      id: firm_first
      doc: The first packet of a firmware upload
    
    1:
      id: firm_cont
      doc: A consecutive continuation packet of firmware upload

    2: 
      id: firm_last
      doc: The last packet of a firmware upload

    3:
      id: ubea_first
      doc: The first packet of a UBEA upload

    4:
      id: ubea_cont
      doc: A consecutive continuation packet of a UBEA upload

    5: 
      id: ubea_last
      doc: The last packet of a UBEA upload

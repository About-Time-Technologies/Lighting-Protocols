meta:
  id: artdmx
  title: ArtDmx

doc: |
  ArtDmx is the data packet used to transfer DMX512 data. The format is identical for Node to Controller, Node to Node and Controllerto Node.

  The Data is output through the DMX O/P port corresponding to the Universe setting. In the absence of received ArtDmx packets, each DMX O/P port re-transmits the same frame continuously.

  The first complete DMX frame received at each input port is placed in an ArtDmx packet as above and transmittedas an ArtDmx packet containing the relevant Universe parameter. Each subsequent DMX frame containing new data(different length or different contents) is also transmittedas an ArtDmx packet.

  Nodes do not transmitArtDmx for DMX512 inputs that have not received data since power on.

  However, an input that is active but not changing, will re-transmitthe last valid ArtDmx packet at approximately 4-second intervals.(Note. In order to converge the needs of ArtNet and sACN it is recommended that Art-Netdevices actually use a re-transmit time of 800mS to 1000mS).

  A DMX input that fails will not continue to transmitArtDmx data.

  ## Unicast Subscription:

  ArtDmx packetsmust be unicast to subscribers of the specific universe contained in the ArtDmx packet.

  The transmitting device must regularly ArtPoll the network to detect any change in devices which are subscribed. Nodes that are subscribed will list the subscription universe in the ArtPollReply. Subscribed means any universes listed in either the Swin or Swout array.

  If there are no subscribers to a universe, the controller shall not send ArtDmx. There are no conditions in which broadcast is allowed.

  ## Refresh Rate:

  The ArtDmx packet is intended to transfer DMX512 data. For this reason, the ArtDmx packet for a specific IP Address should not be transmitted at a repeat rate faster than the maximum repeat rate of a DMX packet containing 512 data slots.

  ## Synchronous Data:

  In video or media-wall applications, the ability to synchronise multiple universes of ArtDmx is beneficial. This can be achieved with the ArtSync packet.

  ## Data Merging: 
  
  The Art-Net protocol allows multiple nodes or controllers to transmit ArtDmx data to the same universe.

  A node can detect this situation by comparing the IP addresses of received ArtDmx packets. If ArtDmx packets addressed to the same Port-Addressare received from different IP addresses(or different Physical ports on the same IP address), a potential conflict exists.

  The Node can legitimately handle this situation using one of two methods:
  
  * Consider this to be an error condition and await user intervention.
  * Automatically merge the data.

  Nodes should document the approach that is implemented in the product user guide. The Merge option is preferred as it provides a higher level of functionality.

  Merge is implemented in either LTP or HTP mode as specified by the ArtAddress packet.

  Merge mode is implemented asfollows:
  
  > If ArtDmx with identical Port-Addressis received from differing IP addresses, the data is merged to the DMX output. In this situation, ArtPollReply-GoodOutputBit3 is set. If Art-Poll-Flags Bit 1 is set, an ArtPollReply should be transmitted when merging commences.
  > 
  > If ArtDmx with identical Port-Addressis received from identical IP addresses but differing Physical fields, the data is merged to the DMX output. In this situation, ArtPollReply-GoodOutput-Bit3 is set. If Art-Poll-Flags Bit 1 is set, an ArtPollReply should be transmitted when merging commences.

  Exit from Merge mode is handled as follows:

  > If ArtAddress AcCancelMerge is received, the Next ArtDmx message received ends Merge mode. The Node then discards any ArtDmx packets received from an IP address that does not match the IP address of the ArtDmx packet that terminated Merge mode.
  > 
  > If either (but not both) sources of ArtDmx stop, the failed source is held in the merge buffer for 10 seconds. If, during the 10 second timeout, the failed source returns, Merge mode continues. If the failed source does not recover, at the end of the timeout period, the Node exits Merge mode.
  > 
  > If both sources of ArtDmx fail, the output holds the last merge result.

  Merging is limited to two sources, any additional sources will be ignored by the Node. 
  
  The Merge implementation allows for the following two key modes of operation.
  
  * Combined Control: Two Controllers (Consoles) can operate on a network and merge data to multiple Nodes.
  * Backup: One Controller(Console) can monitor the network for a failure of the primary Controller. If a failure occurs, it can use the ArtAddress AcCancelMerge command to take instant control of the network.

  When a node provides multiple DMX512 inputs, it is the responsibility of the Node to handle merging of data. This is because the Node will have only one IP address. If this were not handled at the Node, ArtDmx packets with identical IP addresses and identical universe numbers, but conflicting level data would be transmitted to the network.

  | Handling Rules | |
  | -- | -- |
  | **All**   ||
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
    contents: [0x00, 0x50]
    doc: OpOutput / OpDmx (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: sequence
    type: u1
    doc: |
      The sequence number is used to ensure that ArtDmx packets are used in the correct order.

      When Art-Net is carried over a medium such as the Internet, it is possible that ArtDmx packets will reach the receiver out of order.

      This field is incremented in the range 0x01 to 0xff to allow the receiving node to re-sequence packets.

      The Sequence field is set to 0x00 to disable this feature.

  - id: physical
    type: u1
    doc: The physical input port from which DMX512 data was input. This field is used by the receiving device to discriminate between packets with identical Port-Address that have been generated by different input ports and so need to be merged.

  - id: port_address
    type: u2le
    doc: 15 bit Port-Address to which this packet is destined

  - id: len_data
    type: u2be
    doc: |
      The length of the DMX512 data array. This value should be an even number in the range 2-512.
      
      It represents the number of DMX512 channels encoded in packet. NB: Products which convert Art-Net to DMX512 may opt to always send 512 channels.
    valid:
      min: 2
      max: 512

  - id: data
    size: len_data
    doc: A variable length array of DMX512 lighting data

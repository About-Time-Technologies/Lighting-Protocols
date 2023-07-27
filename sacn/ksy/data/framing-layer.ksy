meta:
  id: data_framing_layer

seq:
  - id: flags
    type: b4
    doc: Each distinct type of Framing Layer still starts with Flags & Length. The E1.31 Flags & Length field is a 16- bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits.

  - id: length
    type: b12
    doc: "The E1.31 Framing Layer PDU length is computed starting with octet 38 and continuing through the last octet provided by the underlying layer (none, if the E1.31 Framing Layer is followed by no additional payload, as is the case with E1.31 Synchronization Packets). Thus, an E1.31 Data Packet with full payload would have length 638, and an E1.31 Universe Discovery Packet would have length between 120 and 1144, depending on the List of Universes. "

  - id: vector
    contents: [0x00, 0x00, 0x00, 0x02]
    doc: Sources sending an E1.31 Data Packet shall set the E1.31 Layer's Vector to VECTOR_E131_DATA_PACKET. This value indicates that the E1.31 framing layer is wrapping a DMP PDU.

  - id: source_name
    type: str
    encoding: utf8
    size: 64
    doc: A user-assigned name provided by the source of the packet for use in displaying the identity of a source to a user. There is no mechanism, other than user configuration, to ensure uniqueness of this name. The source name shall be null-terminated. If the source component implements ACN discovery as defined in EPI 19 [ACN], then this name shall be the same as the UACN field specified in EPI 19 [ACN]. UserAssigned Component Names, as the title suggests, supply a single name for an entire component, so this Source Name field will exist for each unique CID, but may be the same across multiple universes sourced by the same component.

  - id: priority
    type: u1
    doc: |
      As in [DMX] systems, the most recent E1.31 Data Packet from a single source supersedes any previous packets from that source (for a more thorough examination of sequence numbers, see 6.7.2). However, a receiver conforming to this standard may receive data for the same universe from multiple sources, as distinguished by examining the CID in the packet. This is a situation that cannot occur in conventional [DMX] systems. The Priority field is an unsigned, one octet field. The value is used by receivers in selecting between multiple sources of data for a given universe number. Sources that do not support variable priority shall transmit a priority of 100. No priority outside the range of 0 to 200 shall be transmitted on the network. Priority increases with numerical value, e.g., 200 is a higher priority than 100.

      For a given universe number, an E1.31 receiver gathering data from multiple sources shall treat data from packets with the highest priority as the definitive data for that universe. The behavior for an E1.31 receiver also doing universe synchronization is undefined, and is beyond the scope of this standard.

      ## Multiple Sources at Highest Priority

      It is possible for there to be multiple sources, all transmitting data at the highest currently active priority for a given universe. When this occurs, receivers must handle these sources in some way.

      A receiver which is only capable of processing one source of data will encounter a sources exceeded condition when two or more sources are present.

      Many devices are capable of combining, merging or arbitrating between the candidate sources by some algorithm (see below), but such algorithms frequently limit the number of concurrent sources which can be handled due to resource limitations, or encounter situations where there are still multiple candidate sources meeting some specified condition, and then, once again, a sources exceeded condition arises which requires resolution.

      ## Note on Merge and Arbitration Algorithms

      A process of combining data from multiple sources to produce a definitive result is called a merge. A process which selects between candidate sources based on some additional selection criterion is called arbitration.

      The single most common merging algorithm, which is usually appropriate to lighting intensity data (e.g. dimmer inputs), is to take the highest (numerically largest) level present from any of the candidate sources slot by slot throughout the universe—Highest Takes Precedence (HTP) merging. A variation of this uses DMX512-A START Code DDh (see [DMX] and http://tsp.esta.org/tsp/working_groups/CP/DMXAlternateCodes.php) to indicate slot-by-slot priority before merging the highest priority data for each slot on an HTP basis.

      For other devices such as movement axes in automated luminaires, HTP is often highly inappropriate. In this case, it is common to accept only one candidate source, but arbitration criteria may be applied e.g. based on information in the Source Name field.

      ## Note on Resolution of Sources Exceeded Condition

      Resolution is required when the number of sources exceeds limitations of the algorithm or of resources available. In the simplest case with no merging or arbitration, this occurs when there is more than one source (at highest active priority).

      One resolution mechanism is to stop accepting data from any source. Other mechanisms may choose one or more from the candidate sources by some overload selection scheme.

      Designers are very strongly discouraged from implementing resolution algorithms that generate different results from the same source combination on different occasions, because this can make sources exceeded conditions hard to detect, makes networks very hard to troubleshoot and may cause unexpected results at critical times. For example, an arbitration scheme which accepts the first source detected at the active highest priority and rejects any subsequent ones is not recommended, as it will produce results dependent on the order of equipment startup and the vagaries of packet timing.

      ## Requirements for Merging and Arbitrating

      The ability of devices to merge or arbitrate between multiple sources at highest active priority shall be declared in user documentation for the device.

      If merging or arbitration is implemented, the maximum number of sources which can be correctly handled shall be declared in user documentation for the device.

      If merging or arbitration is implemented the algorithm used shall be declared in user documentation for the device.

      ## Requirements for Sources Exceeded Resolution
  
      The resolution behavior of equipment under sources exceeded conditions shall be declared in user documentation for the device.

      Receiving devices conforming are strongly recommended to indicate a sources exceeded condition by some means easily detected at the device, e.g., by a flashing indicator, or obvious status message.

      ## Receiving devices may additionally indicate a sources exceeded condition by other means such as remote indication initiated by a network message. This is particularly appropriate for devices which may be hard to access.

      ## Requirements for Devices with Multiple Operating Modes

      Receiving devices which have multiple configurations available to select between different methods for merging and/or Sources Exceeded resolution, shall meet the rules above for each configuration separately. Any configurations in which the device is not compliant with this standard should be clearly declared as such, but are otherwise beyond the scope of this specification.

  - id: synchronization_address
    type: u2be
    doc: |
      The Synchronization Address identifies a universe number to be used for universe synchronization.

      ## Synchronization Address Usage in an E1.31 Data Packet

      E1.31 Synchronization Packets occur on specific universes. Upon receipt, they indicate that any data advertising that universe as its Synchronization Address must be acted upon.

      In an E1.31 Data Packet, a value of 0 in the Synchronization Address indicates that the universe data is not synchronized. If a receiver is presented with an E1.31 Data Packet containing a Synchronization Address of 0, it shall discard any data waiting to be processed and immediately act on that Data Packet.  
      
      When receiving an E1.31 Data Packet with a nonzero Synchronization Address, any receiver which does not support universe synchronization shall ignore the Synchronization Address and process the received data stream normally.

      If the Synchronization Address field is not 0, and the receiver is receiving an active synchronization stream for that Synchronization Address, it shall hold that E1.31 Data Packet until the arrival of the appropriate E1.31 Synchronization Packet before acting on it.

      A receiver that supports universe synchronization must not attempt to synchronize any data on a Synchronization Address until it has received its first E1.31 Synchronization Packet containing that address.

  - id: sequence_number
    type: u1
    doc: |
      In a routed network environment it is possible for packets to be received in a different order to the one in which they were sent. The sequence number allows receivers or diagnostic equipment to detect out of sequence or lost packets.

      Sources shall maintain a sequence for each universe they transmit. The sequence number for a universe shall be incremented by one for every packet sent on that universe. There is no implied relationship between the sequence number of an E1.31 Synchronization Packet and the sequence number of an E1.31 Data Packet on that same universe.
    
  - id: options
    type: options
    doc: This bit-oriented field is used to encode optional flags that control how the packet is used. 

  - id: universe
    type: u2be
    doc: The Universe is a 16-bit field that defines the universe number of the data carried in the packet. Universe values shall be limited to the range 1 to 63999. Universe value 0 and those between 64000 and 65535 are reserved for future use. E131_DISCOVERY_UNIVERSE is the Universe Discovery universe. See Section 9 for more information.

types:
  options:
    seq: 
      - id: preview_data
        type: b1
        doc: This bit, when set to 1, indicates that the data in this packet is intended for use in visualization or media server preview applications and shall not be used to generate live output.

      - id: stream_terminated
        type: b1
        doc: |
          This bit is intended to allow E1.31 sources to terminate transmission of a stream or of universe synchronization without waiting for a timeout to occur, and to indicate to receivers that such termination is not a fault condition.

          When set to 1 in an E1.31 Data Packet, this bit indicates that the source of the data for the universe specified in this packet has terminated transmission of that universe. Three packets containing this bit set to 1 shall be sent by sources upon terminating sourcing of a universe. Upon receipt of a packet containing this bit set to a value of 1, a receiver shall enter network data loss condition. Any property values in an E1.31 Data Packet containing this bit shall be ignored.

      - id: force_synchronization
        type: b1
        doc: |
          This bit indicates whether to lock or revert to an unsynchronized state when synchronization is lost (See Section 11 on Universe Synchronization and 11.1 for discussion on synchronization states). When set to 0, components that had been operating in a synchronized state shall not update with any new packets until synchronization resumes. When set to 1, once synchronization has been lost, components that had been operating in a synchronized state need not wait for a new E1.31 Synchronization Packet in order to update to the next E1.31 Data Packet.

      - type: b5
        doc: Bits 0 through 4 of this field are reserved for future use and shall be transmitted as 0 and ignored by receivers.
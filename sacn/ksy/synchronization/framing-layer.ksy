meta:
  id: synchronization_framing_layer

seq:
  - id: flags
    type: b4
    doc: Each distinct type of Framing Layer still starts with Flags & Length. The E1.31 Flags & Length field is a 16- bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits.

  - id: length
    type: b12
    doc: "The E1.31 Framing Layer PDU length is computed starting with octet 38 and continuing through the last octet provided by the underlying layer (none, if the E1.31 Framing Layer is followed by no additional payload, as is the case with E1.31 Synchronization Packets). Thus, an E1.31 Data Packet with full payload would have length 638, and an E1.31 Universe Discovery Packet would have length between 120 and 1144, depending on the List of Universes. "

  - id: vector
    contents: [0x00, 0x00, 0x00, 0x01]
    doc: Sources sending an E1.31 Synchronization Packet shall set the E1.31 Layer's Vector to VECTOR_E131_EXTENDED_SYNCHRONIZATION. This value indicates that the E1.31 Framing Layer contains universe synchronization information.

  - id: sequence_number
    type: u1
    doc: |
      In a routed network environment, it is possible for packets to be received in a different order to the one in which they were sent. The sequence number allows receivers or diagnostic equipment to detect out of sequence or lost packets.

      Sources shall maintain a sequence for each universe they transmit. The sequence number for a universe shall be incremented by one for every packet sent on that universe. There is no implied relationship between the sequence number of an E1.31 Synchronization Packet and the sequence number of an E1.31 Data Packet on that same universe.

  - id: synchronization_address
    type: u2be
    doc: |
      The Synchronization Address identifies the universe to which this synchronization packet is directed.

      ## Synchronization Address Usage in an E1.31 Synchronization Packet

      An E1.31 Synchronization Packet is sent to synchronize the E1.31 data on a specific universe number. A Synchronization Address of 0 is thus meaningless, and shall not be transmitted. Receivers shall ignore E1.31 Synchronization Packets containing a Synchronization Address of 0.

      When E1.31 Synchronization Packets are sent via multicast, they shall only be sent to the address which corresponds to their Synchronization Address. Receivers may ignore Synchronization Packets sent to multicast addresses which do not correspond to their Synchronization Address. More information about the correlation between universe numbers and multicast addresses can be found in Section 9.

  - size: 2
    doc: Octets 47-48 of the E1.31 Synchronization Packet are reserved for future use. They shall be transmitted as 0 and ignored by receivers.
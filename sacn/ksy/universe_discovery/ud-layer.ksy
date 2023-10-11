# Note: framing layer is imported here and used. While this
#  is not a framing layer, it uses the same structure and
#  requirements as the framing layer

meta:
  id: ud_layer

seq:
  - id: flags
    type: b4
    doc: The Universe Discovery Layer's Flags & Length field is a 16-bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits. The Universe Discovery Layer PDU length is computed starting with octet 112 and continuing through the last universe provided in the Universe Discovery PDU (octet 1143 for a full payload). This is the length of the Universe Discovery PDU.

  - id: length
    type: b12
    doc: The Universe Discovery Layer's Flags & Length field is a 16-bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits. The Universe Discovery Layer PDU length is computed starting with octet 112 and continuing through the last universe provided in the Universe Discovery PDU (octet 1143 for a full payload). This is the length of the Universe Discovery PDU.

  - id: vector
    contents: [0x00, 0x00, 0x00, 0x01]
    doc: The Universe Discovery Layer’s Vector shall be set to VECTOR_UNIVERSE_DISCOVERY_UNIVERSE_LIST, indicating that it contains a list of universes. Receivers shall discard the packet if the received value is not VECTOR_UNIVERSE_DISCOVERY_UNIVERSE_LIST.

  - id: page
    type: u1
    doc: |
      A single source may be transmitting on so many universes that the total number of universes it must include in its List of Universes will span multiple packets. Each one of these packets acts as a “page” of those universes.

      The Universe Discovery Layer's Page field is an 8-bit field indicating the page number of this E1.31 Universe Discovery Packet. Page numbers are indexed, starting at 0.

  - id: last_page
    type: u1
    doc: The Universe Discovery Layer's Last Page field is an 8-bit field indicating the number of the final page being to be transmitted. Together, these pages carry across the complete list of the universes upon which this source is actively transmitting. Page numbers are indexed starting at 0. Rather than not sending an E1.31 Universe Discovery packet, sources that are not actively transmitting on any universes may choose to send an E1.31 Universe Discovery Packet with an empty List of Universes, a Page of 0, and a Last Page of 0.

  - id: universe_list
    size-eos: true
    doc: The Universe Discovery Layer’s List of Universes is a packed, numerically sorted list of 16-bit universe addresses. It may be empty if a source is not transmitting on any universes. Otherwise, it shall enumerate all of the universes upon which a source is actively transmitting E1.31 Data or Synchronization information.


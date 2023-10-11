meta:
  id: root_layer

doc: E1.31 shall use the ACN Root Layer Protocol as defined in the ANSI E1.17 [ACN] “ACN Architecture” document. The fields described here are for E1.31 on UDP [UDP]. Alternative Root Layer Protocol (RLP) content may be defined by further standards in order to transport E1.31 on other protocols. Every type of E1.31 packet shall conform to the same RLP structure.

seq:
  - id: preamble_size
    contents: [0x00, 0x10]
    doc: Sources shall set the Preamble Size to 0x0010. Receivers of UDP [UDP]-based E1.31 shall discard the packet if the Preamble Size is not 0x0010. The preamble contains the preamble size field, the post-amble size field, and the ACN packet identifier and has a length of 0x10 octets.

  - id: postamble_size
    contents: [0x00, 0x00]
    doc: There is no post-amble for RLP over UDP [UDP] Therefore, the Post-amble Size is 0x0. Sources shall set the Post-amble Size to 0x0000. Receivers of UDP based E1.31 shall discard the packet if the Post-amble Size is not 0x0000.

  - id: acn_packet_identifier
    contents: [0x41, 0x53, 0x43, 0x2d, 0x45, 0x31, 0x2e, 0x31, 0x37, 0x00, 0x00, 0x00]
    doc: Identifies this packet as E1.17, all packets should contain this sequence, receivers shall discard the packet if the ACN Packet Identifier is not valid.

  - id: flags
    type: b4
    doc: Flags are always 0x7, encoded in the top 4 bits of the byte

  - id: length
    type: b12
    doc: "Length is encoded in the low 12 bits of the 2 bytes. The RLP PDU length is computed starting with octet 16 and counting all remaining octets in the packet. In the case of an E1.31 Data Packet, this includes all of the octets from octet 16 through the last Property Value provided in the DMP layer (NOTE: For a full payload, this count would go through octet 637 and result in a total length of 638). For an E1.31 Synchronization Packet, which has no additional layers, the total length ends at the end of the E1.31 Framing Layer (octet 48, yielding a length of 49). E1.31 Universe Discovery Packet length is computed to the end of the List of Universes field."

  - id: vector
    type: u4be
    doc: Sources shall set the Root Layer's Vector to VECTOR_ROOT_E131_DATA if the packet contains E1.31 Data, or to VECTOR_ROOT_E131_EXTENDED if the packet is for Universe Discovery or for Synchronization. Receivers shall discard the packet if the received value is not VECTOR_ROOT_E131_DATA or VECTOR_ROOT_E131_EXTENDED. These values indicate that the root layer PDU is wrapping a specific E1.31 Framing Layer PDU.
    enum: vector_types

  - id: cid
    size: 16
    doc: The Root Layer contains a CID. The CID shall be a UUID (Universally Unique Identifier) [UUID] that is a 128-bit number that is unique across space and time, compliant with RFC 4122 [UUID]. Each piece of equipment should maintain the same CID for its entire lifetime (e.g. by storing it in read-only memory). This means that a particular component on the network can be identified as the same entity from day to day despite network interruptions, power down, or other disruptions. However, in some systems there may be situations in which volatile components are dynamically created “on the fly” and, in these cases, the controlling process can generate CIDs as required. The choice of UUIDs for CIDs allows them to be generated as required without reference to any registration process or authority. The CID shall be transmitted in network byte order (big endian).


enums:
  vector_types:
    4:
      id: vector_root_e131_data
      doc: packet contains E1.31 Data
      
    8:
      id: vector_root_e131_extended
      doc: Packet is for Universe Discovery or for Synchronization
  # 0111|001001101110 = 622
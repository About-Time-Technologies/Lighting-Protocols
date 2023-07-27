meta:
  id: universe_discovery_framing_layer

seq:
  - id: flags
    type: b4
    doc: Each distinct type of Framing Layer still starts with Flags & Length. The E1.31 Flags & Length field is a 16- bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits.

  - id: length
    type: b12
    doc: "The E1.31 Framing Layer PDU length is computed starting with octet 38 and continuing through the last octet provided by the underlying layer (none, if the E1.31 Framing Layer is followed by no additional payload, as is the case with E1.31 Synchronization Packets). Thus, an E1.31 Data Packet with full payload would have length 638, and an E1.31 Universe Discovery Packet would have length between 120 and 1144, depending on the List of Universes. "

  - id: vector
    contents: [0x00, 0x00, 0x00, 0x02]
    doc: Sources sending E1.31 Universe Discovery Packets shall set the E1.31 Layer's Vector to VECTOR_E131_EXTENDED_DISCOVERY. This value indicates that the E1.31 framing layer is wrapping a Universe Discovery PDU.

  - id: source_name
    type: str
    encoding: utf8
    size: 64
    doc: A user-assigned name provided by the source of the packet for use in displaying the identity of a source to a user. There is no mechanism, other than user configuration, to ensure uniqueness of this name. The source name shall be null-terminated. If the source component implements ACN discovery as defined in EPI 19 [ACN], then this name shall be the same as the UACN field specified in EPI 19 [ACN]. UserAssigned Component Names, as the title suggests, supply a single name for an entire component, so this Source Name field will exist for each unique CID, but may be the same across multiple universes sourced by the same component.

  - size: 4
    doc:  Octets 108-111 of the E1.31 Universe Discovery Packet are reserved for future use. They shall be transmitted as 0 and ignored by receivers.

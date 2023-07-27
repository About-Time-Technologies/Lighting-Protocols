meta:
  id: data_dmp_layer

seq:
  - id: flags
    type: b4
    doc: The DMP Layer's Flags & Length field is a 16-bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits. The DMP Layer PDU length is computed starting with octet 115 and continuing through the last property value provided in the DMP PDU (octet 637 for a full payload). This is the length of the DMP PDU.

  - id: length
    type: b12
    doc: The DMP Layer's Flags & Length field is a 16-bit field with the PDU length encoded in the low 12 bits and 0x7 in the top 4 bits. The DMP Layer PDU length is computed starting with octet 115 and continuing through the last property value provided in the DMP PDU (octet 637 for a full payload). This is the length of the DMP PDU.

  - id: vector
    contents: [0x02]
    doc: The DMP Layer's Vector shall be set to VECTOR_DMP_SET_PROPERTY, which indicates a DMP Set Property message by sources. Receivers shall discard the packet if the received value is not VECTOR_DMP_SET_PROPERTY.

  - id: address_data_type
    contents: [0xa1]
    doc: Sources shall set the DMP Layer's Address Type and Data Type to 0xa1. Receivers shall discard the packet if the received value is not 0xa1.

  - id: first_property_address
    contents: [0x00, 0x00]
    doc: Sources shall set the DMP Layer's First Property Address to 0x0000. Receivers shall discard the packet if the received value is not 0x0000.

  - id: address_increment
    contents: [0x00, 0x01]
    doc: Sources shall set the DMP Layer's Address Increment to 0x0001. Receivers shall discard the packet if the received value is not 0x0001.

  - id: len_property_values
    type: u2be
    doc: The DMP Layer's Property Value Count is used to encode the number of DMX512-A [DMX] Slots (including the START Code slot).

  - id: property_values
    size: len_property_values
    doc: |
      The DMP Layer's Property values field is used to encode the DMX512-A [DMX] START Code and data.

      The first octet of the property values field shall be the DMX512-A [DMX] START Code.

      The remainder of the property values shall be the DMX512-A data slots. This data shall contain a sequence of octet data values that represent a consecutive group of data slots, starting with slot 1, from a DMX512-A packet. The number of data slots encoded in the frame shall not exceed the DMX512-A limit of 512 data slots.

      Processing of Alternate START Code data shall be compliant with ANSI E1.11 [DMX] Section 8.5.3.3 - Handling of Alternate START Code packets by in-line devices.
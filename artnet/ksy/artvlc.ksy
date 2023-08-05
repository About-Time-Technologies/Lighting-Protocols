meta:
  id: artvlc
  title: ArtVlc

doc: |
  ArtVlc is a specific implementation of the ArtNzs packet which is used for the transfer of VLC (Visible Light Communication) data over Art-Net. (The packet's payload can also be used to transfer VLC over a DMX512 physical layer). 

  Fields 2, 6, 11, 12 and 13 should be treated as 'magic numbers' to detect this packet. 

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x51]
    doc: OpNzs (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: sequence
    type: u1
    doc: |
      The sequence number is used to ensure that ArtNzs packets are used in the correct order. 
      When Art-Net is carried over a medium such as the Internet, it is possible that ArtNzs packets will reach the receiver out of order. 

  - id: start_code
    type: u1
    doc: The DMX512 start code of this packet. Must not be Zero or RDM
    valid: 0x91

  - id: port_address
    type: u2le
    doc: 15 bit Port-Address to which this packet is destined

  - id: len_data
    type: u2be
    doc: |
      The length of the data array. This value should be a number in the range 1 - 512.  
      It represents the number of DMX512 channels encoded in packet. 

  - id: magic_number
    contents: [0x41, 0x4C, 0x45]
    doc: Magic number used to identify this packet

  - id: flags
    type: flags
    doc: Bit fields used to control VL C operation. Bits that are unused shall be transmitted as zero.

  - id: data
    size: len_data
    doc: A variable length array of DMX512 lighting data

  - id: trans
    type: u2be
    doc: The transaction number is a 16-bit value which allows VLC transactions to be synchronised. A value of 0 indicates the first packet in a transaction. A value of ffff_16 indicates the final packet in the transaction. All other packets contain consecutive numbers which increment on each packet and roll over to 1 at fffe_16

  - id: slot_address
    type: u2be
    doc: The slot number, range 1-512, of the device to which this packet is directed. A value 0f 0 indicates that all devices attached to this packet's Port-Address should accept the packet. 

  - id: len_payload
    type: u2be
    doc: The 16-bit payload size in the range 0 to 480_10

  - id: payload_checksum
    type: u2be
    doc: The 16-bit unsigned additive checksum of the data in the payload.

  - size: 1
    doc: Transmit as 0, receive does not check

  - id: depth
    type: u1
    doc: The 8-bit VLC modulation depth expressed as a percentage in the range 1 to 100. A value of 0 indicates that the transmitter should use its default value

  - id: frequency
    type: u2be
    doc: The 16-bit modulation frequency of the VLC transmitter expressed in Hz. A value of 0 indicates that the transmitter should use its default value.

  - id: modulation
    type: u2be
    doc: The 16-bit modulation type number that the transmitter should use to transmit VLC. 000016 - Use transmitter default.

  - id: payload_language
    type: u2be
    doc: The 16-bit payload language code. 
    enum: lang_codes

  - id: beacon_repeat_frequency
    type: u2be
    doc: The 16-bit beacon mode repeat frequency. If Flags.Beacon is set, this 16-bit value indicates the frequency in Hertz at which the VLC packet should be repeated. 0000_16 means use transmitter default

  - id: payload
    size: len_payload
    doc: The actual VLC payload
 
types:
  flags:
    seq:
      - id: ieee
        type: b1
        doc: If set, data in the payload area shall be interpreted as IEEE VL C data. If clear, PayLanguage defines the payload contents.

      - id: reply
        type: b1
        doc: If set this is a reply packet that is in response to the request sent with matching number in the transaction number TransHi/Lo. If clear this is not a reply. 

      - id: beacon
        type: b1
        doc: If set, the transmitter should continuously repeat transmission of this packet until another is received. If clear, the transmitter should transmit this packet once

      - type: b5
        doc: Unused, transmit as zero

enums:
  lang_codes:
    0:
      id: beacon_url
      doc: Payload contains a simple text string representing a URL

    1:
      id: beacon_text
      doc: Payload contains a simple ASCII text message.

    2:
      id: beacon_locator_id
      doc: ayload contains a big-endian 16-bit number
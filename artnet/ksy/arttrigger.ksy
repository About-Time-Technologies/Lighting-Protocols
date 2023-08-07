meta:
  id: arttrigger
  title: ArtTrigger

doc: |
  The ArtTrigger packet is used to send trigger macros to the network. The most common implementation involves a single controller broadcasting to all other devices.
  In some circumstances a controller may only wish to trigger a single device or a small group in which case unicast would be used.

  ## Key

  The Key is an 8-bit number which defines the purpose ofthe packet. The interpretation of this field is dependent upon the Oem field. If the Oem field is set to a value other than 0xffff then the Key and SubKey fields are manufacturer specific.
  However, when the Oem field = 0xffff the meaning of the Key, SubKey and Payload is defined by Table 7.

  ## SubKey

  The SubKey is an 8-bit number. The interpretation of this field is dependent upon the Oem field. If the Oem field is set to a value other than ffff16 then the Key and SubKey fields are manufacturer specific.
  However, when the Oem field = ffff16 the meaning of the SubKey field is defined by the table above.

  ## Payload

  The Payload is a fixed length array of 512, 8-bit octets. The interpretation of this fieldis dependent upon the Oem field. If the Oem field is set to a value other than 0xffff then the Payload is manufacturer specific

  | Handling Rules | |
  | -- | -- |
  | **All**   ||
  | Receive          | Application Specific |
  | Unicast Transmit | Application Specific |
  | Broadcast        | Application Specific |

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x99]
    doc: OpCommand (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 2
    doc: Filler, ignore by receiver, set to zero by sender

  - id: oem_code
    type: u2be
    doc: The manufacturer code of nodes that shall accept this trigger
  
  - id: key
    type: u1
    doc: The trigger key
    enum: keys

  - id: sub_key
    type: u1
    doc: The trigger subkey

  - id: data
    size-eos: true
    doc: The interpretation of the payload is defined by the Key

enums:
  keys:
    0:
      id: key_ascii
      doc: The SubKey field contains an ASCII character which the receiving device should process as if it were a keyboard press. (Payload not used).

    1: 
      id: key_macro
      doc: The SubKey field contains the number of a Macro which the receiving device should execute. (Payload not used).

    2: 
      id: key_soft
      doc: The SubKey field contains a soft-key number which the receiving device should process as if it were a soft-key keyboard press. (Payload not used).

    3:
      id: key_show
      doc: The SubKey field contains the number of a Show which the receiving device should run. (Payload not used)
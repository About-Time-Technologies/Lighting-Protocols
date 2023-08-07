meta:
  id: arttimecode
  title: ArtTimeCode

doc: |
  ArtTimeCode allows time code to be transported over the network. The data format is compatible with both longitudinaltime code and MIDI time code. The four key types of Film, EBU, Drop Frame and SMPTE are also encoded.
  Use of the packet is application specific but in general a single controllerwill broadcast the packet to the network.

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
    contents: [0x00, 0x97]
    doc: OpTimeCode (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - size: 2
    doc: Filler, ignore by receiver, set to zero by sender

  - id: frames
    type: u1
    doc: Frames time. 0-29 depending on mode

  - id: seconds
    type: u1
    doc: Seconds. 0-59

  - id: minutes
    type: u1
    doc: Minutes. 0-59

  - id: hours
    type: u1
    doc: Hours. 0-23

  - id: type
    type: u1
    enum: types
    doc: Type of time code format being transmitted

enums:
  types:
    0:
      id: film
      doc: 24fps
    
    1: 
      id: ebu
      doc: 25fps

    2: 
      id: df
      doc: 29.97fps

    3: 
      id: smpte
      doc: 30fps
meta:
  id: artpoll
  title: ArtPoll

doc: |
  The ArtPoll packet is used to discover the presence of other Controllers, Nodes and Media Servers. The ArtPoll packet can be sent by any device, but is usually only sent by the Controller. Both Controllers and Nodes respond to the packet.
  A Controller broadcasts an ArtPoll packet to IP address 2.255.255.255 (sub-net mask 255.0.0.0) at UDP port 0x1936, this is the Directed Broadcast address.
  The Controller may assume amaximum timeout of 3 seconds between sending ArtPoll and receiving all ArtPollReply packets. If the Controller does not receive a response in this time, it should consider the Node to have disconnected.
  The Controller that broadcasts an ArtPoll should also reply to its own message (by unicast) with an ArtPollReply. It is a requirement of Art-Net that all controllers broadcast an ArtPoll every 2.5 to 3 seconds. This ensures that any network devices can easily detect a disconnect.

  ## Multiple Controllers

  Art-Net allows and supports multiple controllers on a network. When there are multiple controllers, Nodes will receive ArtPolls from different controllers which may contain conflicting diagnostics requirements. This is resolved as follows:
  If any controller requests diagnostics, the node will send diagnostics. (ArtPoll->Flags->2).
  If there are multiple controllersrequesting diagnostics, diagnostics shall be broadcast. (Ignore ArtPoll->Flags->3).
  The lowest minimum value of Priority shall be used. (Ignore ArtPoll->DiagPriority).

  ## Targeted Mode

  Targeted mode allows the ArtPoll to define a range of Port-Addresses. Nodes will only reply to the ArtPoll is they are subscribed to a Port-Address that is inclusively in the range TargetPortAddressBottom to TargetPortAddressTop. The bit field ArtPoll->Flags->5 is used to enable Targeted Mode.

  ## Minimum Packet Length

  Consumers of ArtPoll shall accept as valid a packet of length 12 octets or larger. Any missing fields are assumed to be zero. This requirement is due to the fact that the length of ArtPoll has increased over the life of the protocol.

  | Handling Rules | |
  | -- | -- |
  | **All**   ||
  | Receive          | Send ArtPollReply |
  | Unicast Transmit | Allowed, with Targeted Mode. |
  | Directed Broadcast | Controller broadcasts this packet to poll all Controllers and Nodes on the network |
  | Limited Broadcast        | Not recommended |

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00

  - id: opcode
    contents: [0x00, 0x20]
    doc: The OpCode defines the class of data following ArtPoll within this UDP packet. Transmitted little endian. Set to OpPoll

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: flags
    type: flags
    doc: Set behaviour of Node

  - id: diag_priority
    type: u1
    enum: priority_codes

  - id: target_port
    type: u4be
    if: _io.size >= 18 and flags.targeted_mode == true

  - size: 4
    if: _io.size >= 18 and flags.targeted_mode == false

  - id: esta_manufacturer
    type: u2be
    doc: The ESTA Manufacturer Code is assigned by ESTA and uniquely identifies the manufacturer that generated this packet.

  - id: oem
    type: u2be
    doc: The Oem code uniquely identifies the product sending this packet

types:
  flags:
    seq:
      - type: b2
        doc: Unused, transmitted as zero, do not test upon receipt

      - id: targeted_mode
        type: b1
        doc: Enable Targeted Mode

      - id: disable_vlc_transmission
        type: b1
        doc: Disables VLC transmission when set

      - id: diagnostic_unicast
        type: b1
        if: send_diagnostics == true
        doc: Diagnostic messages are unicast

      - type: b1
        if: send_diagnostics == false
        doc: (Ensuring that one bit is consumed)

      - id: send_diagnostics
        type: b1
        doc: Send me diagnostic messages

      - id: artpollreply_on_change
        type: b1
        doc: Send ArtPollReply whenever Node conditions change. This selection allows the Controller to be informed of changes without the need to continously poll

      - type: b1
        doc: Deprecated

enums:
  priority_codes:
    16:
      id: dp_low
      doc: Low priority message

    64: 
      id: dp_med
      doc: Medium priority message

    128:
      id: dp_high
      doc: High priority message

    224:
      id: dp_critical
      doc: Critical priority message

    240:
      id: dp_volatile
      doc: Volatile message. Messages of this type are displayed on a single line in the DMX-Workshop diagnostics display. All other types are displayed in a list box

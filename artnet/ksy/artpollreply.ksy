meta:
  id: artpollreply
  title: ArtPollReply

doc: |
  A device, in response to a Controller's ArtPoll, sends the ArtPollReply. The device should wait for a random delay of up to 1s before sending the reply. This mechanism is intended to reduce packet bunching when scaling up to very large systems.

  ## Minimum Packet Length

  Consumers of ArtPollReplyshall accept as valid a packet of length 198(highlighted in grey below) octets or larger.Any missing fields are assumed to be zero. This requirement is due to the fact that the length of ArtPollReply has increased over the life of the protocol.

  | Handling Rules | |
  | -- | -- |
  | **All**   ||
  | Receive          | No Art-Net action |
  | Unicast Transmit | Allowed |
  | Broadcast        | Not Allowed |

seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00
    
  - id: opcode
    contents: [0x00, 0x21]
    doc: OpPollReply (Transmitted little endian)
    
  - id: ip_address
    type: u4be
    doc: The Node's IP address.When binding is implemented, bound nodes may share the rootnode's IP Address and the BindIndex is used to differentiate the nodes.
    
  - id: port
    contents: [0x36, 0x19]
    doc: The port is always 0x1936 (transmitted little endian)
    
  - id: version_info
    type: u2be
    doc: Node's firmware revision number. The controller should only use this field to decide if a firmware udpate should proceed. The convention is that a higher number is a more recent release of firmware
    
  - id: net_switch
    type: u1
    doc: Bits 14-8 of the 15 bit Port-Address are encoded into the bottom 7 bits of this field. This is used in combination with SubSwitch and SwIn[] or SwOut[] to produce the full universe address.

  - id: sub_switch
    type: u1
    doc: Bits 7-4 of the 15 bit Port-Address are encoded into the bottom 7 bits of this field. This is used in combination with SubSwitch and SwIn[] or SwOut[] to produce the full universe address.

  - id: oem
    type: u2be
    doc: The Oem word unique identifies the product
    
  - id: ubea_version
    type: u1
    doc: This field contains the firmware version of the User Bios Extension Area (UBEA). If the UBEA is not programmed, this field contains zero
  
  - id: status_1
    type: status_1
    doc: General status register containing bit fields
    
  - id: esta_manufacturer
    type: u2le
    doc: |
      The ESTA manufacturer code. These codes are used to represent equipment manufacturer. They are assigned by ESTA.
      This field can be interpreted as two ASCII octets representing the manufacturer initials.
    
  - id: short_name
    type: str
    encoding: utf8
    size: 18
    doc: |
      The array represents a null terminated short name for the Node. The Controller uses the ArtAddress packet to program this string.
      Max length is 17 characters plus the null.
      This is a fixed length field, although the string it contains can be shorter than the field.
    
  - id: long_name
    type: str
    encoding: utf8
    size: 64
    doc: |
      The array represents a null terminated long name for the Node. The Controller uses the ArtAddress packet to program this string.
      Max length is 63 characters plus the null.
      This is a fixed length field, although the string it contains can be shorter than the field.
    
  - id: node_report
    type: str
    encoding: utf8
    size: 64
    doc: |
      The array is a textual report of the Node's operating status or operational errors. It is primarily intended for 'engineering' data rather than 'end user' data. The field is formatted as: “#xxxx [yyyy..] zzzzz…”
      xxxx is a hex status code as defined in Table 3. 
      yyyy is a decimal counter that increments every time the Node sends an ArtPollResponse. This allows the controllerto monitor event changes in the Node.
      zzzz is an English text string defining the status.
      This is a fixed length field, although the string it contains can be shorter than the field.
    
  - id: num_ports
    type: u2be
    doc: |
      The number of input or output ports. If number of inputs is not equal to number of outputs, the largest value is taken. 
      Zero is a legal value if no input or output ports are implemented. The maximum value is 4.
      Nodes can ignore this field as the information is implicit in PortTypes[].
    
  - id: port_types
    type: port_type
    repeat: expr
    repeat-expr: 4
    doc: This array defines the operation and protocol of each channel. (A product with 4 inputs and 4 outputs would report 0xc0, 0xc0, 0xc0, 0xc0). The array length is fixed, independent of the number of inputs or outputs physically available on the Node.
    
  - id: good_inputs
    type: good_input
    repeat: expr
    repeat-expr: 4
    doc: This array defines output status of the node
    
  - id: good_outputs
    type: good_output
    repeat: expr
    repeat-expr: 4
    doc: This array defines output status of the node
    
  - id: sw_in
    type: u1
    repeat: expr
    repeat-expr: 4
    doc: Bits 3-0 of the 15 bit Port-Addressfor each of the 4 possible input ports are encoded into the low nibble.
    
  - id: sw_out
    type: u1
    repeat: expr
    repeat-expr: 4
    doc: Bits 3-0 of the 15 bit Port-Addressfor each of the 4 possible output ports are encoded into the low nibble.
    
  - id: acn_priority
    type: u1
    doc: The sACNpriority value that will be used when any received DMX is converted to sACN.
    
  - id: sw_macro
    type: u1
    doc: |
      If the Node supports macro key inputs, this byte represents the trigger values. The Node is responsible for 'debouncing' inputs. When the ArtPollReplyis set to transmit automatically, (Flags Bit 1), the ArtPollReply will be sent on both key down and key up events. However, the Controllershould not assume that only one bit position has changed.
      The Macro inputs are used for remote event triggering or cueing.
      Bit fields are active high.
    
  - id: sw_remote
    type: u1
    doc: |
      If the Node supports remote trigger inputs, this byte represents the trigger values. The Node is responsible for 'debouncing' inputs. When the ArtPollReply is set to transmit automatically, (Flags Bit 1), the ArtPollReply will be sent on both key down and key up events. However, the Controllershould not assume that only one bit position has changed.
      The Remote inputs are used for remote event triggering or cueing.
      Bit fields are active high.
    
  - size: 3
    doc: Spare, not used, set to 0
    
  - id: style
    type: u1
    enum: style_codes
    doc: The Style code defines the equipment style of the device.
    
  - id: mac
    size: 6
    doc: MAC Address of the node, set to 0 if node cannot supply this information
    
  - id: bind_ip
    type: u4be
    doc: If this unit is part of a larger or modular product, this is the IP of the root device.
    if: _io.size >= 211
    
  - id: bind_index
    type: u1
    doc: This number represents the order of bound devices. A lower number means closer to root device. A value of 0 or 1 means root device.
    if: _io.size >= 212
    
  - id: status_2
    type: status_2
    doc: General status register containing bit fields
    if: _io.size >= 213
    
  - id: good_output_bs
    type: good_output_b
    repeat: expr
    repeat-expr: 4
    doc: This array defines output status of the node
    if: _io.size >= 217
    
  - id: status_3
    type: status_3
    doc: General status register containing bit fields
    if: _io.size >= 218

  - id: default_responder_uuid
    size: 6
    doc: RDMnet & LLRP Default Responder UID
    if: _io.size >= 224

  - id: user
    type: u2be
    doc: Available for user specific data
    if: _io.size >= 226

  - id: refresh_rate
    type: u2be
    doc: RefreshRate allows the device to specify the maximum refresh rate, expressed in Hz, at which it can process ArtDmx. This is designed to allow refresh rates above DMX512 rates, for gateways that implement
    if: _io.size >= 228

  - size: 11
    doc: Filler, transmit as 0 for future expansion
    if: _io.size >= 239

    
types:
  status_1:
    seq:
      - id: indicator_status
        type: b2
        enum: indicator_state
        doc: Indicator state (unknown, locate, mute or normal)
        
      - id: port_address_authority
        type: b2
        enum: papa
        doc: Port Address Programming Authority
        
      - type: b1
        doc: Not implemented, transmit as zero, receivers do not test
      
      - id: booted_from_rom
        type: b1
        doc: Booted from ROM instead of normal firmware boot (from flash). Nodes that do not support dual boot clear this field (false)
        
      - id: rdm_supported
        type: b1
        doc: Device is capable of Remote Device Management (RDM)
        
      - id: ubea_present
        type: b1
        doc: UBEA is present in this packet

  status_2:
    seq:
      - id: supports_web_config
        type: b1
        doc: Product supports web browser configuration
        
      - id: ip_dhcp_configured
        type: b1
        doc: Node's IP is DHCP configured instead of manually configured
        
      - id: supports_dhcp
        type: b1
        doc: Node is DHCP capable
        
      - id: supports_15b_port_address
        type: b1
        doc: Node supports 15-bit port addresses (instead of 8-bit port addresses from Art-Net II)
        
      - id: supports_sacn_artnet_switching
        type: b1
        doc: Node is able to switch between Art-Net and sACN
        
      - id: squawking
        type: b1
        doc: Node is squawking
        
      - id: supports_artcommand_switch
        type: b1
        doc: Node supports switching of output style using ArtCommand
        
      - id: supports_artcommand_rdm
        type: b1
        doc: Node supports control of RDM using ArtCommand

  status_3:
    seq:
      - id: failsafe
        type: b2
        enum: failsafe_state
        doc: Failsafe state meaning how the node behaves in the event that network data is lost
        
      - id: supports_failover
        type: b1
        doc: Node supports fail-over
        
      - id: supports_llrp
        type: b1
        doc: Node supports LLRP
        
      - id: supports_io_switching
        type: b1
        doc: Node supports switching ports between input and output (PortTypes[] shows the current direction)
        
      - type: b3
        doc: Not used, set to 0
        
  port_type:
    seq:
      - id: outputs_artnet
        type: b1
        doc: This channel can output data from the Art-Net network

      - id: inputs_artnet
        type: b1
        doc: This channel can input data onto the Art-Net network

      - id: format
        type: b6
        enum: port_type_format
        doc: The format of data this port interacts with

  good_input:
    seq:
      - id: data_received
        type: b1
        doc: Data has been received on this port

      - id: includes_test
        type: b1
        doc: This channel includes DMX512 test packets

      - id: includes_sips
        type: b1
        doc: This channel includes DMX512 SIP's packets

      - id: includes_text
        type: b1
        doc: This channel includes DMX512 text packets

      - id: disabled
        type: b1
        doc: Input is disabled

      - id: errors_detected
        type: b1
        doc: Receive errors have been detected on this input

      - type: b2
        doc: Unused and transmitted as zero

  good_output:
    seq:
      - id: data_transmitted
        type: b1
        doc: Data has been transmitted on this output

      - id: includes_test
        type: b1
        doc: This channel includes DMX512 test packets

      - id: includes_sips
        type: b1
        doc: This channel includes DMX512 SIP's packets

      - id: includes_text
        type: b1
        doc: This channel includes DMX512 text packets

      - id: merging
        type: b1
        doc: Otuput is merging Art-Net data

      - id: dmx_output_short
        type: b1
        doc: DMX output short detected on power up

      - id: merge_ltp
        type: b1
        doc: Merge mode is LTP

      - id: transmit_sacn
        type: b1
        doc: Output is selected to transmit sACN
    
  good_output_b:
    seq:
      - id: rdm_disabled
        type: b1
        doc: RDM is disabled on this output

      - id: output_continuous
        type: b1
        doc: Output style is continuous instead of delta

      - type: b6
        doc: Not used, set to zero

enums:
  port_type_format:
    0: dmx512
    1: midi
    2: avab
    3: colortran_cmx
    4: adb625
    5: art_net
    6: dali

  failsafe_state:
    0: hold_last
    1: zero
    2: full
    3: safe_scene

  indicator_state:
    0: unknown
    1: locate
    2: mute
    3: normal

  papa:
    0: unknown
    1: front_panel
    2: network
    3: invalid

  style_codes:
    0: st_node
    1: st_controller
    2: st_media
    3: st_route
    4: st_backup
    5: st_config
    6: st_visual
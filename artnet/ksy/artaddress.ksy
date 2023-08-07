# Development Notes

meta:
  id: artaddress
  title: ArtAddress

doc: |
  A Controlleror monitoring device on the network can reprogram numerous controls of a node remotely. This,for example, would allow the lighting console to re-route DMX512 data at remote locations. This is achieved by sending an ArtAddress packet to the Node’s IP address. (The IP address is returned in the ArtPoll packet). The node replies with an ArtPollReply packet.
  Fields 5 to 13 contain the data that will be programmed into the node

  | Handling Rules | |
  | -- | -- |
  | **Controller** | |
  | Receive | No Action |
  | Unicast Transmit | Controller transmits to a specific node IP address. |
  | Broadcast | Not Allowed |
  | **Node** | |
  | Receive | Reply by unicasting ArtPollReply |
  | Unicast Transmit | Not Allowed |
  | Broadcast | Not Allowed |
  | **Media Server** | |
  | Receive | Reply by unicasting ArtPollReply |
  | Unicast Transmit | Not Allowed |
  | Broadcast | Not Allowed |
  
seq:
  - id: id
    contents: [0x41, 0x72, 0x74, 0x2d, 0x4e, 0x65, 0x74, 0x00]
    doc: | 
      Array of 8 characters, the final character is a null termination.
      Value = 'A' 'r' 't' '-' 'N' 'e' 't' 0x00
    
  - id: opcode
    contents: [0x00, 0x60]
    doc: OpAddress (transmitted little endian)

  - id: proto_version
    contents: [0x00, 0x0e]
    doc: Protocol version (constant 14, transmitted big endian)

  - id: net_switch
    type: u1
    doc: |
      Bits 14-8 of the 15 bit Port-Address are encoded into the bottom 7 bits of this field. This is used in combination with SubSwitch and SwIn[] or SwOut[] to produce the full universe address.
      This value is ignored unless bit 7 is high. i.e. to program a value 0x07, send the value as 0x87.
      Send 0x00 to reset this value to the physical switch setting.

  - id: bind_index
    type: u1
    doc: |
      The BindIndex defines the bound node which originated this packet and is used to uniquely identify the bound node when identical IP addresses are in use. This number represents the order of bound devices. A lower number means closer to root device.
      A value of 1 meansroot device.

  - id: short_name
    type: str
    encoding: utf8
    size: 18
    doc: |
      The array represents a nullterminated short name for the Node. The Controlleruses the ArtAddress packet to program this string. Max length is 17 characters plus the null. The Node will ignore this value if the string is null.
      This is a fixed length field, although the string it contains can be shorter than the field.

  - id: long_name
    type: str
    encoding: utf8
    size: 64
    doc: |
      The array represents a null terminated long name for the Node. The Controlleruses the ArtAddress packet to program this string. Max length is 63 characters plus the null. The Node will ignore this value if the string is null.
      This is a fixed length field, although the string it contains can be shorter than the field.

  - id: sw_in
    type: u1
    repeat: expr
    repeat-expr: 4
    doc: |
      Bits 3-0 of the 15 bit Port-Addressfor a given input port are encoded into the bottom 4 bits of this field.
      This is used in combination with NetSwitch and SubSwitch to produce the full universe address.
      This value is ignored unless bit 7 is high. i.e. to program a value 0x07, send the value as 0x87.
      Send 0x00 to reset this value to the physical switch setting

  - id: sw_out
    type: u1
    repeat: expr
    repeat-expr: 4
    doc: |
      Bits 3-0 of the 15 bit Port-Addressfor a given input port are encoded into the bottom 4 bits of this field.
      This is used in combination with NetSwitch and SubSwitch to produce the full universe address.
      This value is ignored unless bit 7 is high. i.e. to program a value 0x07, send the value as 0x87.
      Send 0x00 to reset this value to the physical switch setting

  - id: sub_switch
    type: u1
    doc: |
      Bits 7-4 of the 15 bit Port-Address are encodedinto the bottom 4 bits of this field. This is used in combination with NetSwitch and SwIn[] or SwOut[] to produce the full universe address.
      This value is ignored unless bit 7 is high. i.e. to program a value 0x07, send the value as 0x87.
      Send 0x00 to reset this value to the physical switch setting

  - id: acn_priority
    type: u1
    doc: |
      Sets the sACN Priority field for sACN generated on all 4 ports encoded into this packet. A value of 255 represents no change. Values of 0 to 200 inclusive are valid.

  - id: command
    type: u1
    enum: command
    doc: Node configuration command

enums: 
  command:
    0: 
      id: ac_none
      doc: No action
    1: 
      id: ac_cancel_merge
      doc: |
        If Node is currently in merge mode, cancel merge mode upon receipt of next ArtDmx packet. 
        See discussion of merge operation
    
    2: 
      id: ac_led_normal
      doc: The front panel indicators of the Node operate normally
    
    3: 
      id: ac_led_mute
      doc: The front panel indicators of the Node are disabled and switched off
    
    4: 
      id: ac_led_locate
      doc: Rapid flashing of the Node's front panel indicators. It is intended as an outlet identifiers for large installations
    
    5: 
      id: ac_reset_rx_flags
      doc: |
        Resets the Node's Sip, Text, Test and data error flags. 
        If an output short is being flagged, forces the test to re-run
    
    6: 
      id: ac_analysis_on
      doc: Enable analysis and debugging mode
    
    7: 
      id: ac_analysis_off
      doc: Diable analysis and debugging mode
    
    8:  
      id: ac_fail_hold
      doc: Set the node to hold last state in the event of loss of network data
    
    9: 
      id: ac_fail_zero
      doc: Set the node's output to zero in the event of loss of network data
    
    10:  
      id: ac_fail_full
      doc: Set the node's output to full in the event of loss of network data
    
    11:  
      id: ac_fail_scene
      doc: Set the node's outputs to play the failsafe scene in the event of loss of network data
    
    12:  
      id: ac_fail_record
      doc: Record the current output state as the failsafe scene

    16: 
      id: ac_merge_ltp_0
      doc: Set DMX Port 0 to Merge in LTP mode.

    17: 
      id: ac_merge_ltp_1
      doc: Set DMX Port 1 to Merge in LTP mode.

    18: 
      id: ac_merge_ltp_2
      doc: Set DMX Port 2 to Merge in LTP mode.

    19: 
      id: ac_merge_ltp_3
      doc: Set DMX Port 3 to Merge in LTP mode.

    32: 
      id: ac_direction_tx_0
      doc: Set Port 0 direction to output.

    33: 
      id: ac_direction_tx_1
      doc: Set Port 1 direction to output.

    34: 
      id: ac_direction_tx_2
      doc: Set Port 2 direction to output.

    35: 
      id: ac_direction_tx_3
      doc: Set Port 3 direction to output.

    48: 
      id: ac_direction_rx_0
      doc: Set Port 0 direction to input.

    49: 
      id: ac_direction_rx_1
      doc: Set Port 1 direction to input.

    50: 
      id: ac_direction_rx_2
      doc: Set Port 2 direction to input.

    51: 
      id: ac_direction_rx_3
      doc: Set Port 3 direction to input.

    80: 
      id: ac_merge_htp_0
      doc: Set DMX Port 0 to Merge in HTP (default) mode.

    81: 
      id: ac_merge_htp_1
      doc: Set DMX Port 1 to Merge in HTP (default) mode.

    82: 
      id: ac_merge_htp_2
      doc: Set DMX Port 2 to Merge in HTP (default) mode.

    83: 
      id: ac_merge_htp_3
      doc: Set DMX Port 3 to Merge in HTP (default) mode.

    96: 
      id: ac_art_net_sel_0
      doc: Set DMX Port 0 to output both DMX512 and RDM packets from the Art-Net protocol (default).

    97: 
      id: ac_art_net_sel_1
      doc: Set DMX Port 1 to output both DMX512 and RDM packetsfrom the Art-Net protocol (default).

    98: 
      id: ac_art_net_sel_2
      doc: Set DMX Port 2 to output both DMX512 and RDM packets from the Art-Net protocol (default).

    99: 
      id: ac_art_net_sel_3
      doc: Set DMX Port 3 to output both DMX512 and RDM packets from the Art-Net protocol (default).

    112: 
      id: ac_acn_sel_0
      doc: Set DMX Port 0 to output DMX512 data from the sACNprotocol and RDM data from the Art-Net protocol.

    113: 
      id: ac_acn_sel_1
      doc: Set DMX Port 1 to output DMX512 data from the sACN protocol and RDM data from the Art-Net protocol.

    114: 
      id: ac_acn_sel_2
      doc: Set DMX Port 2 to output DMX512 data from the sACN protocol and RDM data from the Art-Net protocol.

    115: 
      id: ac_acn_sel_3
      doc: Set DMX Port 3 to output DMX512 data from the sACN protocol and RDM data from the Art-Net protocol.

    144: 
      id: ac_clear_op_0
      doc: Clear DMX Output buffer for Port 0 

    145: 
      id: ac_clear_op_1
      doc: Clear DMX Output buffer for Port 1

    146: 
      id: ac_clear_op_2
      doc: Clear DMX Output buffer for Port 2 

    147: 
      id: ac_clear_op_3
      doc: Clear DMX Output buffer for Port 3

    160: 
      id: ac_style_delta_0
      doc: Set output style to delta mode (DMX frame triggered by ArtDmx) for Port 0

    161: 
      id: ac_style_delta_1
      doc: Set output style to delta mode (DMX frame triggered by ArtDmx) for Port 1

    162: 
      id: ac_style_delta_2
      doc: Set output style to delta mode (DMX frame triggered by ArtDmx) for Port 2

    163: 
      id: ac_style_delta_3
      doc: Set output style to delta mode (DMX frame triggered by ArtDmx) for Port 3

    176: 
      id: ac_style_const_0
      doc: Set output style to constant mode (DMX output is continuous) for Port 0

    177: 
      id: ac_style_const_1
      doc: Set output style to constant mode (DMX output is continuous) for Port 1

    178: 
      id: ac_style_const_2
      doc: Set output style to constant mode (DMX output is continuous) for Port 2

    179: 
      id: ac_style_const_3
      doc: Set output style to constant mode (DMX output is continuous) for Port 3

    192: 
      id: ac_rdm_enable_0
      doc: Enable RDM for Port 0

    193: 
      id: ac_rdm_enable_1
      doc: Enable RDM for Port 1

    194: 
      id: ac_rdm_enable_2
      doc: Enable RDM for Port 2

    195: 
      id: ac_rdm_enable_3
      doc: Enable RDM for Port 3

    208: 
      id: ac_rdm_disable_0
      doc: Disable RDM for Port 0

    209: 
      id: ac_rdm_disable_1
      doc: Disable RDM for Port 1

    210: 
      id: ac_rdm_disable_2
      doc: Disable RDM for Port 2

    211: 
      id: ac_rdm_disable_3
      doc: Disable RDM for Port 3

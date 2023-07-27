meta:
  id: data_packet
  imports:
    - ./dmp-layer
    - ./framing-layer
    - ../root-layer

seq:
  - id: root
    type: root_layer

  - id: framing
    type: data_framing_layer
    
  - id: dmp
    type: data_dmp_layer
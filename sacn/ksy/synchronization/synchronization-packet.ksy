meta:
  id: synchronization_packet
  imports:
    - ./framing-layer
    - ../root-layer

seq:
  - id: root
    type: root_layer
    
  - id: framing
    type: synchronization_framing_layer
meta:
  id: universe_discovery_packet
  imports:
    - ./framing-layer
    - ./ud-layer
    - ../root-layer

seq:
  - id: root
    type: root_layer
    
  - id: framing
    type: universe_discovery_framing_layer

  - id: discovery
    type: ud_layer
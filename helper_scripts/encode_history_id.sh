#!/bin/bash
# 

# version 1.0.0 


###REPLACE###    cd GALAXYROOT

. .venv/bin/activate

python scripts/secret_decoder_ring.py  encode $1

deactivate




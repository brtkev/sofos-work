#!bin/bash

cds build --production
mbt build -t gen --mtar mta.tar  
cf deploy gen/mta.tar
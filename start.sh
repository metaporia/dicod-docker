#!/bin/bash
touch /home/pedantry/dicod.log && \
    service dicod start && \
    tail -f /home/pedantry/dicod.log

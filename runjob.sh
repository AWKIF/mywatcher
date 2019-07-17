#!/bin/sh
echo "Launching job $1"
sleep $(((RANDOM % 10 + 3)))
#not working always exit 0
exit $(((RANDOM % 2)))
#exit 1

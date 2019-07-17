#!/bin/bash
#set -x
watchdir=.


# Check if jobs success or failed & retry
function check {
  local n=1
  local max=3
  local delay=2
  while true; do
    "$@" && echo "Deleting file $3" && rm -f $3.processing && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay;
      else
        echo "The command has failed after $n attempts."
        exit 1
      fi
    }
  done
}


function runningjobs {
  if [ "$(jobs -rp | wc -l)" -ge "3" ]; then  
    wait
  fi
}

while true; do

  for filename in $(ls ${watchdir}/[a-z]*:[0-9]*:[a-z]* 2> /dev/null|grep -v processing 2> /dev/null); do
     runningjobs
     printf "Processing $filename \n"
     jobId=$(echo $filename|awk -F":" '{print $2}')
     mv $filename $filename.processing
     check ./runjob.sh $jobId $filename &
  done

done

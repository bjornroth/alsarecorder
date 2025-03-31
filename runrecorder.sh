#!/bin/bash

while [ -z "$(arecord -l 2>&1 | grep 'card 0' | tr -d '\n')" ]
do
  echo "No sound card, waiting..."
  zenity --timeout 5 --info --text "No sound card, waiting..."
done

while [ -z "$(mount | grep Sandisk | tr -d '\n')" ]
do
  echo "No 'Sandisk' USB drive, waiting..."
  zenity --timeout 5 --info --text "No 'Sandisk' USB drive, waiting..."
done

CHANNELS=$(captureinfo | grep "Max channels" | cut -d: -f2)
SAMPLERATE=$(captureinfo | grep "Min sample rate" | cut -d: -f2)
FORMAT=$(arecord -D hw:0,0 --dump-hw-params 2>&1 | grep -A 1 "Available formats" | grep -v : | cut -d" " -f2)
DATE=$(date +'%Y-%m-%d-%k-%M-%S')
FILEPATH="/media/br/Sandisk"
FILENAME="${FILEPATH}/${DATE}.wav"

echo "Recording $CHANNELS $SAMPLERATE $FORMAT to $FILENAME"
zenity --info --text "Recording $CHANNELS $SAMPLERATE $FORMAT to $FILENAME"

arecord -D hw:0,0 -f $FORMAT -r $SAMPLERATE -c $CHANNELS $FILENAME &

while true ;
do
  FILESIZE=$(ls -l $FILENAME | cut -d' ' -f5)
  zenity --timeout 5 --warning --text "Recording: $FILESIZE"
  RETCODE=$?
  if [ "$RETCODE" -eq "0" ] ; then
    break
  fi
done

echo "Killing arecord"
killall arecord 2> /dev/null

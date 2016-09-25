#!/bin/bash
#
#Lossless h264 RTP streaming
#Requires: GStreamer bad and ugly plugins
#
#
#Improvements for speed:
# PRESET ultrafast
# TUNE zerolatency
#
#NOTE: on rpi the x264enc becomes omxh264enc  
CAP=videotestsrc
ENCODER="x264enc pass=qual quantizer=0 ! video/x-h264,profile=high-4:4:4"
SINK=udpsink
SOURCE=udpsrc
while [ 1 -eq 1 ]
do 
	if [ $1 == "x11" ]; then
		CAP="ximagesrc use-damage=0"
		echo "x11"
		shift
	elif [ $1 == "rpi" ]; then
		ENCODER="omxh264enc"
		echo "rpi"
		shift
	elif [ $1 == "tcp" ]; then
		echo "tcp"
		SINK=tcpserversink
		SOURCE=tcpclientsrc
		shift
	else
		break
	fi
done

ADJUST="video/x-raw,format=BGRx,framerate=25/1 ! videoconvert"

PACKER="rtph264pay config-interval=1 pt=96"

DECODER="h264parse ! avdec_h264"
UNPACKER="application/x-rtp ! rtph264depay"

FINAL=autovideosink
: ${TARGET:="127.0.0.1"}
PORT=9078

if [ $1 == 'cap' ]; then
	OUTPUT="udpsink host=$TARGET port=$PORT"
	if [ $2 == 'show' ]; then
		echo "Capture and Show"
		w="gst-launch-1.0 $CAP ! tee name="local" ! queue ! autovideosink   local. ! $ENCODER ! $PACKER ! $OUTPUT"
	else
		echo "Capture"
		w="gst-launch-1.0 $CAP ! $ENCODER ! $PACKER ! $OUTPUT"
	fi
	w="gst-launch-1.0 $CAP ! $ADJUST ! $ENCODER ! $PACKER ! $SINK host=$TARGET port=$PORT"
	echo $w
	$w
elif [ $1 == 'play' ]; then
	echo "Playback"
	w="gst-launch-1.0 $SOURCE port=$PORT ! $UNPACKER ! $DECODER ! $FINAL"
	echo $w
	$w
else
	echo "Use cap or play"
fi
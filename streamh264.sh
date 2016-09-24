#!/bin/bash
#
#Lossless h264 RTP streaming
#Requires: GStreamer bad and ugly plugins
#
#
#Improvements for speed:
# PRESET ultrafast
# TUNE zerolatency

CAP="ximagesrc use-damage=0"
CAP=videotestsrc

ADJUST="video/x-raw,format=BGRx,framerate=25/1 ! videoconvert"

ENCODER="x264enc pass=qual quantizer=0 ! video/x-h264,profile=high-4:4:4"
PACKER="rtph264pay config-interval=1 pt=96"

DECODER="h264parse ! avdec_h264"
UNPACKER="application/x-rtp ! rtph264depay"

FINAL=autovideosink
TARGET=127.0.0.1
PORT=9078

if [ $1 == 'cap' ]; then
	echo "Capture"
	w="gst-launch-1.0 $CAP ! $ADJUST ! $ENCODER ! $PACKER ! udpsink host=$TARGET port=$PORT"
	echo $w
	$w
elif [ $1 == 'play' ]; then
	echo "Playback"
	w="gst-launch-1.0 udpsrc port=$PORT ! $UNPACKER ! $DECODER ! $FINAL"
	echo $w
	$w
else
	echo "Use cap or play"
fi
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

ENCODER="jpegenc"
PACKER="rtpjpegpay pt=96"

DECODER="jpegdec"
UNPACKER="application/x-rtp,payload=96 ! rtpjpegdepay"

FINAL=autovideosink
TARGET=127.0.0.1
PORT=9078

if [ $1 == 'cap' ]; then
	echo "Capture"
	w="gst-launch-1.0 $CAP ! $ENCODER ! $PACKER ! udpsink host=$TARGET port=$PORT"
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
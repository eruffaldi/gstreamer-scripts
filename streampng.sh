#!/bin/bash
#
#Lossless h264 RTP streaming
#Requires: GStreamer bad and ugly plugins
#
#
#Improvements for speed:
# PRESET ultrafast
# TUNE zerolatency

CAPX11="ximagesrc use-damage=0"
: ${CAP:="videotestsrc"}

ENCODER="pngenc"
PACKER="rtpgstpay config-interval=1"

DECODER="image/png ! pngdec"
GSTCAPS=""
UNPACKER="application/x-rtp,encoding-name=X-GST,clock-rate=90000,media=application,payload=96 ! rtpgstdepay"

FINAL=autovideosink
TARGET=127.0.0.1
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
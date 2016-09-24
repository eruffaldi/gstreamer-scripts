#!/bin/bash
#
# Stream JPEG over RTP
#
CAPX11="ximagesrc use-damage=0"
: ${CAP:="videotestsrc"}

ENCODER="jpegenc"
PACKER="rtpjpegpay pt=96"

DECODER="jpegdec"
UNPACKER="application/x-rtp,payload=96 ! rtpjpegdepay"

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
#!/bin/bash
#
# Stream PNG over custom RTP
#
#
ENCODER="pngenc"
PACKER="rtpgstpay config-interval=1"
DECODER="image/png ! pngdec"
GSTCAPS=""
UNPACKER="application/x-rtp,encoding-name=X-GST,clock-rate=90000,media=application,payload=96 ! rtpgstdepay"

: ${RATE:="25"}

ADJUST="video/x-raw,framerate=$RATE/1"

CAP=videotestsrc
FINAL=autovideosink

SINK=udpsink
SOURCE=udpsrc
: ${RATE:="25"}
: ${TARGET:="127.0.0.1"}
: ${PORT:="9078"}
: ${CAPDISPLAY:=":0"}

while [ 1 -eq 1 ]
do 
	if [ $1 == "x11" ]; then
		CAP="ximagesrc use-damage=0 display-name=$CAPDISPLAY"
		echo "x11"
		shift
	elif [ $1 == "tcp" ]; then
		echo "tcp - use it with SSH -L flag"
		SINK=tcpserversink
		SOURCE=tcpclientsrc
		shift
	else
		break
	fi
done



if [ $1 == 'cap' ]; then
	OUTPUT="$SINK host=$TARGET port=$PORT"
	if [ "$2" == 'show' ]; then
		echo "Capture and Show"
		w="gst-launch-1.0 $CAP ! tee name="local" ! queue ! autovideosink   local. ! $ENCODER ! $PACKER ! $OUTPUT"
	else
		echo "Capture"
		w="gst-launch-1.0 $CAP ! $ADJUST ! $ENCODER ! $PACKER ! $OUTPUT"
	fi
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

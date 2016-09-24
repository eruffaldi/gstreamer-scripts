# gstreamer-scripts
GStreamer 1.0 scripts for various reasons

# Ideas and Futures

- example to store
- webcam h264 c920 Logitech
	v4l2src device=/dev/video0 ! video/x-h264,width=640,height=480,framerate=15/1
	vs
	v4l2src device=/dev/video0 !video/x-raw,format=YUY2,width=640,height=480,framerate=15/1

	then decode as: h264parse ! avdec_h264 ! ...
	or store as: h264parse ! ...
- kinect2 example gstreamer: https://github.com/yoshimoto/gspca-kinect2

# Links

- http://www.z25.org/static/_rd_/videostreaming_intro_plab/
- https://gstreamer.freedesktop.org/documentation/plugins.html
- https://gstreamer.freedesktop.org/data/doc/gstreamer/head/manual/html/index.html
# Space-Opera-Projections
 
ffmpeg -i http://192.168.1.147:8080/video -vf format=yuyv422 -f v4l2 /dev/video4




ffmpeg -re \
       -thread_queue_size 512 \
       -fflags nobuffer \
       -flags low_delay \
       -i http://<Android-IP>:8080/video \
       -vf fps=30,format=yuyv422 \
       -vsync drop \
       -f v4l2 /dev/video4

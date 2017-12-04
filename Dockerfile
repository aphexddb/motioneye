# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# motionEye build intsructions via https://github.com/ccrisan/motioneye/wiki/Install-On-Ubuntu
RUN add-apt-repository -y ppa:jonathonf/ffmpeg-3
RUN apt-get update
RUN apt-get install -y motion ffmpeg v4l-utils libav-tools x264 x265
RUN apt-get install -y python-pip python-dev curl libssl-dev libcurl4-openssl-dev libjpeg-dev
RUN pip install motioneye

# media directory
RUN mkdir -p /var/lib/motioneye

EXPOSE 8765
EXPOSE 7999

ADD ./docker_files /

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
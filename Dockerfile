# Base on Debian stable
FROM debian:stable
LABEL MAINTAINER Carl-Fredrik Enell (carl-fredrik.enell@eiscat.se)

# Install octave and dependencies
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install octave
RUN apt-get -y install bzip2 procps curl
RUN apt-get -y install epstool fig2dev ffmpeg

# Copy software
COPY *.m /opt/remtg/
COPY movieg /opt/remtg/

# Create mount points
VOLUME	["/srv/data","/srv/info", "/var/tmp"]

# Define program to run
WORKDIR  "/var/tmp"
ENTRYPOINT ["/opt/remtg/movieg"]
CMD ["/srv/data","/srv/info/rtg_def.m"]

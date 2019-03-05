# Base on Debian stable
FROM debian:stable

LABEL Maintainer Carl-Fredrik Enell (carl-fredrik.enell@eiscat.se)

# Install octave and dependencies
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install octave
RUN apt-get -y install bzip2 procps curl
RUN apt-get -y install epstool fig2dev ffmpeg

# Copy software to container
COPY *.m /opt/remtg/
COPY movieg /opt/remtg/

# Create mount point in container
RUN mkdir /srv/data

# Define program to run
WORKDIR  "/var/tmp"
ENTRYPOINT ["/opt/remtg/movieg"]


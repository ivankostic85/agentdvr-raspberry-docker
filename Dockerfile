# To compile opencv, check this out :
# https://gist.github.com/willprice/abe456f5f74aa95d7e0bb81d5a710b60
FROM arm32v7/debian:buster
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Europe/Paris

COPY ./scripts/download-opencv.sh /scripts/download-opencv.sh
COPY ./scripts/install-deps.sh /scripts/install-deps.sh
COPY ./scripts/build-opencv.sh /scripts/build-opencv.sh
RUN ls -la /scripts

RUN cd /scripts && chmod +x *.sh
RUN /scripts/download-opencv.sh
RUN /scripts/install-deps.sh

RUN apt-get purge -y libreoffice*
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN apt-get autoremove -y
RUN apt-get update && apt-get install -y unzip wget libtbb-dev libc6-dev \
    multiarch-support gss-ntlmssp software-properties-common apt-utils \
    gpg-agent ca-certificates ffmpeg
RUN apt-get install -y devscripts debhelper cmake libldap2-dev libgtkmm-3.0-dev libarchive-dev \
                        libcurl4-openssl-dev intltool
RUN apt-get install -y build-essential cmake pkg-config libjpeg-dev libtiff5-dev \
    # libjasper-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libgtk2.0-dev libgtk-3-dev \
    libatlas-base-dev libblas-dev \
    # libeigen{2,3}-dev
    liblapack-dev \
    gfortran \
    python3-dev python3-pip python3
RUN pip3 install -U pip
RUN pip3 install numpy

RUN wget https://ispyfiles.azureedge.net/downloads/Agent_ARM32_3_2_2_0.zip -O agent.zip;
RUN unzip agent.zip -d /agent && \
    rm agent.zip


RUN wget https://download.visualstudio.microsoft.com/download/pr/d5c26b6d-dd45-4124-a72b-8240b0631f40/3cf24631a82b5b1c39afb1329a3e2f4b/aspnetcore-runtime-3.1.13-linux-arm.tar.gz
RUN mkdir /dotnet
RUN tar zxf aspnetcore-runtime-3.1.13-linux-arm.tar.gz -C /dotnet

RUN mkdir /scripts
RUN ./build-opencv.sh
RUN cd /opencv/opencv-4.1.2/build && make install
# COPY ./ocvbuild /opencv

# RUN cd /opencv && make install

# Define default environment variables
ENV DOTNET_ROOT=/dotnet
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opencv:/opencv/opencv-4.1.2/build:/dotnet

# Main UI port
EXPOSE 8090

# TURN server port
EXPOSE 3478/udp

# TURN server UDP port range
EXPOSE 50000-50010/udp

# Data volumes
VOLUME ["/agent/Media/XML", "/agent/Media/WebServerRoot/Media", "/agent/Commands"]

# Define service entrypoint
CMD ["dotnet", "/agent/Agent.dll"]

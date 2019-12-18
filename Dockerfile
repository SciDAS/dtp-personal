FROM ubuntu:latest

RUN  apt-get update \
  && apt-get install -y wget gnupg2 lsb-release git python \
  && rm -rf /var/lib/apt/lists/*

## NDN

# Install ndn-cxx

RUN apt install build-essential libboost-all-dev libssl-dev \
  libsqlite3-dev pkg-config python-minimal

RUN git clone https://github.com/named-data/ndn-cxx.git \
  && cd ndn-cxx

RUN ./waf configure && ./waf && ./waf install
RUN echo /usr/local/lib | tee /etc/ld.so.conf.d/ndn-cxx.conf
RUN ldconfig

## iRODs 

RUN git clone https://github.com/irods/irods.git \
  && cd irods \
  && git checkout 4-2-stable

RUN python ./install_prerequisites
RUN make server


ENTRYPOINT ["/bin/bash"]



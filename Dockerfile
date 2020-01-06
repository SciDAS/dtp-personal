FROM ubuntu:16.04

# Install basic packages
RUN  apt-get update -qq \
  && apt-get install -qq -y apt-transport-https curl git unzip wget gnupg2 lsb-release python \
  && rm -rf /var/lib/apt/lists/*

# Add non-root user
RUN groupadd -g 61000 dtpuser \
  && useradd -g 61000 --no-log-init --create-home --shell /bin/bash -u 61000 dtpuser

USER dtpuser
WORKDIR /home/dtpuser


## Aspera

RUN wget https://download.asperasoft.com/download/sw/connect/3.9.8/ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.tar.gz \
  && tar -xvf ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.tar.gz

RUN chmod +x ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.sh \
  && ./ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.sh \
  && rm ibm-aspera-connect-3.9.8.176272-linux-g2.12-64.*

USER root
WORKDIR /root

RUN mv /home/dtpuser/.aspera /opt/aspera

ENV PATH "$PATH:/opt/aspera/connect/bin"

# Install the SRA toolkit.
RUN wget -q https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.0/sratoolkit.2.10.0-ubuntu64.tar.gz \
  && tar -xf sratoolkit.2.10.0-ubuntu64.tar.gz \
  && mv sratoolkit.2.10.0-ubuntu64 /usr/local/sratoolkit.2.10.0

ENV PATH "$PATH:/usr/local/sratoolkit.2.10.0/bin"

# We need Python for the retrieve_sra.py script that comes with GEMmaker
RUN apt-get update && apt-get install -qq -y python3-pip \
  && pip3 install -q numpy pandas xmltodict requests

# The SRAToolkit needs a missing perl module
RUN apt-get install -qq -y libxml2-dev && cpan install -T XML::LibXML && cpan install -T URI

# Create OpenSSH key for Aspera

RUN apt-get -y install openssh-client
RUN ssh-keygen -q -t rsa -f /root/.ssh/aspera_id_rsa




## NDN

# Install ndn-cxx

#RUN apt install build-essential libboost-all-dev libssl-dev \
#  libsqlite3-dev pkg-config python-minimal

#RUN git clone https://github.com/named-data/ndn-cxx.git \
#  && cd ndn-cxx

#RUN ./waf configure && ./waf && ./waf install
#RUN echo /usr/local/lib | tee /etc/ld.so.conf.d/ndn-cxx.conf
#RUN ldconfig





## iRODs 

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list && \
    apt-get update && \
    apt-get install -y irods-icommands

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY irods_environment.json /

COPY docker-entrypoint.sh /
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 1247
CMD ["ihelp"]

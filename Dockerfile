FROM debian

MAINTAINER Masaomi Hatakeyama <masaomi.hatakeyama@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich

USER root
#RUN yes | unminimize
RUN apt update
RUN apt install -y vim wget git make file screen ruby manpages-dev libz-dev libbz2-dev liblzma-dev libcurl4-openssl-dev build-essential

# conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr/local/miniconda3
#RUN . "/usr/local/miniconda3/etc/profile.d/conda.sh"
RUN /usr/local/miniconda3/bin/conda create --name eaglerc python=2.7
#RUN /usr/local/miniconda3/bin/conda init bash
#ENV PATH /usr/local/conda/envs/eaglerc/bin:$PATH
#RUN /usr/local/miniconda3/bin/conda activate eaglerc
SHELL ["/usr/local/miniconda3/bin/conda", "run", "-n", "eaglerc", "/bin/bash", "-c"]
#RUN /usr/local/miniconda3/bin/conda install -c conda-forge ruby -y
RUN /usr/local/miniconda3/bin/conda install -c bioconda gffread star last bwa -y
RUN /usr/local/miniconda3/bin/conda install -c bioconda samtools=1.9 -y

# RubyGem
RUN gem install bio

# ART
RUN wget https://www.niehs.nih.gov/research/resources/assets/docs/artbinmountrainier2016.06.05linux32.tgz
RUN tar zxf artbinmountrainier2016.06.05linux32.tgz
RUN mv art_bin_MountRainier/ /usr/local/

# EAGLE-RC
# https://github.com/tony-kuo/eagle
WORKDIR /root
RUN git clone https://github.com/tony-kuo/eagle.git
WORKDIR /root/eagle
RUN git clone https://github.com/samtools/htslib.git
WORKDIR /root/eagle/htslib
RUN git submodule update --init --recursive
WORKDIR /root/eagle
RUN make
RUN mkdir bin
RUN mv eagle bin/
RUN mv eagle-rc bin/
WORKDIR /root
RUN mv eagle/ /usr/local/

# setup sample dataset
WORKDIR /root
RUN git clone https://github.com/masaomi/EAGLERC_example_2021.git
RUN cp -r EAGLERC_example_2021/shared/scripts .
RUN cp -r EAGLERC_example_2021/shared/references .
RUN cp scripts/dot_bashrc ~/.bashrc

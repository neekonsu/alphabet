FROM nvidia/cuda:10.2-cudnn8-runtime-ubuntu18.04

COPY ./dependencies.conf ./dependencies.conf

RUN export DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y
RUN apt install -y -q $(cat dependencies.conf) --fix-missing
RUN rm ./dependencies.conf

RUN git clone https://github.com/neekonsu/ABC-Enhancer-Gene-Prediction
RUN git clone  https://github.com/neekonsu/alphabet
RUN git clone https://github.com/neekonsu/juicer

RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
RUN bash ./Anaconda3-2020.02-Linux-x86_64.sh -b -p "/usr/bin/anaconda"
ENV PATH=/usr/bin/anaconda/bin:$PATH
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda init bash
RUN conda install pyranges numpy scipy pandas pybigwig
RUN rm ./Anaconda3-2020.02-Linux-x86_64.sh

RUN echo "sh /go/src/github.com/neekonsu/alphabet/helper/start.sh" >> /root/.bashrc

RUN chmod +x ./alphabet/helper/*.sh
FROM golang:1.14

RUN mkdir -p /go/src/github.com/neekonsu
WORKDIR /go/src/github.com/neekonsu

COPY ./dependencies.conf ./dependencies.conf
COPY ./run.sh ./run.sh

RUN export DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y -q $(cat dependencies.conf) --fix-missing
RUN rm ./dependencies.conf

RUN git clone https://github.com/neekonsu/ABC-Enhancer-Gene-Prediction
RUN git clone  https://github.com/neekonsu/alphabet
RUN git clone https://github.com/neekonsu/juicer

RUN go get github.com/kr/pretty

RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
RUN bash ./Anaconda3-2020.02-Linux-x86_64.sh -b -p /root/anaconda
ENV PATH=/root/anaconda/bin:$PATH
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda env create -f ./alphabet/conda.yml
RUN conda init bash
RUN conda activate environment
RUN conda install pyranges numpy scipy pandas pybigwig
RUN rm ./Anaconda3-2020.02-Linux-x86_64.sh

RUN chmod u+x ./alphabet/*.sh

EXPOSE 5000
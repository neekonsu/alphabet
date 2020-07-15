FROM golang:1.14

RUN mkdir -p /go/src/github.com/neekonsu
WORKDIR /go/src/github.com/neekonsu

COPY ./dependencies.conf ./dependencies.conf

RUN export DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y
RUN apt install -y -q $(cat dependencies.conf) --fix-missing

RUN git clone https://github.com/neekonsu/ABC-Enhancer-Gene-Prediction
RUN git clone  https://github.com/neekonsu/ABC_scripts
RUN git clone https://github.com/neekonsu/juicer
RUN pip install --user pyranges numpy scipy pandas

RUN chmod +x ./ABC_scripts/*.sh

EXPOSE 5000
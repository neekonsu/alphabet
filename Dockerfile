FROM debian

RUN export DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y

WORKDIR /usr/src/app/

RUN rm Dockerfile
RUN apt install -y -q $(cat dependencies.conf) --fix-missing

RUN git clone https://github.com/neekonsu/ABC-Enhancer-Gene-Prediction
RUN git clone  https://github.com/neekonsu/ABC_scripts
RUN git clone https://github.com/neekonsu/juicer
RUN chmod +x /usr/src/app/ABC_scripts/*.sh

RUN pip install --user pyranges numpy scipy pandas

EXPOSE 5000
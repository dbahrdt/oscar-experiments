FROM ubuntu:latest

RUN apt-get update
RUN apt-get -y install git cmake build-essential ragel libprotobuf-lite10 libz-dev libcgal-qt5-dev libmarble-dev libcppunit-dev libicu-dev libcairo-dev libprotobuf-dev protobuf-compiler libcrypto++-dev
RUN apt-get -y install default-jdk ant
RUN cd /usr/src/ && git clone https://github.com/dbahrdt/oscar-experiments && cd oscar-experiments && git submodule update --init && git submodule update --init --recursive progs/*
RUN cd /usr/src/oscar-experiments/progs && ./setup.sh --update-repos

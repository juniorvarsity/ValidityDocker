FROM ubuntu:bionic AS BaseOS 

# install runtime libraries (Boost, QT5, event, ssl)
RUN apt-get update && apt-get install -y \
  libboost-chrono-dev \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-system-dev \ 
  libboost-test-dev \
  libboost-thread-dev \
  libprotobuf-dev \ 
  libqt5core5a \ 
  libqt5dbus5 \ 
  libqt5gui5 \
  protobuf-compiler \
  qttools5-dev \
  qttools5-dev-tools \
  libevent-dev \
  libssl-dev


# Stage to build Validity from source
FROM BaseOS AS ValidityBuild

RUN mkdir /validity
WORKDIR /validity/validitylatest

RUN apt-get update && apt-get install -y \
  curl \
  wget
  
RUN curl -L https://api.github.com/repos/RadiumCore/Validity/tarball | tar xzf - --strip 1

ENV BITCOIN_ROOT /validity/validitylatest

# install build required libraries
RUN apt-get update && apt-get install -y \
  automake \
  autotools-dev \
  build-essential \ 
  bsdmainutils \
  libtool \
  pkg-config 

# Pick some path to install BDB to, here we create a directory within the radium13 directory
ENV BDB_PREFIX="$BITCOIN_ROOT/build"
RUN mkdir -p "$BDB_PREFIX"

RUN wget 'http://download.oracle.com/berkeley-db/db-6.2.32.tar.gz'
RUN echo 'a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb  db-6.2.32.tar.gz' | sha256sum -c
RUN tar -xzvf db-6.2.32.tar.gz
RUN rm -rf db-6.2.32.tar.gz

WORKDIR db-6.2.32/build_unix/
RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX
RUN make install

WORKDIR ${BITCOIN_ROOT}

RUN ./autogen.sh
RUN ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"

RUN make
RUN make install

# final stage, copy Validity runtime files and set to launch when running the image
FROM BaseOS AS ValidityRuntime

COPY --from=ValidityBuild /usr/local/bin/validity-* /usr/local/bin/
CMD ["/usr/local/bin/validity-qt"]




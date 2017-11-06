FROM jetbrains/teamcity-agent

# From https://github.com/nodejs/docker-node/blob/master/6.10/Dockerfile
# https://github.com/nodejs/docker-node/blob/master/6.11/Dockerfile
# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.11.3

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

## TODO: Upgrade to 1.x version of yarn

ENV YARN_VERSION 0.27.5

RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" || \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" ; \
  done \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt/yarn \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

ENV ACCEPT_EULA Y

RUN \
    apt-get update && \
    apt-get install -y software-properties-common \
                       apt-transport-https \
                       build-essential \
                       ca-certificates \
                       checkinstall \
                       curl \
                       emacs-nox \
                       git \
                       libssl-dev \
                       net-tools \
                       nginx \
                       openssh-client \
                       python \
                       python-dev \
                       python-pip \
                       libffi-dev \
                       rsync \
#                       lftp \
                       locales \
                       unzip \
                       openssl \
                       libreadline-dev \
                       ncurses-dev \
                       libgnutls28-dev \
                       pkg-config \
                       wget && \
    sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
    
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list
    
#RUN    apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 && \
#    apt-get update && \
#    apt-get install -y dotnet-dev-1.0.4 \
#                       mssql-tools \
#                       unixodbc-dev

RUN    apt-key adv --keyserver apt-mo.trafficmanager.net --recv-keys 417A0893 && \
    apt-get update && \
    apt-get install -y dotnet-sdk-2.0.0 \    
                       mssql-tools \
                       unixodbc-dev

ENV PATH="${PATH}:/opt/mssql-tools/bin"

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
    && apt-get update && apt-get install azure-cli
     
RUN locale-gen en_US.utf8 && update-locale

##
# https://nwgat.ninja/compiling-lftp-on-linux/
# Build LFTP

RUN mkdir -p /usr/local/src/lftp && cd /usr/local/src/lftp && \
wget http://lftp.yar.ru/ftp/$(wget -O- http://lftp.yar.ru/ftp/ | egrep -o 'lftp-[0-9\.]+.tar.gz' | sort -V  | tail -1) && \
tar zxvf lftp-*.tar.gz && cd lftp-* && \
./configure && \
make -j8 && \
make install

# END LFTP

RUN mkdir -p /opt/lftp
RUN mkdir -p /opt/azure
COPY lftp-api.sync /opt/lftp
COPY lftp-front.sync /opt/lftp
COPY swap.sh /opt/azure
COPY timestamp.sh /opt/azure
COPY hooks /root/hooks
COPY README_LFTP.txt /opt/lftp
RUN git config --global user.email 'teamcity@example.org' \
    && git config --global user.name 'Team City'




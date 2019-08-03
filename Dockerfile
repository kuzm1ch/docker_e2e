FROM ubuntu:18.04


# BASE PACKAGES
RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
    bzip2 \
    ca-certificates \
    apt-transport-https \
    unzip \
    wget \
    curl \
    git \
    jq \
    zip \
    build-essential

RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
    xvfb \
    pulseaudio \
    ffmpeg \
    g++ \
    build-essential \
    dbus \
    dbus-x11

# NODEJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update -qqy && apt-get -qqy install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# CHROME
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qqy && apt-get -qqy install ${CHROME_VERSION:-google-chrome-stable} && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    ln -s /usr/bin/google-chrome /usr/bin/chromium-browser


# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant maven && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

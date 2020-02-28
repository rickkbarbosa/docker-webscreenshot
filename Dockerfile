FROM ubuntu:bionic

WORKDIR /tmp

RUN apt-get update && apt-get install -y gnupg software-properties-common

#Initial Packages
RUN apt-get install -y apt-utils \
    apt-transport-https \
    curl \
    wget \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxss1 \
    xdg-utils    
    locales \
    openssl \
    python-boto \
    python-dev \
    python-pip \
    unzip

#Install ChromeDriver
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN export CHROMEDRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE;) && \
     wget https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip
RUN APT_DEPENDENCIES=$(dpkg -I google-chrome-stable_current_amd64.deb | grep Depends | cut -d ':' -f 2 | sed 's/,/\n/g' | awk '{print $1}';) && \
      apt install -fy ${APT_DEPENDENCIES}
RUN unzip chromedriver_linux64.zip -d /usr/local/bin
RUN dpkg -i google-chrome-stable_current_amd64.deb && \
      apt install -f 


#Generate locales
RUN locale-gen en_US.UTF-8 pt_BR.UTF-8 es_AR.UTF-8
RUN update-locale

RUN pip install webscreenshot

#Garbage collector
RUN apt-get clean
#RUN rm -r /tmp/*
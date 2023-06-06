FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

ARG DEBIAN_FRONTEND="noninteractive"

# prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap

RUN \
  echo "**** install packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    dolphin \
    firefox \
    gwenview \
    kde-config-gtk-style \
    kdialog \
    kfind \
    khotkeys \
    kio-extras \
    knewstuff-dialog \
    konsole \
    ksystemstats \
    kwin-addons \
    kwin-x11 \
    kwrite \
    plasma-desktop \
    plasma-workspace \
    qml-module-qt-labs-platform \
    systemsettings && \
  echo "**** kde tweaks ****" && \
  sed -i \
    's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install zsh git wget curl vim neovim dialog neofetch gcc make ruby-dev iputils-ping

RUN gem install colorls

# Install Tailscale

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg |  apt-key add -
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list |  tee -a /etc/apt/sources.list.d/tailscale.list
RUN apt-get update && \
apt-get install -y tailscale

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config

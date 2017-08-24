FROM raspbian/jessie

COPY conf .

RUN useradd --user-group --create-home --shell /bin/bash core

RUN \
  apt-get update && apt-get install git mpd mpc wget sudo xz-utils -y && \
  wget https://nodejs.org/dist/v6.10.2/node-v6.10.2-linux-armv7l.tar.xz && \
  tar -xvf node-v6.10.2-linux-armv7l.tar.xz   && \
  cp -R node-v6.10.2-linux-armv7l/* /usr/local/ && \
  git clone https://github.com/shintech/mpd-conf.git && \
  npm --prefix ./mpd-conf/ install mpd-conf/

RUN \
  usermod -aG sudo core && \
  printf "core ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

USER core

CMD SERVER_IP=${SERVER_IP} MPD_USER=${MPD_USER} MUSIC_DIR=${MUSIC_DIR} node mpd-conf/index.js && mpc update



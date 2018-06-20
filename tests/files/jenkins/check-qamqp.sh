#
# Copyright (c) 2013-2018 BalaBit
# All Rights Reserved.
#

set -e

cat >docker-compose.yml <<EOF
version: "2"

services:
  indexer-devel:
    image: docker.balabit/scb/indexer-devel-xenial
    privileged: true
    volumes:
      - "${HOME}:/mnt/${HOME}"
      - "${HOME}/ccachedir:${HOME}/ccache"
      - "${HOME}/.Xauthority:${HOME}/.Xauthority"
      - "${HOME}/.ssh:${HOME}/.ssh"
      - "${HOME}/.bash_history:${HOME}/.bash_history"
      - "/tmp:/tmp"
      - "/var/run/docker.sock:/var/run/docker.sock"
      - /etc/group:/etc/group.original:ro
    environment:
      - DISPLAY=$DISPLAY
      - USER=$USER
      - ADDITIONAL_PATH=/mnt/${PWD}/install/bin
      - ADDITIONAL_LD_LIBRARY_PATH=/mnt/${PWD}/install/lib
      - SOURCEDIR=/mnt/${PWD}
      - HOME=$HOME
    working_dir: /mnt/${PWD}
    network_mode: "host"
EOF

docker-compose pull indexer-devel

RUN="docker-compose run --rm indexer-devel bash -ci"

$RUN "sudo rm -rf /etc/rabbitmq && git clean -xdf && tests/files/travis/rabbitmq-setup.sh && qmake && make && make check"

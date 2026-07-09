#!/bin/bash
# run agent in docker

image="pi-agent"
mount="."
folder=$(basename `pwd`)

set -e

docker network create agents >/dev/null 2>&1 || :

NO_SESSION=""
docker run --rm -it \
  --network agents \
  --shm-size=2g \
  -v //var/run/docker.sock:/var/run/docker.sock \
  -v $image-sessions:/root/.pi/agent/sessions \
  -v $image-bin:/root/.pi/agent/bin \
  -v $image-ssh:/root/.ssh \
  -v $mount:/root/brain \
  $image --session "$folder" "$@" || NO_SESSION=true

if [[ ! -z $NO_SESSION ]]; then
docker run --rm -it \
  --network agents \
  --shm-size=2g \
  -v //var/run/docker.sock:/var/run/docker.sock \
  -v $image-sessions:/root/.pi/agent/sessions \
  -v $image-bin:/root/.pi/agent/bin \
  -v $image-ssh:/root/.ssh \
  -v $mount:/root/brain \
  $image --name "$folder" "$@"
fi


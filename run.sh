#!/bin/bash

. config.rc

if [ $(docker ps -a | grep ${CONTAINER_NAME} | awk '{print $NF}' | wc -l) -gt 0 ]
then
  docker kill ${CONTAINER_NAME} 2> /dev/null
  docker rm   ${CONTAINER_NAME} 2> /dev/null
fi

# ---------------------------------------------------------------------------------------

docker run \
  --interactive \
  --tty \
  --detach \
  --publish=3000:3000 \
  --link=${USER}-graphite:graphite \
  --env GRAPHITE_HOST=${USER}-graphite.docker \
  --env GRAPHITE_PORT=8088 \
  --dns=172.17.0.1 \
  --hostname=${USER}-${TYPE} \
  --name ${CONTAINER_NAME} \
  ${TAG_NAME}

[ -x /usr/local/bin/update-docker-dns.sh ] && sudo /usr/local/bin/update-docker-dns.sh

# ---------------------------------------------------------------------------------------
# EOF
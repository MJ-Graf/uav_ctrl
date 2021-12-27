#!/bin/bash
TARGET='uav_ctrl'
TARGET_VERSION='1.0'
TARGET_IMAGE="${TARGET}:${TARGET_VERSION}"

IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}")
HAVE_IMAGE=$(echo $IMAGES|grep ${TARGET_IMAGE})

if [ -z "$HAVE_IMAGE" ]
then
	docker build  - < $(dirname $0)/Docker/Dockerfile
fi

ARGS=("-v /etc:/etc
       -v /dev:/dev
       -u "${UID}:${GID}"
       --hostname ${TARGET}
       -ti
       --rm")
docker run ${ARGS} ${TARGET_IMAGE} /bin/bash

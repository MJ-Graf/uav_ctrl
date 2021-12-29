#!/bin/bash
TARGET='uav_ctrl'
TARGET_VERSION='1.0'
TARGET_IMAGE="${TARGET}:${TARGET_VERSION}"

IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}")
HAVE_IMAGE=$(echo $IMAGES|grep ${TARGET_IMAGE})

if [ -z "$HAVE_IMAGE" ]
then
	docker build -t ${TARGET_IMAGE}   $(dirname $0)/Docker
fi

# ARGS=("-v /dev:/dev
#        -v /etc/shadow:/etc/shadow
#        -v /etc/passwd:/etc/passwd
#        -v /etc/groups:/etc/groups
#        -v /etc/sudoers:/etc/sudoers
#        -u "${UID}:${GID}"
#        --hostname ${TARGET}
# 	-ti
#        --rm")
ARGS=("-v /dev:/dev
       --hostname ${TARGET}
	-ti
	--privileged
       --rm")
docker run ${ARGS}  ${TARGET_IMAGE} /bin/bash
#docker run ${ARGS} ${TARGET_IMAGE} /bin/bash

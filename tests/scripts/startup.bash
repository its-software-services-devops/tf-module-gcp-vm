#!/bin/bash

#Execute after first instance restarted
#cloud-init run first

MOUNT_DIR=/apps
DEVICE=/dev/sdb
LOG_FILE=/tmp/startup.log

sudo mkdir -p ${MOUNT_DIR}
sudo chown devops:devops ${MOUNT_DIR}

sudo blkid ${DEVICE}
CODE=$?
DTM=$(date)

if [[ ${CODE} = "0" ]]
then
    echo "[${DTM}] Do nothing - volume is already formatted" >> ${LOG_FILE}
else
    echo "[${DTM}] Formatting disk ${DEVICE}" >> ${LOG_FILE}
    sudo mkfs --type ext4 ${DEVICE} >> ${LOG_FILE}
fi

sudo mount -t ext4 ${DEVICE} ${MOUNT_DIR} >> ${LOG_FILE}

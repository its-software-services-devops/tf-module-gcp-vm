#!/bin/bash

ADDON_SCRIPT=/tmp/addon_script.bash

pwd
ls -lrt
echo "This is from dummy.bash"

chmod 755 ${ADDON_SCRIPT}
${ADDON_SCRIPT}
#!/bin/bash

if [ -z "${APP_KEY}" ]; then
  echo "Please set an APP_KEY environment variable first!"
  exit -1
fi

/root/become.sh /init.sh

cd / && /root/become.sh forego start -r


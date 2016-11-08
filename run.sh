#!/bin/bash -e

if [ "$1" == "" ]; then
  docker-compose run laravel /root/become.sh
else
  docker-compose run laravel $@
fi


#!/bin/bash -xe


if [ "$1" == "" ]; then
  docker-compose run laravel bash
else
  docker-compose run laravel $@
fi


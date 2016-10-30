#!/bin/bash -xe

docker-compose -f docker-compose.test.yml up --build \
&& docker-compose -f docker-compose.test.yml down


#!/bin/bash

/root/become.sh /init.sh

cd / && /root/become.sh forego start -r


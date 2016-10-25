#!/bin/bash

cd /app

if [ ! -d "/app/vendor" ]; then
  composer install --ansi
else
  echo "Directory '/app/vendor' already exists - skipping 'composer install'"
fi

if [ ! -d "/app/node_modules" ]; then
  npm install || npm install --no-optional
else
  echo "Directory '/app/node_modules' already exists - skipping 'npm install'"
fi


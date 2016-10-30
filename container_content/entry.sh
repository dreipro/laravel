#!/bin/bash

/init.sh

cd /app
php artisan serve --host=0.0.0.0


#!/usr/bin/env bash

if [ ! -d "./src" ]; then
  . /home/install.sh
fi

npm install
DEBUG=www:* npm start

tail -f /dev/null

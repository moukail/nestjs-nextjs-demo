#!/usr/bin/env bash

if [ ! -d "./src" ]; then
  . /home/install.sh
fi

npm install
npm run dev

tail -f /dev/null

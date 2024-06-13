#!/usr/bin/env bash

#npx express-generator <<< 'y'

npm i -g @nestjs/cli
nest new --strict --package-manager npm --skip-git backend

chmod -R a+rw backend

rsync -a backend/ ./
rm -rf backend

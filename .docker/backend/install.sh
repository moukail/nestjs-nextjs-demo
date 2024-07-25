#!/usr/bin/env bash

#npx express-generator <<< 'y'

npm i -g @nestjs/cli
nest new --strict --package-manager npm --skip-git backend
#nest generate application backend

npm install @nestjs/typeorm typeorm pg
npm install @nestjs/jwt @nestjs/passport passport passport-jwt bcryptjs

nest generate resource user

nest generate module auth
nest generate controller auth
nest generate service auth
nest generate guard auth

chmod -R a+rw backend

rsync -a backend/ ./
rm -rf backend

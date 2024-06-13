#!/usr/bin/env bash

if [ -d ".docker" ]; then
  echo "docker exists"
  exit
fi

mkdir -p .docker/backend
cat << EOF > ./.docker/backend/Dockerfile
FROM node:22.3-alpine3.20
RUN apk --update --no-cache add bash rsync

WORKDIR /var/www

ADD install.sh /home/
RUN chmod +x /home/install.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh
EOF

cat << EOF > ./.docker/backend/install.sh
#!/usr/bin/env bash

#npx express-generator <<< 'y'

npm i -g @nestjs/cli
nest new --strict --package-manager npm --skip-git backend

chmod -R a+rw backend

rsync -a backend/ ./
rm -rf backend
EOF

cat << EOF > ./.docker/backend/docker-init.sh
#!/usr/bin/env bash

if [ ! -d "./src" ]; then
  . /home/install.sh
fi

npm install
DEBUG=www:* npm start

tail -f /dev/null
EOF

mkdir -p .docker/frontend
cat << EOF > ./.docker/frontend/Dockerfile
FROM node:22.3-alpine3.20
RUN apk --update --no-cache add bash

WORKDIR /var/www

ADD install.sh /home/
RUN chmod +x /home/install.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh
EOF

cat << EOF > ./.docker/frontend/install.sh
#!/usr/bin/env bash

npx create-next-app --typescript --eslint --tailwind --use-npm --src-dir /var/www --import-alias "@/*" --app frontend <<< 'y'

EOF

cat << EOF > ./.docker/frontend/docker-init.sh
#!/usr/bin/env bash

if [ ! -d "./src" ]; then
  . /home/install.sh
fi

npm install
npm run dev

tail -f /dev/null
EOF

cat << EOF > docker-compose.yml
services:
  backend:
    user: root
    build:
      context: .docker/backend
      dockerfile: Dockerfile
    ports:
      - '3000'
    volumes:
      - ./backend:/var/www
    tty: true

  frontend:
    user: root
    build:
      context: .docker/frontend
      dockerfile: Dockerfile
    ports:
      - '3000'
    volumes:
      - ./frontend:/var/www
    tty: true

  database:
    image: postgres:16.3-alpine3.20
    environment:
      - 'POSTGRES_DB=mydatabase'
      - 'POSTGRES_PASSWORD=secret'
      - 'POSTGRES_USER=myuser'
    ports:
      - '5432'
EOF

### Docker
docker compose up -d --build
docker logs demo-app-1

### Git
if [ -d ".git" ]; then
  echo "git exists"
  exit
fi

git init

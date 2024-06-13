FROM node:22.3-alpine3.20
RUN apk --update --no-cache add bash

WORKDIR /var/www

ADD install.sh /home/
RUN chmod +x /home/install.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh

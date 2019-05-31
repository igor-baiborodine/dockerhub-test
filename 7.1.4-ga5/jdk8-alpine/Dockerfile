FROM openjdk:8-jdk-alpine

ENV APP_VERSION 7.1.4-ga5

RUN apk add --no-cache \
    bash

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

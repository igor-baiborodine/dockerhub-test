FROM openjdk:8-jdk-alpine

ARG GIT_COMMIT

ENV APP_VERSION 7.1.2-ga3

RUN apk add --no-cache \
    bash

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

LABEL git_commit=$GIT_COMMIT

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

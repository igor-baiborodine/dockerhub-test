FROM openjdk:8-jdk-slim

ARG GIT_COMMIT

ENV APP_VERSION 7.0.6-ga7

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

LABEL git_commit=$GIT_COMMIT

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

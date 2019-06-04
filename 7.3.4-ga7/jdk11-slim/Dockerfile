FROM openjdk:11-jdk-slim

ENV APP_VERSION 7.3.4-ga7

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

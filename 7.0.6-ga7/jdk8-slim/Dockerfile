FROM openjdk:8-jdk-slim

ENV APP_VERSION 7.0.6-ga7

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

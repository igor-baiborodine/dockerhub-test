FROM openjdk:11-jdk-slim

ENV APP_VERSION 7.4.8-ga8

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

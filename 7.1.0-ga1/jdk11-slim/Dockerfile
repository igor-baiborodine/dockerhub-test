FROM openjdk:11-jdk-slim

ENV APP_VERSION 7.1.0-ga1

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

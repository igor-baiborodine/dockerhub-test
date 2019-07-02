FROM openjdk:8-jdk-slim

ENV APP_VERSION 7.7.11-ga11

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

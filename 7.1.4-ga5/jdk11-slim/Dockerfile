FROM openjdk:11-jdk-slim

ENV APP_VERSION 7.1.4-ga5

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

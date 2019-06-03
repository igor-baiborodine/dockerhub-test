FROM openjdk:11-jdk-slim

ENV APP_VERSION 7.2.7-ga6

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash", "-c", "echo APP_VERSION:$APP_VERSION"]

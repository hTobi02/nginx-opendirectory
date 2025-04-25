FROM nginx:stable

LABEL MAINTAINER github.com/htobi02

ENV PORT 12000
ENV LIMIT_RATE 2097152
ENV LIMIT_RATE_AFTER 52428800
ENV EXPIRES 7d
ENV MAX_AGE 604800

RUN apt update && apt install mergerfs curl -y && apt autoremove -y

COPY default.conf.template /etc/nginx/conf.d/
COPY *.sh /s/
RUN chmod +x /s/*.sh

WORKDIR /data

EXPOSE 12000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:$PORT/health || exit 1
ENTRYPOINT /bin/bash /s/startup.sh
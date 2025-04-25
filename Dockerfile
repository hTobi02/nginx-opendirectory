FROM alpine:3.19 AS builder

# MergerFS braucht fuse3-dev + build-tools
RUN apk add --no-cache \
    build-base \
    fuse3-dev \
    git \
    linux-headers \
    python3

WORKDIR /src

# Neueste stable Release (z. B. 2.40.2), hier per Tag einstellbar
ARG VERSION=2.40.2
RUN git clone --branch ${VERSION} https://github.com/trapexit/mergerfs.git .

# Statisch bauen!
RUN make STATIC=1 

# === Finales Alpine-Image ===
FROM nginx:stable-alpine

LABEL maintainer="github.com/htobi02"

ENV PORT=12000
ENV LIMIT_RATE=2097152
ENV LIMIT_RATE_AFTER=52428800
ENV EXPIRES=7d
ENV MAX_AGE=604800

RUN apk add --no-cache bash curl fuse3

# mergerfs Binary ins finale Image
COPY --from=builder /src/build/mergerfs /usr/bin/mergerfs

COPY default.conf.template /etc/nginx/conf.d/
COPY *.sh /s/
RUN chmod +x /s/*.sh

WORKDIR /data

EXPOSE 12000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:$PORT/health || exit 1

ENTRYPOINT ["/bin/bash", "/s/startup.sh"]

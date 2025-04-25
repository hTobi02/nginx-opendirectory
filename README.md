# nginx-opendirectory

**Dockerized NGINX Open Directory with MergerFS**  
Serves merged media directories (e.g., Movies, Series, Music) with an auto-indexed listing via NGINX.

---
![Docker Build](https://github.com/htobi02/nginx-opendirectory/actions/workflows/docker-image.yml/badge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/htobi02/nginx-opendirectory.svg)](https://hub.docker.com/r/htobi02/nginx-opendirectory)
[![Docker Image Size](https://img.shields.io/docker/image-size/htobi02/nginx-opendirectory/latest)](https://hub.docker.com/r/htobi02/nginx-opendirectory)

## Features

- Merges multiple folders into unified views using [mergerfs](https://github.com/trapexit/mergerfs)
- Serves directory listings via NGINX with media-friendly MIME types
- Download rate limiting with smart threshold
- Auto-indexed, UTF-8 directory listings
- Cache headers and range requests for streaming
- Lightweight and container-friendly
- Built-in healthcheck at `/health`

---

## Getting Started

### Run with Docker

```bash
docker run -d \
  -p 12000:12000 \
  -v /path/to/moviesA:/movies \
  -v /path/to/moviesB:/movies \
  -v /path/to/series1:/series \
  -v /path/to/series2:/series \
  -v /path/to/music1:/music \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  --name nginx-opendirectory \
  htobi02/nginx-opendirectory
```
⚠️ Requires FUSE support and --cap-add SYS_ADMIN in Docker

## Example Directory Structure
```
/path/to/movies/drive1
/path/to/movies/drive2
/path/to/series/driveA
/path/to/series/driveB
...
```
Each drive/folder gets merged into a single view using mergerfs:

```
/data/Movies → /movies/*
/data/Series → /series/*
/data/Music  → /music/*
```

## Healthcheck
URL: `http://localhost:12000/health`

Response: `200 OK` with body `OK`

## Environment Variables

|Variable|Default|Description|
|-----|-----|-----|
|PORT|12000|HTTP port to expose|
|LIMIT_RATE|2097152|Throttle speed per client (bytes/sec)|
|LIMIT_RATE_AFTER|52428800|Unlimited after X bytes (e.g. 50MB)|
|EXPIRES|7d|Cache expiration for static content|
|MAX_AGE|604800|Cache-Control max-age in seconds|

## Security & Access Control
CORS is enabled for media use in players (`Access-Control-Allow-Origin: *`)

Rate-limiting per client included via NGINX's `limit_rate`

TODO: Add basic auth via reverse proxy or extend with `auth_basic`

## License
MIT — feel free to fork, improve, and share!

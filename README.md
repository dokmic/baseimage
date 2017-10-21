# Latest Debian Base Image for Docker

*This image is based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) and [timclassic/docker-baseimage](https://github.com/timclassic/docker-baseimage). I have made all the changes working on the latest Debian version and tested it.*

The image is extending the official [debian:stable](https://hub.docker.com/_/debian/) image and allows you to use cron, ssh, and syslog out of the box.

## When it makes sense to use this image?

- To provide an isolated SSH access.
- To run isolated sandbox with Debian.
- All-in-one container (this is a very bad practice, please google why).

## Usage

To execute some process within the environment:

```bash
docker run --rm -it dokmic/baseimage my_init -- bash
```

To create your own image:

```dockerfile
FROM dokmic/baseimage:latest

COPY dist /app

RUN aptitude update \
 && aptitude install -y --without-recommends --add-user-tag build \
  build-essential \
 && make \
 && aptitude purge -y '?user-tag(build)' \
 && aptitude clean
```

## Links

To get more information and examples please follow these links:

- [timclassic/docker-baseimage](https://github.com/timclassic/docker-baseimage)
- [phusion/baseimage-docker official website](http://phusion.github.io/baseimage-docker/)

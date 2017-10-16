FROM debian:stable

MAINTAINER Michael Dokolin <m@dokol.in>

ENV LC_ALL C.UTF-8
ENV HOME /root

COPY my_init /sbin/

RUN export DEBIAN_FRONTEND=noninteractive \
 && export INITRD=no \
 && export LC_ALL=C \
 && export RUNLEVEL=1 \
 # docker
 && mkdir -p /etc/container_environment \
 && echo -n no > /etc/container_environment/INITRD \
 && touch /etc/container_environment.sh /etc/container_environment.json \
 && chmod 700 /etc/container_environment \
 && groupadd docker_env \
 && chown :docker_env /etc/container_environment.sh /etc/container_environment.json \
 && chmod 640 /etc/container_environment.sh /etc/container_environment.json \
 && ln -s /etc/container_environment.sh /etc/profile.d \
 # debian
 && echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
 && dpkg-divert --local --rename --add /usr/bin/ischroot \
 && ln -sf /bin/true /usr/bin/ischroot \
 && sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d \
 && mkdir -p /etc/my_init.d \
 # required packages
 && apt-get update \
 && apt-get install -y --no-install-recommends \
  apt-utils \
  apt-transport-https \
  ca-certificates \
  software-properties-common \
  locales systemd-sysv \
  python3 \
  runit \
  syslog-ng-core \
  syslog-ng-mod-sql \
  logrotate \
  openssh-server \
  cron \
  anacron \
 && dpkg-reconfigure locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 # clean up
 && rm -rf /tmp/* /var/tmp/*

RUN apt-get install -y \
 aptitude \
 curl \
 less \
 psmisc

RUN apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup

EXPOSE 22

CMD ["/sbin/my_init"]

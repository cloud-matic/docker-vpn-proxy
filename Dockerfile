FROM       ubuntu:16.04
MAINTAINER Mauricio Araya

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid

ENV JUMP_USER='<your_username>' \
    JUMP_USER_COMMENT='<YOUR_NAME>' \
    JUMP_USER_PKEY='<YOUR_SSH_PUBLIC_KEY>'

RUN apt-get update -y

RUN apt-get install -y net-tools coreutils squid vpnc openssh-server curl wget perl netcat-openbsd  \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd
RUN perl -pi -e 's/Port\ 22/Port 20022/g' /etc/ssh/sshd_config
RUN useradd -c "${JUMP_COMMENT}" -s /bin/bash -m -d "/home/${JUMP_USER}" "${JUMP_USER}" \
   && mkdir -p "/home/${JUMP_USER}/.ssh" \
   && echo "${JUMP_USER_PKEY}" > "/home/${JUMP_USER}/.ssh/authorized_keys" \
   && chown -R "${JUMP_USER}:${JUMP_USER}" "/home/${JUMP_USER}"\
   && chmod -R og-rwx "/home/${JUMP_USER}"

RUN mkdir -p /etc/vpnc
COPY vpnc-default.conf /etc/vpnc/default.conf

COPY squid.conf /etc/squid/squid.conf

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 20022/tcp
EXPOSE 23128/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

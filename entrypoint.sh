#!/bin/bash
set -e

restart_ssh() {
  /usr/sbin/service ssh restart
}

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  #chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  squid -N -z
  #chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

restart_ssh
create_log_dir
create_cache_dir

# connect to the VPN and launch squid
if [[ -z ${1} ]]; then
  echo "Starting vpnc..."
  vpnc-connect && sleep 5
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi

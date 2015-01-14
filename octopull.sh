#!/bin/bash
# Bash script for daemonizing an application powered by Unicorn

usage() {
  echo "Usage: `basename $0` {start|stop|restart|force-stop|force-restart|status}" >&2
}

PROGRAM_NAME="Octopull"
PIDFILE="tmp/octopull.pid"
UNICORN_CONFIG="config/unicorn.rb"
APP_ENV="development"

#Get the PID from PIDFILE if we don't have one yet.
if [[ -e "$(pwd)/${PIDFILE}" ]]; then
  PID=$(cat ${PIDFILE})
fi
 
start() {
  if [[ -n $1 ]]; then
    APP_ENV=$1
  fi

  if [[ -n "${PID}" && -n $(ps -p ${PID} | tail -n +2) ]]; then
    echo "$PROGRAM_NAME is already running (PID:${PID})"
  else
    echo "Starting $PROGRAM_NAME with Unicorn config at $(pwd)/${UNICORN_CONFIG} in ${APP_ENV} environment"
    RAILS_ENV=$APP_ENV bundle exec rake db:migrate
    RAILS_ENV=$APP_ENV bundle exec rake assets:precompile
    bundle exec unicorn -D -c "$(pwd)/${UNICORN_CONFIG}" -E $APP_ENV
  fi
}
 
status() {
  if [[ -z "${PID}" ]]; then
    echo "${PROGRAM_NAME} is not running (missing PID)."
  elif [[ -n $(ps -p ${PID} | tail -n +2) ]]; then 
    echo "${PROGRAM_NAME} is running (PID: ${PID})."
  else
    echo "${PROGRAM_NAME} is not running (tested PID: ${PID})."
  fi
}
 
stop() {
  if [[ -z "${PID}" ]]; then
    echo "${PROGRAM_NAME} is not running (missing PID)."
  elif [[ -z $(ps -p ${PID} | tail -n +2) ]]; then 
    echo "${PROGRAM_NAME} is not running (tested PID: ${PID})."
  else
    echo "Stopping ${PROGRAM_NAME} in PID: ${PID}"
    kill $1 ${PID}
  fi
}
 
case "$1" in
  start)
        start $2;
        ;;
  restart)
        stop; sleep 1; start $2;
        ;;
  stop)
        stop
        ;;
  force-stop)
        stop -9
        ;;
  force-restart)
        stop -9; sleep 1; start $2;
        ;;
  status)
        status
        ;;
  *)
        usage
        exit 4
        ;;
esac
 
exit 0

######################################################################
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. 
#
# If your jurisdiction supports the concept of Public Domain works,
# this program is released into the Public Domain. 
#
# Otherwise this program is available under the following terms:
#---------------------------------------------------------------------
# Copyright (c) 2012, Rodney Waldhoff
#
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this program with or without this notice.
######################################################################

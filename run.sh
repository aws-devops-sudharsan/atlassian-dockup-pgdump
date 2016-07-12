#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh
fi
if [ -n "$CRON_TIME" ]; then
echo "${CRON_TIME} PGDUMP_OPTIONS='$PGDUMP_OPTIONS' \
PGDUMP_DATABASE='$PGDUMP_DATABASE' \
POSTGRES_ENV_POSTGRES_USER='$POSTGRES_ENV_POSTGRES_USER' \
POSTGRES_ENV_POSTGRES_PASSWORD='$POSTGRES_ENV_POSTGRES_PASSWORD' \
POSTGRES_PORT_5432_TCP_ADDR='$POSTGRES_PORT_5432_TCP_ADDR' \
POSTGRES_PORT_5432_TCP_PORT='$POSTGRES_PORT_5432_TCP_PORT' \
AWS_BUCKET='$AWS_BUCKET' \
PREFIX='$PREFIX' \
/bin/bash /backup.sh >> /dockup.log 2>&1" > /crontab.conf

crontab  /crontab.conf

echo "=> Running dockup backups as a cronjob for ${CRON_TIME}"

exec cron -f
fi
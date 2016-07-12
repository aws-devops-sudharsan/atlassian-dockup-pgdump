#!/bin/bash

export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

: ${LAST_BACKUP:=$(aws s3 ls s3://$AWS_BUCKET/$PREFIX/ | awk -F " " '{print $4}' | grep ^$PGDUMP_DATABASE | sort -r | head -n1)}

aws s3 cp s3://$AWS_BUCKET/$PREFIX/$ECS_SERVICE_NAME/$LAST_BACKUP $LAST_BACKUP

POSTGRES_HOST_OPTS="-h $POSTGRES_PORT_5432_TCP_ADDR -p $POSTGRES_PORT_5432_TCP_PORT -U $POSTGRES_ENV_POSTGRES_USER"

echo "Starting restore of ${PGDUMP_DATABASE} database(s) from ${POSTGRES_PORT_5432_TCP_ADDR}..."

export PGPASSWORD=${POSTGRES_ENV_POSTGRES_PASSWORD}

pg_restore $PGDUMP_OPTIONS $POSTGRES_HOST_OPTS -d $PGDUMP_DATABASE $LAST_BACKUP

echo "Done!"

exit 0
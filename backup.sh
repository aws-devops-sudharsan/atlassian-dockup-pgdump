#!/bin/bash

export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

export EXPORT_DATETIME=$(date -u +"%Y-%m-%d-%H-%M-%S-%Z")

POSTGRES_HOST_OPTS="-h $POSTGRES_PORT_5432_TCP_ADDR -p $POSTGRES_PORT_5432_TCP_PORT -U $POSTGRES_ENV_POSTGRES_USER"

echo "Starting dump of ${PGDUMP_DATABASE} database(s) from ${POSTGRES_PORT_5432_TCP_ADDR}..."

export PGPASSWORD=${POSTGRES_ENV_POSTGRES_PASSWORD}

pg_dump $PGDUMP_OPTIONS $POSTGRES_HOST_OPTS $PGDUMP_DATABASE | aws s3 cp - s3://$AWS_BUCKET/$PREFIX/$PGDUMP_DATABASE-$EXPORT_DATETIME.dump --sse || exit 2

echo "Done!"

exit 0
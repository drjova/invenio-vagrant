#!/bin/bash
warn () {
    echo "$0:" "$@" >&2
}
die () {
    rc=$1
    shift
    warn "$@"
    exit $rc
}

source /usr/local/bin/virtualenvwrapper.sh

workon pu
cdvirtualenv

cd src/invenio

pybabel compile -fd invenio/base/translations || die 1 "pybabel compile failed"

inveniomanage config create secret-key
inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backend.console.Mail
inveniomanage config set CFG_BIBSCHED_PROCESS_USER `whoami`
inveniomanage config set CFG_DATABASE_NAME invenio
inveniomanage config set CFG_DATABASE_USER invenio
inveniomanage config set CFG_SITE_URL http://0.0.0.0:4000
inveniomanage config set PACKAGES "['invenio_demosite', 'invenio.modules.*']"

# dirname pwd because we are in a symlink here.
grunt --path=`dirname pwd`/../var/invenio.base-instance/static || die 1 "grunt failed"

inveniomanage database init --yes-i-know --user=root --password=invenio
inveniomanage database create
inveniomanage demosite create
# Populate requires the server to be running as well as redis.
redis-server &
REDIS_PID=$!
inveniomanage runserver &
INVENIO_PID=$!

inveniomanage demosite populate

redis-cli flushdb

kill $REDIS_PID
kill $INVENIO_PID

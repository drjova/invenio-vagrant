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

mkvirtualenv pu || die "mkvirtualenv pu"
workon pu
cdvirtualenv

mkdir -p src
rm -r src/invenio
rm -r src/demosite
ln -s ~/invenio src/invenio
ln -s ~/demosite src/demosite

cd src/invenio
pip install -U pip
pip install -e . --process-dependency-links --allow-all-external

pybabel compile -fd invenio/base/translations || die 1 "pybabel compile failed"

inveniomanage config create secret-key
inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backend.console.Mail
inveniomanage config set CFG_BIBSHED_PROCESS_USER `whoami`
inveniomanage config set CFG_DATABASE_NAME invenio
inveniomanage config set CFG_DATABASE_USER invenio
inveniomanage config set PACKAGES "['invenio_demosite', 'invenio.modules.*']"
npm install || die 1 "npm install failed"
bower install || die 1 "bower install failed"
# dirname pwd because we are in a symlink here.
grunt build --path=`dirname pwd`/../var/invenio.base-instance/static || die 1 "grunt build failed"

cd ../..
mkdir -p var/run
mkdir -p var/tmp
mkdir -p var/tmp-shared
cd src/demosite

pip install -e . --allow-all-external

cd ../invenio
inveniomanage database init --yes-i-know --user=root --password=invenio
inveniomanage database create
inveniomanage demosite create
inveniomanage runserver &
inveniomanage demosite populate
redis-cli flushdb
fg

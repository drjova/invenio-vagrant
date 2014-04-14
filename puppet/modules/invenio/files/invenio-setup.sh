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
workon | grep -q ^pu$
if [ "$?" -ne "0" ]; then
    mkvirtualenv pu || die 1 "mkvirtualenv pu"
else
    workon pu
fi

cdvirtualenv

mkdir -p src
rm -rf src/invenio
rm -rf src/demosite
ln -s ~/invenio src/invenio
ln -s ~/demosite src/demosite

mkdir -p var/run
mkdir -p var/tmp
mkdir -p var/tmp-shared

# Silent bower
mkdir -p .config/configstore
echo optOut: true > .config/configstore/insight-bower.yml

cd src/invenio

pip install -U flower honcho pip
pip install -e . --process-dependency-links --allow-all-external
pip install -r requirements-img.txt
pip install -r requirements-extras.txt
npm install || die 1 "npm install failed"
bower install || die 1 "bower install failed"

cd ../demosite
pip install -e .

cd ../invenio

pybabel compile -fd invenio/base/translations || die 1 "pybabel compile failed"

inveniomanage config create secret-key
inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backends.console.Mail
inveniomanage config set CFG_BIBSCHED_PROCESS_USER `whoami`
inveniomanage config set CFG_DATABASE_NAME invenio
inveniomanage config set CFG_DATABASE_USER invenio
inveniomanage config set CFG_SITE_URL http://0.0.0.0:4000
inveniomanage config set PACKAGES "['invenio_demosite', 'invenio.modules.*']"

# dirname pwd because we are in a symlink directory here.
grunt --path=`dirname pwd`/../var/invenio.base-instance/static || die 1 "grunt failed"

# cleaning up old compiled files
find . -iname "*.pyc" -exec rm {} \;
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

echo "Kill inveniomanage manually if it still lives"
deactivate

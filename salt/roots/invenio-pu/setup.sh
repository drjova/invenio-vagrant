#!/bin/bash
{%- if grains["fqdn"] == "cds" -%}
    {%- set module = "cds_demosite" -%}
    {%- set port = 4004 -%}
{%- else -%}
    {%- set module = "invenio_demosite" -%}
    {%- set port = 4004 -%}
{%- endif %}

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
    workon pu || die 1 "workon pu"
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

cd src/invenio

# Silent bower
mkdir -p $HOME/.config/configstore
echo optOut: true > $HOME/.config/configstore/insight-bower.yml

pip install -e . --process-dependency-links --allow-all-external || die 1 "invenio install failed"
pip install -r requirements-img.txt
pip install -r requirements-extras.txt
npm install || die 1 "npm install failed"
bower install || die 1 "bower install failed"

cd ../demosite
pip install -e . || die 1 "demosite install failed"

cd ../invenio

pybabel compile -fd invenio/base/translations || die 1 "pybabel compile failed"

inveniomanage config create secret-key
inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backends.console.Mail
inveniomanage config set CFG_BIBSCHED_PROCESS_USER $USER
inveniomanage config set CFG_DATABASE_NAME invenio
inveniomanage config set CFG_DATABASE_USER invenio
inveniomanage config set CFG_SITE_URL http://0.0.0.0:{{ port }}
inveniomanage config set DEBUG True
inveniomanage config set COLLECT_STORAGE invenio.ext.collect.storage.link

grunt || die 1 "grunt failed"
inveniomanage collect

# cleaning up old compiled files
find . -iname "*.pyc" -exec rm {} \;
inveniomanage database init --yes-i-know --user=root
inveniomanage database create
inveniomanage demosite create --packages={{ module  }}.base

# populate requires the server to be running as well as redis.
inveniomanage runserver &
INVENIO_PID=$!

inveniomanage demosite populate --packages={{ module  }}.base

redis-cli flushdb

pkill -TERM -P $INVENIO_PID

deactivate

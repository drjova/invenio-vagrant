#!/bin/bash
{%- if grains["fqdn"] == "cds" -%}
    {%- set module = "cds" -%}
    {%- set port = 4004 -%}
{%- else -%}
    {%- set module = "invenio_demosite" -%}
    {%- set port = 4000 -%}
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

# verbose
set -v
set -o pipefail
IFS=$'\n\t'

source /usr/local/bin/virtualenvwrapper.sh
workon | grep -q ^pu$
if [ "$?" -ne "0" ]; then
    mkvirtualenv pu
else
    workon pu
fi

cdvirtualenv

mkdir -p src
rm -rf src/invenio
rm -rf src/demosite
ln -s ~/invenio src/invenio
ln -s ~/demosite src/demosite


rm -rf var/invenio.instance-base
mkdir -p var/run
mkdir -p var/tmp
mkdir -p var/tmp-shared

cd src/invenio

# Silent bower
mkdir -p $HOME/.config/configstore
echo optOut: true > $HOME/.config/configstore/insight-bower.yml

pip install -r requirements-docs.txt || die 1 "invenio install failed"
npm install
bower install

cd ../demosite
{%- if grains["fqdn"] == "cds" %}
pip install -r requirements.txt || die 1 "demosite install failed"
bower install
{%- else %}
pip install -r requirements.txt --exists-action i || die 1 "demosite install failed"
{%- endif %}

cd ../invenio

pybabel compile -fd invenio/base/translations

inveniomanage config create secret-key
inveniomanage config set CFG_EMAIL_BACKEND flask.ext.email.backends.console.Mail
inveniomanage config set CFG_BIBSCHED_PROCESS_USER $USER
inveniomanage config set CFG_DATABASE_NAME invenio
inveniomanage config set CFG_DATABASE_USER invenio
inveniomanage config set CFG_SITE_URL http://0.0.0.0:{{ port }}
inveniomanage config set DEBUG True
inveniomanage config set CLEANCSS_BIN `find $PWD/node_modules -iname cleancss | grep \\.bin | head -1`
inveniomanage config set LESS_BIN `find $PWD/node_modules -iname lessc | grep \\.bin |  head -1`
{%- if grains["fqdn"] == "cds" %}
inveniomanage config set LESS_RUN_IN_DEBUG True
inveniomanage config set REQUIREJS_BIN `find $PWD/node_modules -iname r.js | grep \\.bin | head -1`
inveniomanage config set REQUIREJS_RUN_IN_DEBUG False
inveniomanage config set REQUIREJS_CONFIG js/build.js
inveniomanage config set UGLIFYJS_BIN `find $PWD/node_modules -iname uglifyjs | grep \\.bin | head -1`
inveniomanage config set ASSETS_DEBUG True
{%- else %}
inveniomanage config set LESS_RUN_IN_DEBUG False
inveniomanage config set ASSETS_DEBUG False
{%- endif %}
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

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
    mkvirtualenv pu --no-site-packages || die 1 "mkvirtualenv pu"
fi

workon pu
cdvirtualenv

mkdir -p src
rm -r src/invenio
rm -r src/demosite
ln -s ~/invenio src/invenio
ln -s ~/demosite src/demosite

mkdir -p var/run
mkdir -p var/tmp
mkdir -p var/tmp-shared

deactivate

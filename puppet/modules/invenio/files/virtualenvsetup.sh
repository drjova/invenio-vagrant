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

deactivate

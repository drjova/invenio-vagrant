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
pip install -U flower
pip install -U honcho
pip install -U pip
pip install -e . --process-dependency-links --allow-all-external

npm install || die 1 "npm install failed"
bower install || die 1 "bower install failed"

cd ../..
cd src/demosite

pip install -e . --allow-all-external

deactivate

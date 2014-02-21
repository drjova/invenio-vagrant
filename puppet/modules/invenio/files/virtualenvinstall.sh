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
pip install -r requirements-img.txt
pip install -r requirements-extras.txt

npm install || die 1 "npm install failed"
bower install || die 1 "bower install failed"

deactivate

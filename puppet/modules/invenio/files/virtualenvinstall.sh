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
export PATH+=:/usr/local/bin
npm config set prefix /usr/local
npm install -g bower grunt-cli
mkdir -p .config/configstore
echo optOut: true > .config/configstore/insight-bower.yml

workon pu
cdvirtualenv

cd src/invenio
pip install -U flower honcho pip
pip install -e . --process-dependency-links --allow-all-external
pip install -r requirements-img.txt
pip install -r requirements-extras.txt

cd ../demosite
pip install -e .

cd ../invenio


npm install || die 1 "npm install failed"
bower install || die 1 "bower install failed"

deactivate

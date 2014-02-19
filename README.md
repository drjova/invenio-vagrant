# Vagrant setup for invenio _pu_ branch.

A simple setup to develop on Invenio's _pu_ branch (or _next_). For a more
complete setup, Tibor's VM might be what you're looking for:
http://invenio-software.org/wiki/Development/VirtualEnvironments

## Setup

In this setup, you'll have all the three components separate. It's an easy
setup to be able to work from your machine (and not within the VM).

    $ git clone -b pu https://github.com/jirikuncar/invenio
    $ git clone -b pu https://github.com/inveniosoftware/invenio-demosite
    $ git clone https://github.com/greut/invenio-vagrant

## Usage

Provisioning may take quite some time, no worries. If it fails, run the scripts
manually, they are located in the home directory.

    $ # on the host
    $ cd invenio-vagrant
    $ vagrant init
    $ vagrant up
    $ vagrant provision
    $ vagrant ssh
    $ # on the VM
    $ workon pu
    $ inveniomanage runserver

Then open your favourite web browser on http://localhost:4000/

## FIXME

* `nodejs` needs to be installed manually because the apt version is too old.
  (See: [Installing Node.js via package
  manager](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager))

## Problems?

I should be hanging around on IRC: irc://irc.freenode.net/#invenio

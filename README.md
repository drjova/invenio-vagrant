# Vagrant setup for invenio.

A simple setup to develop on Invenio's. For a more complete setup, Tibor's VM
might be what you're looking for:
http://invenio-software.org/wiki/Development/VirtualEnvironments

##  `master` branch

### Setup

First, we need to grab the invenio repository and devscripts.

    $ git clone https://github.com/inveniosoftware/invenio
    $ git clone https://github.com/tiborsimko/invenio-devscripts
    $ git clone https://github.com/greut/invenio-vagrant

#### Install VB-guest

[vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) is a plugin
that will automagically upgrade the _VirtualBox Guest Additions_.

    $ vagrant plugin install vagrant-vbguest

### Usage

    $ # on the host
    $ cd invenio-vagrant
    $ vagrant up master
    $ vagrant ssh master
    $ # on the VM
    $ invenio-kickstart --yes-i-know --yes-i-really-know

The service should be running on: http://localhost:8080

### Update

    $ cd invenio-trac
    $ git pull
    $ vagrant ssh master
    $ cd private/ssh
    $ invenio-make-install

## `next` branch (aka `pu`)

### Setup

In this setup, you'll have all the three components separate. It's an easy
setup to be able to work from your machine (and not within the VM).

    $ git clone -b pu https://github.com/inveniosoftware/invenio
    $ git clone -b pu https://github.com/inveniosoftware/invenio-demosite
    $ git clone https://github.com/greut/invenio-vagrant

### Usage

Provisioning may take quite some time, no worries. If it fails, run the scripts
manually, they are located in the home directory.

    $ # on the host
    $ cd invenio-vagrant
    $ vagrant up next
    $ vagrant ssh next
    $ # on the VM
    $ ./invenio-setup.sh # and grab a coffee
    $ workon pu
    $ cdvirtualenv
    $ cd src/invenio
    $ honcho start -f Procfile

Then open your favourite web browser on http://localhost:4000/

## `cds` next

This one is very similar to the above one (`next`) but uses another demosite.

    $ git clone -b pu https://github.com/inveniosoftware/invenio
    $ git clone -b pu https://github.com/CERNDocumentServer/cds-demosite
    $ git clone https://github.com/greut/invenio-vagrant

From there, you can set it up and follow the steps from `next`.

    $ vagrant up cds

## Problems?

I should be hanging around on IRC: irc://irc.freenode.net/#invenio

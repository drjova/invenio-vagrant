# Vagrant setup for invenio.

A simple setup to develop on Invenio's. For a more complete setup, Tibor's VM
might be what you're looking for:
http://invenio-software.org/wiki/Development/VirtualEnvironments

##  `master` branch

### Setup

First, we need to grab the invenio repository and devscripts.

    $ git clone http://invenio-software.org/repo/invenio
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
    $ # on the VM, if you encounter problems with mount
    $ # https://github.com/mitchellh/vagrant/issues/3341#issuecomment-38887958
    $ sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/
    $ sudo apt-get update && \
      sudo apt-get dist-upgrade -qy && \
      sudo apt-get install -y puppet
    $ sudo poweroff
    $ # on the host
    $ vagrant up master
    $ vagrant ssh master
    $ # on the VM
    $ invenio-kickstart --yes-i-know --yes-i-really-know

The service should be running on: http://localhost:8000

### Update

    $ cd invenio-trac
    $ git pull
    $ vagrant ssh master
    $ cd private/ssh
    $ invenio-make-install

## `pu` branch (aka `next`)

### Setup

In this setup, you'll have all the three components separate. It's an easy
setup to be able to work from your machine (and not within the VM).

    $ git clone -b pu https://github.com/jirikuncar/invenio
    $ git clone -b pu https://github.com/inveniosoftware/invenio-demosite
    $ git clone https://github.com/greut/invenio-vagrant

### Usage

Provisioning may take quite some time, no worries. If it fails, run the scripts
manually, they are located in the home directory.

    $ # on the host
    $ cd invenio-vagrant
    $ vagrant init
    $ vagrant up next
    $ # on the VM, if you encounter problems with mount
    $ # https://github.com/mitchellh/vagrant/issues/3341#issuecomment-38887958
    $ sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    $ sudo apt-get update && \
      sudo apt-get dist-upgrade -qy && \
      sudo apt-get install -y puppet
    $ sudo poweroff
    $ # on the host
    $ vagrant up next
    $ vagrant ssh next
    $ # on the VM
    $ ./invenio-setup.sh # and grab a coffee
    $ workon pu
    $ cdvirtualenv
    $ cd src/invenio
    $ honcho start -f Procfile

Then open your favourite web browser on http://localhost:4000/

## Problems?

I should be hanging around on IRC: irc://irc.freenode.net/#invenio

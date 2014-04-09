class invenio {
    package {
        "libjpeg-dev": ensure => "present";
        "libfreetype6-dev": ensure => "present";
        "libmysqlclient-dev": ensure => "present";
        "libtiff5-dev": ensure => "present";
        "libxml2-dev": ensure => "present";
        "libxslt-dev": ensure => "present";
        "libwebp-dev": ensure => "present";
        "npm": ensure => "present";
        "virtualenvwrapper":
            ensure => "latest",
            provider => "pip";
    } ->
    # http://howtonode.org/introduction-to-npm
    exec { "symlinking node":
        unless => "test -e /usr/bin/node",
        command => "ln -s /usr/bin/nodejs /usr/bin/node"
    } ->
    exec { "chown /usr/local":
        command => "chown -R vagrant:vagrant /usr/local"
    } ->
    exec { "updating npm ":
        unless => "test -e /usr/bin/npm-1.2",
        command => "npm install -g npm",
        user => "vagrant",
        group => "vagrant",
        logoutput => "on_failure"
    } ->
    exec { "deactivate old npm":
        unless => "test -e /usr/bin/npm-1.2",
        command => "mv /usr/bin/npm /usr/bin/npm-1.2",
    }

    file { "/home/vagrant/invenio-setup.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/invenio-setup.sh"
    }
}

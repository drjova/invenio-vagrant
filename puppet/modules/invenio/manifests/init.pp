class invenio {
    package {
        "libmysqlclient-dev": ensure => "present";
        "libxml2-dev": ensure => "present";
        "libxslt-dev": ensure => "present";
        # NodeJS is required but the vanilla version may be too old.
        # https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
        "npm": ensure => "present";
        "virtualenvwrapper":
            ensure => "latest",
            provider => "pip";
        "grunt-cli":
            ensure => "latest",
            provider => "npm";
        "bower":
            ensure => "latest",
            provider => "npm";
    }

    file {
        "/home/vagrant/virtualenvsetup.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/virtualenvsetup.sh"
    }
    file {
        "/home/vagrant/virtualenvinstall.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/virtualenvinstall.sh"
    }
    file {
        "/home/vagrant/virtualenvconfigure.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/virtualenvconfigure.sh"
    }
}

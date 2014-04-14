class invenio {
    package { ["libjpeg-dev", "libfreetype6-dev", "libmysqlclient-dev",
               "libtiff-dev", "libxml2-dev","libxslt-dev", "libwebp-dev"]:
        ensure => "present",
        require => Anchor["nodejs::repo"]
    } ->
    package { ["grunt-cli", "bower"]:
        ensure => "present",
        provider => "npm",
        require => Exec["apt-get update"]
    } ->
    package { "virtualenvwrapper":
        ensure => "present",
        provider => "pip"
    }

    file { "/home/vagrant/invenio-setup.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/invenio-setup.sh"
    }
}

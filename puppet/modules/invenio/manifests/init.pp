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
    exec { "revert nodejs exec for bower":
        cwd => "/home/vagrant",
        path => ["/bin", "/usr/bin"],
        command => "rm -f /usr/local/bin/bower"
    } ->
    exec { "npm install -g grunt-cli bower":
        cwd => "/home/vagrant",
        path => ["/bin", "/usr/bin", "/usr/local/bin"],
        command => "npm install -g grunt-cli bower"
    } ->
    exec { "fix nodejs exec for bower":
        cwd => "/home/vagrant",
        path => ["/bin", "/usr/bin"],
        command => "sed -i \"s/env nodejs/env node/\" /usr/local/bin/bower"
    } ->
    exec { "silent bower":
        cwd => "/home/vagrant",
        user => "vagrant",
        group => "vagrant",
        path => ["/bin", "/usr/bin"],
        command => "mkdir -p ~/.config/configstore && echo optOut: true > ~/.config/configstore/insight-bower.yml"
    }

    file { "/home/vagrant/virtualenvsetup.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/virtualenvsetup.sh"
    }
    file { "/home/vagrant/virtualenvinstall.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/virtualenvinstall.sh"
    }
    file { "/home/vagrant/virtualenvconfigure.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/invenio/virtualenvconfigure.sh"
    }
}

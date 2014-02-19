stage { "pre":
    before => Stage["main"]
}

class {
    "baseconfig": stage => "pre";
    "python": stage => "pre";
}

File {
    owner => "vagrant",
    group => "vagrant",
    mode => "0644",
}

include baseconfig
include python

node default {
    include invenio

    class { "nginx": }

    nginx::resource::upstream { "invenio":
        ensure => "present",
        members => ["localhost:4000"]
    }

    nginx::resource::vhost { "localhost":
        ensure => "present",
        proxy => "http://invenio"
    } ->
    exec { "rm default nginx conf":
        cwd => "/",
        path => ["/bin", "/usr/bin"],
        command => "rm -f /etc/nginx/conf.d/default.conf"
    }

    class { "redis": }

    class { "::mysql::server":
        root_password => "invenio",
        override_options => { "mysqld" => { "max_connections" => 1024 }}
    }

    mysql::db { "invenio":
        user => "invenio",
        password => "my123p\$ss",
        host => "localhost",
        grant => ["ALL"]
    } ->
    exec { "virtualenvsetup.sh":
        cwd => "/home/vagrant",
        user => "vagrant",
        group => "vagrant",
        environment => [ "HOME=/home/vagrant" ],
        path => ["/bin", "/usr/bin", "/usr/local/bin"],
        command => "/home/vagrant/virtualenvsetup.sh",
        require => [File["/home/vagrant/virtualenvsetup.sh"]],
        logoutput => "true"
    } ->
    exec { "virtualenvinstall.sh":
        cwd => "/home/vagrant",
        user => "vagrant",
        group => "vagrant",
        environment => [ "HOME=/home/vagrant" ],
        path => ["/bin", "/usr/bin", "/usr/local/bin"],
        command => "/home/vagrant/virtualenvinstall.sh",
        require => [File["/home/vagrant/virtualenvinstall.sh"]],
        logoutput => "true"
    } ->
    exec { "virtualenvconfigure.sh":
        cwd => "/home/vagrant",
        user => "vagrant",
        group => "vagrant",
        environment => [ "HOME=/home/vagrant" ],
        path => ["/bin", "/usr/bin", "/usr/local/bin"],
        command => "/home/vagrant/virtualenvconfigure.sh",
        require => [File["/home/vagrant/virtualenvconfigure.sh"]],
        logoutput => "true"
    }
}

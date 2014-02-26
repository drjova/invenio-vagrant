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

    # Install redis-server and disable it from being autoloaded.
    class { "redis":
    } -> exec { "stop redis-server":
        path => ["/usr/bin"],
        command => "service redis-server stop"
    } -> exec { "disable redis-server":
        path => ["/usr/sbin"],
        command => "update-rc.d redis-server disable"
    }

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
        logoutput => "true",
        timeout => 0
    } ->
    exec { "virtualenvconfigure.sh":
        cwd => "/home/vagrant",
        user => "vagrant",
        group => "vagrant",
        environment => [ "HOME=/home/vagrant" ],
        path => ["/bin", "/usr/bin", "/usr/local/bin"],
        command => "/home/vagrant/virtualenvconfigure.sh",
        require => [File["/home/vagrant/virtualenvconfigure.sh"]],
        logoutput => "true",
        timeout => 0
    }
}
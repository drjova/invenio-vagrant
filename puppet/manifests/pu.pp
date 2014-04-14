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

Exec {
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin"]
}

include baseconfig
include python

node default {
    class { "nodejs":
        dev_package => false,
        manage_repo => true
    }

    include invenio

    # Install redis-server and disable it from being autoloaded.
    class { "redis":
    } -> exec { "stop redis-server":
        command => "service redis-server stop"
    } -> exec { "disable redis-server":
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
#    } ->
#    exec { "invenio-setup.sh":
#        cwd => "/home/vagrant",
#        user => "vagrant",
#        group => "vagrant",
#        environment => [ "HOME=/home/vagrant" ],
#        command => "/home/vagrant/invenio-setup.sh",
#        require => [File["/home/vagrant/invenio-setup.sh"]],
#        logoutput => "on_failure"
#        timeout => 0
    }
}

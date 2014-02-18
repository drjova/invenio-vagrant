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

    class { "::mysql::server":
        root_password => "invenio",
        override_options => { "mysqld" => { "max_connections" => 1024 }}
    }

    # Installed manually
    #class { "::mysql::bindings":
    #    python_enable => 1
    #}

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
    }
}

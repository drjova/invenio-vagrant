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

    class { "::mysql::server":
        root_password => "invenio",
        override_options => { "mysqld" => { "max_connections" => 1024 }}
    }

    mysql::db { "invenio":
        user => "invenio",
        password => "my123p\$ss",
        host => "localhost",
        grant => ["ALL"]
    }
}

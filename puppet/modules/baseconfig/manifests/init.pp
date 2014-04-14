class baseconfig {
    exec { "apt-get update":
        command => "apt-get update"
    } ->
    package {
        "git": ensure => "present";
        "vim": ensure => "present";
        "curl": ensure => "present";
    }

    file {
        "/home/vagrant/.bashrc":
        owner => "vagrant",
        group => "vagrant",
        mode => "0644",
        source => "puppet:///modules/baseconfig/bashrc"
    }
    file {
        "/etc/sudoers.d/vagrant":
        owner => "root",
        group => "root",
        mode => "0440",
        source => "puppet:///modules/baseconfig/sudoer"
    }
}

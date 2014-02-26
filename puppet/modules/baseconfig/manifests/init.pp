class baseconfig {
    exec {
        "apt-get update": command => "/usr/bin/apt-get update";
        "apt-get upgrade": command => "/usr/bin/apt-get -y upgrade";
#        "gem update": command => "/opt/vagrant_ruby/bin/gem update";
    }

    package {
        "git": ensure => "present";
        "vim": ensure => "present";
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

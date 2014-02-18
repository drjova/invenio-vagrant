class baseconfig {
    exec {
        "apt-get update": command => "/usr/bin/apt-get update";
#        "gem update": command => "/opt/vagrant_ruby/bin/gem update";
    }

    package { "vim": ensure => "present"; }

    file {
        "/home/vagrant/.bashrc":
        owner => "vagrant",
        group => "vagrant",
        mode => "0644",
        source => "puppet:///modules/baseconfig/bashrc"
    }
}

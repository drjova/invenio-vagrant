class baseconfig {
    exec {
        "apt-get update": command => "/usr/bin/apt-get update";
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
    } ->
    file {
        "/home/vagrant/virtualenvsetup.sh":
        owner => "vagrant",
        group => "vagrant",
        mode => "0755",
        source => "puppet:///modules/baseconfig/virtualenvsetup.sh"
    }
}

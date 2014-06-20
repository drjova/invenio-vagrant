# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<EOF
# the puppetlabs box created a vagrant user with no default shell
echo vagrant user to use /bin/bash as default shell.
sed -i "s/vagrant:$/vagrant:\\/bin\\/bash/" /etc/passwd
EOF

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Ubuntu 14.04 LTS x86_64
  config.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
  # Ubuntu 14.04 LTS x86
  #config.vm.box = "puppetlabs/ubuntu-14.04-32-nocm"

  config.vm.provision :shell, inline: $script

  config.vm.define "next" do |node|
    # documentation served using python -m SimpleHTTPServer
    node.vm.network :forwarded_port, guest: 8000, host: 8000
    # invenio
    node.vm.network :forwarded_port, guest: 4000, host: 4000
    # flower
    node.vm.network :forwarded_port, guest: 5555, host: 5555

    node.vm.hostname = "next"

    node.vm.synced_folder "../webassets", "/home/vagrant/webassets"
    node.vm.synced_folder "../invenio", "/home/vagrant/invenio"
    node.vm.synced_folder "../invenio-demosite", "/home/vagrant/demosite"
    node.vm.synced_folder "salt/roots", "/srv/salt"

    node.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion.sls"
      salt.run_highstate = true
      #salt.verbose = true
    end
  end

  config.vm.define "cds" do |node|
    # documentation served using python -m SimpleHTTPServer
    node.vm.network :forwarded_port, guest: 8000, host: 8008
    # invenio
    node.vm.network :forwarded_port, guest: 4004, host: 4004
    # flower
    node.vm.network :forwarded_port, guest: 5555, host: 5550

    node.vm.hostname = "cds"

    node.vm.synced_folder "../invenio", "/home/vagrant/invenio"
    node.vm.synced_folder "../cds-demosite", "/home/vagrant/demosite"
    node.vm.synced_folder "salt/roots", "/srv/salt"

    node.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion.sls"
      salt.run_highstate = true
      #salt.verbose = true
    end
  end

  config.vm.define "master" do |node|
    # Apache: invenio
    node.vm.network :forwarded_port, guest: 80, host: 8080
    # Apache: invenio-ssl
    node.vm.network :forwarded_port, guest: 443, host: 8443

    node.vm.synced_folder "../invenio", "/home/vagrant/private/src/invenio"
    node.vm.synced_folder "../invenio-devscripts", "/home/vagrant/private/src/invenio-devscripts"
    node.vm.synced_folder "salt/roots", "/srv/salt"

    node.vm.provision :salt do |salt|
      salt.minion_config = "salt/minion.sls"
      salt.run_highstate = true
      #salt.verbose = true
    end
  end

  config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # set auto_update to false, if you do NOT want to check the correct
  # additions version when booting this machine
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = true
    # do NOT download the iso file from a webserver
    config.vbguest.no_remote = false
  end
end

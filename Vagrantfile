# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.provider "virtualbox" do |v|
	  v.memory = 2 * 1024
    v.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p ~root/.ssh
    cp -v ~vagrant/.ssh/auth* ~root/.ssh/
  SHELL

  config.vm.define "ns01" do |ns01|
    ns01.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "dns"
    ns01.vm.hostname = "ns01"
  end

  config.vm.define "ns02" do |ns02|
    ns02.vm.network "private_network", ip: "192.168.50.11", virtualbox__intnet: "dns"
    ns02.vm.hostname = "ns02"
  end

  config.vm.define "client" do |client|
    client.vm.network "private_network", ip: "192.168.50.15", virtualbox__intnet: "dns"
    client.vm.hostname = "client"
  end

  config.vm.define "client2" do |client2|
    client2.vm.network "private_network", ip: "192.168.50.16", virtualbox__intnet: "dns"
    client2.vm.hostname = "client2"
    client2.vm.provision "ansible" do |ansible|
      #ansible.verbose = "vvv"
      ansible.playbook = "provisioning/playbook.yml"
      ansible.become = "true"
      ansible.compatibility_mode = "2.0"
      ansible.version = "latest"
      ansible.host_key_checking = false
      ansible.limit = "all"
    end
  end

end

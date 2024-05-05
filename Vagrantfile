# -*- mode: ruby -*-
# vi: set ft=ruby :
# export VAGRANT_EXPERIMENTAL="disks"

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "pxeserver" do |server|
    server.vm.box = 'centos/8'
    server.vm.disk :disk, size: "15GB", name: "extra_storage1"

    server.vm.host_name = 'pxeserver'
    server.vm.network :private_network, ip: "10.0.0.20", virtualbox__intnet: 'pxenet'
    server.vm.network :private_network, ip: "192.168.56.10", adapter: 3

    server.vm.provider "virtualbox" do |vb|
      vb.memory = 2 * 1024
      vb.cpus = "2"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    server.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.version = "latest"
      ansible.inventory_path = "ansible/hosts"
      ansible.playbook = "ansible/main.yml"
      ansible.limit = "all"
      ansible.host_key_checking = false
      #ansible.verbose = "vvv"
    end

  end

  config.vm.define "pxeclient" do |pxeclient|
    pxeclient.vm.box = 'centos/8'
    pxeclient.vm.host_name = 'pxeclient'
    pxeclient.vm.network :private_network, ip: "10.0.0.21", virtualbox__intnet: 'pxenet', adapter: 2
    pxeclient.vm.provider :virtualbox do |vb|
      vb.gui = true
      vb.memory = "2048"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize [
          'modifyvm', :id,
          '--nic1', 'intnet',
          '--intnet1', 'pxenet',
          #'--nic2', 'nat',
          '--boot1', 'net',
          '--boot2', 'none',
          '--boot3', 'none',
          '--boot4', 'none'
        ]
      vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
      vb.customize ["modifyvm", :id, "--vram", "128"]
    end
  end
end

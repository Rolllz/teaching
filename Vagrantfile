# -*- mode: ruby -*-"}
# vim: set ft=ruby :

name_of_box = "generic/debian12"

MACHINES = {
:inetRouter => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.255.1', 2, "255.255.255.252", "router1-net"],
    ['192.168.56.10', 8, "255.255.255.0"]
  ]
},
:inetRouter2 => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.0.66', 2, "255.255.255.192", "wifi-net"],
    ['192.168.56.17', 8, "255.255.255.0"]
  ]
},
:office1Router => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.255.10', 2, "255.255.255.252", "office1-net"],
    ['192.168.2.1', 3, "255.255.255.192", "dev1-net"],
    ['192.168.2.65', 4, "255.255.255.192", "test1-net"],
    ['192.168.2.129', 5, "255.255.255.192", "mgt1-net"],
    ['192.168.2.193', 6, "255.255.255.192", "hw1-net"],
    ['192.168.56.11', 8, "255.255.255.0"]
  ]
},
:office1Server => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.2.130', 2, "255.255.255.192", "mgt1-net"],
    ['192.168.56.12', 8, "255.255.255.0"]
  ]
},
:office2Router => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.255.6', 2, "255.255.255.252", "office2-net"],
    ['192.168.1.1', 3, "255.255.255.128", "dev2-net"],
    ['192.168.1.129', 4, "255.255.255.192", "test2-net"],
    ['192.168.1.193', 5, "255.255.255.192", "hw2-net"],
    ['192.168.56.13', 8, "255.255.255.0"]
  ]
},
:office2Server => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.1.2', 2, "255.255.255.128", "dev2-net"],
    ['192.168.56.14', 8, "255.255.255.0"]
  ]
},
:centralRouter => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.255.2', 2, "255.255.255.252", "router1-net"],
    ['192.168.255.9', 3, "255.255.255.252", "office1-net"],
    ['192.168.255.5', 4, "255.255.255.252", "office2-net"],
    ['192.168.0.1', 5, "255.255.255.240", "dir-net"],
    ['192.168.0.33', 6, "255.255.255.240", "hw-net"],
    ['192.168.0.65', 7, "255.255.255.192", "wifi-net"],
    ['192.168.56.15', 8, "255.255.255.0"]
  ]
},
:centralServer => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.0.2', 2, "255.255.255.240", "dir-net"],
    ['192.168.56.16', 8, "255.255.255.0"]
  ]
}
}

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxname.to_s

      boxconfig[:net].each do |ipconf|
        box.vm.network("private_network", ip: ipconf[0], adapter: ipconf[1], netmask: ipconf[2], virtualbox__intnet: ipconf[3])
      end

      if boxconfig.key?(:public)
        box.vm.network "public_network", boxconfig[:public]
      end

      box.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 1
      end

      box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
      SHELL

      if boxname.to_s == "centralServer"
        box.vm.provision "ansible" do |ansible|
          ansible.inventory_path = "ansible/hosts"
          ansible.compatibility_mode = "2.0"
          ansible.version = "latest"
          ansible.host_key_checking = false
          ansible.playbook = "ansible/main.yml"
          #ansible.verbose = "v"
          ansible.limit = "all"
        end
      end

    end
  end
end

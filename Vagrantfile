# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :nginx => {
        :box_name => "generic/debian12",
        :vm_name => "nginx",
        :net => [
           ["192.168.56.150",  2, "255.255.255.0"],
        ]
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.network "forwarded_port", guest: 8080, host: 2200
    config.vm.define boxname do |box|
   
      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxconfig[:vm_name]
      
      box.vm.provider "virtualbox" do |v|
        v.memory = 768
        v.cpus = 1
       end

      boxconfig[:net].each do |ipconf|
        box.vm.network "private_network", ip: ipconf[0], adapter: ipconf[1], netmask: ipconf[2]
      end

      if boxconfig.key?(:public)
        box.vm.network "public_network", boxconfig[:public]
      end

      box.vm.provision "shell", inline: <<-SHELL
        sudo sed -i 's/\#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config
        sudo sed -i 's/\#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
        sudo systemctl restart sshd
      SHELL
    end
  end
end

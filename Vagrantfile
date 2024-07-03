# -*- mode: ruby -*-"}
# vim: set ft=ruby :

MACHINES = {
  :master => {
    :ip => '192.168.56.10',
    :provision => 'backup.sh'
  },
  :slave => {
    :ip => '192.168.56.11',
    :provision => 'client.sh'
  }
}

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

      box.vm.box = "generic/debian12"
      box.vm.host_name = boxname.to_s

      box.vm.network("private_network", ip: boxconfig[:ip])

      if boxconfig.key?(:public)
        box.vm.network "public_network", boxconfig[:public]
      end

      box.vm.provider "virtualbox" do |v|
        v.memory = 4 * 1024
        v.cpus = 2
      end

      box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        apt update
      SHELL

      if boxname.to_s == "slave"
        box.vm.provision "ansible" do |ansible|
          #ansible.inventory_path = "ansible/hosts"
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

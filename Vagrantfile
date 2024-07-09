MACHINES = {
  :node1 => {
    :vm_name => "node1",
    :ip => "192.168.57.11"
  },
  :node2 => {
    :vm_name => "node2",
    :ip => "192.168.57.12"
  },
  :barman => {
    :vm_name => "barman",
    :ip => "192.168.57.13"
  }
}

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

      box.vm.box = "generic/debian12"
      box.vm.host_name = boxconfig[:vm_name]
      box.vm.network "private_network", ip: boxconfig[:ip]
      box.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 2
      end

      box.vm.provision :shell do |s|
        s.inline = 'mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh; apt update'
      end

      if boxconfig[:vm_name] == "barman"
        box.vm.provision "ansible" do |ansible|
          ansible.compatibility_mode = "2.0"
          ansible.version = "latest"
          ansible.host_key_checking = false
          ansible.playbook = "ansible/main.yml"
          #ansible.verbose = "vvvv"
          ansible.limit = "all"
        end
      end

    end
  end
end

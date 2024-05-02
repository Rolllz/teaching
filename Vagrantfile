# -*- mode: ruby -*-"}
# vim: set ft=ruby :
disk_dir = "/share/Virtualbox VMs/"

MACHINES = {
:backup => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.11.160', 2, "255.255.255.0", "backup-net"],
    ['192.168.56.10', 8, "255.255.255.0"]
  ],
  :dfile => disk_dir + 'backup.vdi',
  :provision => 'backup.sh'
},
:client => {
  :box_name => "generic/debian12",
  :net => [
    ['192.168.11.150', 2, "255.255.255.0", "backup-net"],
    ['192.168.56.11', 8, "255.255.255.0"]
  ],
  :provision => 'client.sh'
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
        v.memory = 2 * 1024
        v.cpus = 2

        if boxname.to_s == "backup"
          needsController = false
          if not File.exist?boxconfig[:dfile] then
            v.customize ['createmedium', '--filename', boxconfig[:dfile], '--variant', 'Fixed', '--size', 2 * 1024]
            needsController =  true
          end

          if needsController == true
            v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', boxconfig[:dfile]]
          end
        end
      end

      box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        apt update && apt install borgbackup -y
      SHELL

      if boxname.to_s == "client"
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

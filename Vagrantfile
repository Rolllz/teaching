Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.box = "generic/debian12"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |v|
    v.memory = 4 * 1024
    v.cpus = 4
    v.customize ["modifyvm", :id, '--audio', 'none']
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -mx
    mkdir -p ~root/.ssh
    cp ~vagrant/.ssh/auth* ~root/.ssh
    yes "vagrant" | sudo passwd root
    apt update
  SHELL

  config.vm.define "DynamicWeb" do |server|
    server.vm.network "forwarded_port", guest: 8083, host: 8083
    server.vm.network "forwarded_port", guest: 8081, host: 8081
    server.vm.network "forwarded_port", guest: 8082, host: 8082
    server.vm.hostname = "DynamicWeb"
    server.vm.network "private_network", ip: "192.168.56.10"
    server.vm.provision "ansible" do |ansible|
      #ansible.inventory_path = "ansible/hosts"
      ansible.compatibility_mode = "2.0"
      ansible.version = "2.16.7"
      ansible.host_key_checking = false
      ansible.playbook = "ansible.yml"
      #ansible.verbose = "v"
      ansible.limit = "all"
    end
  end

end

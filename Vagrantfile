Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.box = "centos/stream8"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4 * 1024
    v.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -mx
    mkdir -p ~root/.ssh
    cp ~vagrant/.ssh/auth* ~root/.ssh
    yes "vagrant" | sudo passwd root
    touch /.autorelabel
  SHELL

  config.vm.define "client1" do |client1|
    client1.vm.hostname = "client1.otus.lan"
    client1.vm.network "private_network", ip: "192.168.56.11"
  end

  config.vm.define "client2" do |client2|
    client2.vm.hostname = "client2.otus.lan"
    client2.vm.network "private_network", ip: "192.168.56.12"
  end

  config.vm.define "server" do |server|
    server.vm.hostname = "ipa.otus.lan"
    server.vm.network "private_network", ip: "192.168.56.10"
    server.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "ansible/hosts"
      ansible.compatibility_mode = "2.0"
      ansible.version = "2.16.7"
      ansible.host_key_checking = false
      ansible.playbook = "ansible/main.yml"
      #ansible.verbose = "v"
      ansible.limit = "all"
    end
  end

end

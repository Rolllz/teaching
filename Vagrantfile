Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.box = "generic/debian12"

  config.vm.provider "virtualbox" do |v|
    v.memory = 4 * 1024
    v.cpus = 4
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -mx
    mkdir -p ~root/.ssh
    cp ~vagrant/.ssh/auth* ~root/.ssh
    yes "vagrant" | sudo passwd root
  SHELL

  config.vm.define "client" do |client|
    client.vm.hostname = "client"
    client.vm.network "private_network", ip: "192.168.56.20"
  end

  config.vm.define "server" do |server|
    server.vm.hostname = "server"
    server.vm.network "private_network", ip: "192.168.56.10"
    server.vm.provision "ansible" do |ansible|
      ansible.inventory_path = "ansible/hosts"
      ansible.compatibility_mode = "2.0"
      ansible.version = "latest"
      ansible.host_key_checking = false
      ansible.playbook = "ansible/main.yml"
      #ansible.verbose = "v"
      ansible.limit = "all"
    end
=begin

    server.vm.provision "shell", inline: <<-SHELL
      apt update && apt install openvpn sshpass -y
      cd /etc/openvpn
      yes "" | ssh-keygen -N ""
      sshpass -p "vagrant" ssh-copy-id -o stricthostkeychecking=no root@192.168.56.20
      /usr/share/easy-rsa/easyrsa init-pki
      EASYRSA_BATCH='1'
      echo 'rasvpn' | /usr/share/easy-rsa/easyrsa build-ca nopass
      echo 'rasvpn' | /usr/share/easy-rsa/easyrsa gen-req server nopass
      echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req server server
      /usr/share/easy-rsa/easyrsa gen-dh
      openvpn --genkey secret ca.key
      echo 'client' | /usr/share/easy-rsa/easyrsa gen-req client nopass
      echo 'yes' | /usr/share/easy-rsa/easyrsa sign-req client client
      echo 'iroute 10.10.10.0 255.255.255.0' > /etc/openvpn/client/client
    SHELL
=end
  end

end

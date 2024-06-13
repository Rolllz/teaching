debian = "generic/debian12"
debianv = "latest"

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  config.vm.box = debian

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -x
    mkdir -p ~root/.ssh
    cp ~vagrant/.ssh/auth* ~root/.ssh
    yes "vagrant" | sudo passwd root
    #apt update && apt install net-tools tcpdump ifenslave traceroute bridge-utils -y
  SHELL

  config.vm.define "inetRouter" do |inetRouter|
    inetRouter.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "router-net"
    inetRouter.vm.network "private_network", adapter: 3, auto_config: false, virtualbox__intnet: "router-net"
    inetRouter.vm.network "private_network", adapter: 8, ip: "192.168.56.10"
    inetRouter.vm.hostname = "inetRouter"
  end

  config.vm.define "centralRouter" do |centralRouter|
    centralRouter.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "router-net"
    centralRouter.vm.network "private_network", adapter: 3, auto_config: false, virtualbox__intnet: "router-net"
    centralRouter.vm.network "private_network", ip: "192.168.255.9", adapter: 6, netmask: "255.255.255.252", virtualbox__intnet: "office1-central"
    centralRouter.vm.network "private_network", adapter: 8, ip: "192.168.56.11"
    centralRouter.vm.hostname = "centralRouter"
  end

  config.vm.define "office1Router" do |office1Router|
    office1Router.vm.network "private_network", ip: '192.168.255.10', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "office1-central"
    office1Router.vm.network "private_network", adapter: 3, auto_config: false, virtualbox__intnet: "vlan1"
    office1Router.vm.network "private_network", adapter: 4, auto_config: false, virtualbox__intnet: "vlan1"
    office1Router.vm.network "private_network", adapter: 5, auto_config: false, virtualbox__intnet: "vlan2"
    office1Router.vm.network "private_network", adapter: 6, auto_config: false, virtualbox__intnet: "vlan2"
    office1Router.vm.network "private_network", adapter: 8, ip: "192.168.56.20"
    office1Router.vm.hostname = "office1Router"
  end

  config.vm.define "testClient1" do |testClient1|
    testClient1.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testvlan"
    testClient1.vm.network "private_network", adapter: 8, ip: "192.168.56.21"
    testClient1.vm.hostname = "testClient1"
  end

  config.vm.define "testServer1" do |testServer1|
    testServer1.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testvlan"
    testServer1.vm.network "private_network", adapter: 8, ip: "192.168.56.22"
    testServer1.vm.hostname = "testServer1"
  end

  config.vm.define "testClient2" do |testClient2|
    testClient2.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testvlan"
    testClient2.vm.network "private_network", adapter: 8, ip: "192.168.56.31"
    testClient2.vm.hostname = "testClient2"
  end

  config.vm.define "testServer2" do |testServer2|
    testServer2.vm.network "private_network", adapter: 2, auto_config: false, virtualbox__intnet: "testvlan"
    testServer2.vm.network "private_network", adapter: 8, ip: "192.168.56.32"
    testServer2.vm.hostname = "testServer2"
    testServer2.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/main.yml"
      ansible.compatibility_mode = "2.0"
      ansible.version = "2.16.7"
      ansible.inventory_path = "hosts"
      ansible.host_key_checking = "false"
      ansible.limit = "all"
    end
  end

end

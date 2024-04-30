Vagrant.configure("2") do |config|

    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end
    # Base VM OS configuration.
    config.vm.box = "generic/debian12"
    config.vm.provider :virtualbox do |v|
        v.memory = 1512
        v.cpus = 2
    end

    # Define two VMs with static private IP addresses.
    boxes = [
        {
            :name => "web",
            :ip => "192.168.56.10",
        },
        {
            :name => "log",
            :ip => "192.168.56.15",
        }
    ]

    # Provision each of the VMs.
    boxes.each do |opts|
        config.vm.define opts[:name] do |config|
            config.vm.hostname = opts[:name]
            config.vm.network "private_network", ip: opts[:ip]
            if opts[:name] == "log"
                config.vm.provision "ansible" do |ansible|
                    ansible.playbook = "ansible/main.yml"
                    ansible.compatibility_mode = "2.0"
                    ansible.inventory_path = "ansible/hosts"
                    ansible.host_key_checking = "false"
                    ansible.limit = "all"
                    ansible.version = "latest"
                end
            end
        end
    end
end

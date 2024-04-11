vars = {
    :box_name => "generic/debian12",
    :box_version => "4.3.12",
    :name => "pam",
    :ip => "192.168.57.10",
    :memory => 4 * 1024,
    :cpus => "6"
}

Vagrant.configure(2) do |config|

    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end

    config.vm.synced_folder ".", "/vagrant", disabled: false
    config.ssh.insert_key = false
    config.vm.box_version = vars[:box_version]
    config.vm.define vars[:name] do |box|

        box.vm.box = vars[:box_name]
        box.vm.host_name = vars[:name]
        box.vm.network "private_network", ip: vars[:ip]

        box.vm.provider :virtualbox do |vb|
            vb.memory = vars[:memory]
            vb.cpus = vars[:cpus]
        end

        box.vm.provision "shell", path: "./pam.sh"
        
    end
end

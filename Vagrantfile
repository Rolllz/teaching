vars = {
    :box_name => "generic/debian12",
    :box_version => "4.3.12",
    :name => "systemd"
}

Vagrant.configure(2) do |config|

    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end

    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.box_version = vars[:box_version]
    config.vm.define vars[:name] do |box|

        box.vm.box = vars[:box_name]
        box.vm.host_name = vars[:name]

        box.vm.provider :virtualbox do |vb|
            #vb.gui = true
            vb.customize ["modifyvm", :id, "--memory", 4 * 1024]
            vb.customize ["modifyvm", :id, "--cpus", "6"]
        end

        box.vm.provision "shell", path: "./script.sh"
        
    end
end

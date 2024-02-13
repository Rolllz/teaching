vars = {
    :box_name => "generic/centos8s",
    :box_version => "4.3.12"
}

Vagrant.configure(2) do |config|

    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end

    config.vm.synced_folder ".", "/vagrant", disabled: false
    config.vm.box_version = vars[:box_version]
    config.vm.define "rpm" do |box|

        box.vm.box = vars[:box_name]
        box.vm.host_name = "rpm"

        box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", 4 * 1024]
                vb.customize ["modifyvm", :id, "--cpus", "6"]
        end

        box.vm.provision "shell", path: "./script.sh"
            
    end
end
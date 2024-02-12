# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa

vars = {
    :box_name => "centos/7",
    :box_version => "2004.01",
    :net => "net1",
    :netmask => "255.255.255.0"
}

MACHINES = {
    :nfss => {
        :addr => "192.168.56.10",
        :provision => "./centos-server.sh"
    },
    :nfsc => {
        :addr => "192.168.56.11",
        :provision => "./centos-client.sh"
    }
}

Vagrant.configure(2) do |config|

    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end

    MACHINES.each do |boxname, boxconfig|

        #config.vm.synced_folder ".", "/vagrant", disabled: false
        config.vm.box_version = vars[:box_version]
        config.vm.define boxname do |box|

            box.vm.box = vars[:box_name]
            box.vm.host_name = boxname.to_s
            box.vm.network "private_network", ip: boxconfig[:addr], virtualbox__intnet: vars[:net]

            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", 4 * 1024]
                    vb.customize ["modifyvm", :id, "--cpus", "3"]
            end

            box.vm.provision "shell", path: boxconfig[:provision]
            if boxname.to_s == "nfsc" then
                box.vm.provision "shell", run: "always", inline: "ls -al /mnt && showmount -a 192.168.56.10"
            end
        end
    end
end

# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

vars = {
    :box_name => "generic/debian12",
    :box_version => "4.3.12",
    :net => "vboxnet0",
    :command => "apt update && apt -y install firewalld ",
    :netmask => "255.255.255.0"
}

MACHINES = {
    :server => {
        :addr => "192.168.56.10",
        :apt => "nfs-kernel-server",
        :provision => "./server.sh"
    },
    :client => {
        :addr => "192.158.56.11",
        :apt => "nfs-common",
        :provision => "./client.sh"
    }
}

Vagrant.configure("2") do |config|

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
        end
    end
end

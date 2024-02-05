# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"
current_dir = File.dirname(File.expand_path(__FILE__))
disk_dir = "/share/Virtualbox VMs/"

MACHINES = {
  :lvm => {
        :box_name => "centos/7",
        :box_version => "1804.2",
        :ip_addr => '192.168.56.101',
    :disks => {
        :sata1 => {
            :dfile => disk_dir + 'sata1.vdi',
            :size => 10 * 1024,
            :port => 1
        },
        :sata2 => {
            :dfile => disk_dir + 'sata2.vdi',
            :size => 2 * 1024, # Megabytes
            :port => 2
        },
        :sata3 => {
            :dfile => disk_dir + 'sata3.vdi',
            :size => 1024, # Megabytes
            :port => 3
        },
        :sata4 => {
            :dfile => disk_dir + 'sata4.vdi',
            :size => 1024,
            :port => 4
        }
    }
  },
}

Vagrant.configure("2") do |config|

    config.vm.box_version = "1804.2"
    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end
    MACHINES.each do |boxname, boxconfig|

        config.vm.synced_folder ".", "/vagrant", disabled: false
        config.vm.boot_timeout = 600
        config.vm.define boxname do |box|
  
            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s
            #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset
  
            box.vm.network "private_network", ip: boxconfig[:ip_addr]
  
            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "8192"]
                    vb.customize ["modifyvm", :id, "--cpus", "6"]
                    needsController = false
                boxconfig[:disks].each do |dname, dconf|
                    if not File.exist?dconf[:dfile] then
                        vb.customize ['createmedium', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                        needsController =  true
                    end
                end
                if needsController == true
                    vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                    boxconfig[:disks].each do |dname, dconf|
                        vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                    end
                end
            end
        box.vm.provision "shell", path: "./scripts/script1.sh"
        box.vm.provision :reload
        box.vm.provision "shell", path: "./scripts/script3.sh"
        box.vm.provision :reload
        box.vm.provision "shell", path: "./scripts/script5.sh"
        end
    end
end

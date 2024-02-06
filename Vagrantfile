# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"
disk_dir = "/share/Virtualbox VMs/"
disk_size = 512

MACHINES = {
  :zfs => {
        :box_name => "generic/debian12", #"centos/7",
        :box_version => "4.3.12", #"2004.01",
        :provision => "script1.sh",
    :disks => {
        :sata1 => {
            :dfile => disk_dir + 'sata1.vdi',
            :size => disk_size,
            :port => 1
        },
        :sata2 => {
            :dfile => disk_dir + 'sata2.vdi',
            :size => disk_size,
            :port => 2
        },
        :sata3 => {
            :dfile => disk_dir + 'sata3.vdi',
            :size => disk_size,
            :port => 3
        },
        :sata4 => {
            :dfile => disk_dir + 'sata4.vdi',
            :size => disk_size,
            :port => 4
        },
        :sata5 => {
            :dfile => disk_dir + 'sata5.vdi',
            :size => disk_size,
            :port => 5
        },
        :sata6 => {
            :dfile => disk_dir + 'sata6.vdi',
            :size => disk_size,
            :port => 6
        },
        :sata7 => {
            :dfile => disk_dir + 'sata7.vdi',
            :size => disk_size,
            :port => 7
        },
        :sata8 => {
            :dfile => disk_dir + 'sata8.vdi',
            :size => disk_size,
            :port => 8
        }
    }
  },
}

Vagrant.configure("2") do |config|

    #config.vm.box_version = "1804.2"
    if Vagrant.has_plugin?("vagrant-vbguest") then
        config.vbguest.auto_update = false
    end
    MACHINES.each do |boxname, boxconfig|

        config.vm.synced_folder ".", "/vagrant", disabled: false
        config.vm.box_version = boxconfig[:box_version]
        config.vm.define boxname do |box|
  
            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s
  
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
                    vb.customize ["storagectl", :id, "--name", "SAS", "--add", "sas" ]
                    boxconfig[:disks].each do |dname, dconf|
                        vb.customize ['storageattach', :id,  '--storagectl', 'SAS', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                    end
                end
            end
        box.vm.provision "shell", inline: <<-SHELL
            script -c "/vagrant/script1.sh" -O /vagrant/session.log
        SHELL
        end
    end
end

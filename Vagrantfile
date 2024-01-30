# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :otuslinux => {
        :box_name => "generic/debian12",
        :current_dir => File.dirname(File.expand_path(__FILE__)),
        :ip_addr => '192.168.56.101',
        :memory => "8192",
        :cpus => "6",
        #:disk_ext => '.vdi',
	:disks => {
		:sas1 => {
			:dfile => 'sas1.vdi',
                        :size => "133120",
			:port => 1
		},
		:sas2 => {
			:dfile => 'sas2.vdi',
                        :size => "133120",
			:port => 2
		},
                :sas3 => {
			:dfile => 'sas3.vdi',
                        :size => "133120",
			:port => 3
		},
                :sas4 => {
			:dfile => 'sas4.vdi',
                        :size => "133120",
			:port => 4
		},
                :sas5 => {
			:dfile => 'sas5.vdi',
                        :size => "133120",
			:port => 5
		},
                :sas6 => {
			:dfile => 'sas6.vdi',
                        :size => "133120",
			:port => 6
		}
	}
  },
}

Vagrant.configure("2") do |config|

        MACHINES.each do |boxname, boxconfig|

                config.vm.define boxname do |box|

                        box.vm.box = boxconfig[:box_name]
                        box.vm.host_name = boxname.to_s


                        #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

                        box.vm.network "private_network", ip: boxconfig[:ip_addr]
                        box.vm.synced_folder ".", "/vagrant", disabled: false
                        box.vm.provider :virtualbox do |vb|
                                vb.cpus = boxconfig[:cpus]
                                vb.memory = boxconfig[:memory]
                                #vb.customize ["modifyvm", :id, "--memory", boxconfig[:memory]]
                                #vb.customize ["modifyvm", :id, "--cpus", boxconfig[:cpus]]
                                needsController = false
                                boxconfig[:disks].each do |dname, dconf|
                                        #disk =  boxconfig[:current_dir] + "/" + dconf[:dfile]# + boxconfig[:disk_ext]
                                        unless File.exist?(dconf[:dfile])
                                                #puts "Fail"
                                                vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Standard', '--size', dconf[:size]]
                                                needsController = true
                                        end
                                end
                                if needsController == true
                                vb.customize ["storagectl", :id, "--name", "SAS", "--add", "sas" ]
                                end
                                boxconfig[:disks].each do |dname, dconf|
                                vb.customize ['storageattach', :id,  '--storagectl', 'SAS', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                                end
                        end
                        box.vm.provision "shell", path: "./script1.sh"
                        box.vm.provision :reload
                        box.vm.provision "shell", path: "./script2.sh"
                        box.vm.provision :reload
                        box.vm.provision "shell", inline: <<-SHELL
                                lsblk > /vagrant/file2.txt
                        SHELL
                end
        end
end

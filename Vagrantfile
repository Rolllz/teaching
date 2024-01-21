MACHINES = {
	:"kernel-update" => {
		:box_name => "generic/debian12",
		:box_version => "4.3.12",
		:cpus => 6,
		:memory => 8192,
	}
}

Vagrant.configure("2") do |config|
	MACHINES.each do |boxname, boxconfig|
		config.vm.synced_folder ".", "/vagrant"#, disabled: true
		#config.vm.synced_folder "/mnt/flash/sync", "/mnt/vagrant", disabled: false
		config.vm.define boxname do |box|
			box.vm.box = boxconfig[:box_name]
			box.vm.box_version = boxconfig[:box_version]#"> 4.3.10"
			box.vm.host_name = boxname.to_s
			box.vm.provider "virtualbox" do |v|
				v.memory = boxconfig[:memory]
				v.cpus = boxconfig[:cpus]
			end
		end
		config.vm.provision "shell", inline: <<-SHELL
			sudo apt-get update
			sudo apt-get install -y gcc cmake ncurses-dev libssl-dev bc flex libelf-dev bison git fakeroot build-essential xz-utils lsb-release software-properties-common apt-transport-https ca-certificates curl dwarves dkms
			#Если раздел /boot слишком маленький, можно удалить предыдущие образы ядра, иначе для нового не хватит свободного места
			#sudo rm /boot/initrd*
			#sudo rm /boot/vmlinuz*
			wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.7.tar.xz
			wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1MNt-MkbD-am9jkY8WXoT7JbL0XXxHAWc' -O ./VboxGuestAdditions.iso
			echo "Распаковка архива..."
			tar xf linux-6.7.tar.xz
			cd linux-6.7
			cp -v /boot/config-$(uname -r) .config
			echo "Сборка ядра..."
			yes "" | make oldconfig
			make -j$(($(nproc)+1)) -s
			sudo make modules_install -s
			echo "установка, создание образа ядра и обновление GRUB"
			sudo make install
			#sudo update-initramfs -c -k 6.7.0
			#sudo update-grub
			#sudo grep gnulinux /boot/grub/grub.cfg | grep "6.7.0' --class" | awk -F"'" '{print $4}' > ./version_of_kernel.txt
			#sudo export VE=$(cat ./version_of_kernel.txt)
			#sudo echo "DEFAULT_GRUB=$VE" >> /etc/default/grub
			echo "Перезагрузка..."
			sudo shutdown -r now
			sudo mkdir /mnt/iso
			sudo mount -o loop ./VboxGuestAdditions.iso /mnt/iso
			cd /mnt/iso
			sudo ./autorun.sh
			sudo mount -t vboxfs mnt_vagrant /vagrant
			sudo autoremove -y
			uname -r
		SHELL
	end
end

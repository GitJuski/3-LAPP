$minion = <<MINION
sudo apt-get update
sudo apt-get upgrade -qy
sudo apt-get install salt-minion -qy
echo "master: 192.168.69.104" > /etc/salt/minion
sudo systemctl restart salt-minion
MINION

$master = <<MASTER
sudo apt-get update # master
sudo apt-get upgrade -qy # master
sudo apt-get install salt-master -qy
sudo cp /vagrant/MasterSetup.py /home/vagrant/
sudo chown vagrant:vagrant /home/vagrant/MasterSetup.py
sudo chmod 755 /home/vagrant/MasterSetup.py
MASTER

Vagrant.configure("2") do |config|
        config.vm.box = "debian/bullseye64"

        config.vm.define "web" do |web|
                web.vm.synced_folder '.', '/vagrant', disabled: true
		web.vm.provision "shell", inline: $minion
                web.vm.hostname = "web"
                web.vm.network "private_network", ip: "192.168.69.101"
        end

        config.vm.define "app" do |app|
                app.vm.synced_folder '.', '/vagrant', disabled: true
		app.vm.provision "shell", inline: $minion
                app.vm.hostname = "app"
                app.vm.network "private_network", ip: "192.168.69.102"
        end

        config.vm.define "db" do |db|
                db.vm.synced_folder '.', '/vagrant', disabled: true
		db.vm.provision "shell", inline: $minion
                db.vm.hostname = "db"
                db.vm.network "private_network", ip: "192.168.69.103"

        end

        config.vm.define "master", primary: true do |master|
                master.vm.synced_folder ".", "/vagrant"
		master.vm.provision "shell", inline: $master
                master.vm.hostname = "master"
                master.vm.network "private_network", ip: "192.168.69.104"
                
        end # master

end
Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-buster64"
  config.vm.network "forwarded_port", guest: 80, host: 8088
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
end

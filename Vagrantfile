# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "windows_2008_r2"
  config.vm.box_url = "http://roecloudsrv001/vagrant/windows_2008_r2_vmware.box"
  config.vm.box_url = "http://roecloudsrv001/vagrant/windows_2008_r2_virtualbox.box"
  
  config.vm.network :forwarded_port, :host => 4001, :guest => 4001 
  config.vm.network :forwarded_port, :host => 7001, :guest => 7001 

  config.vm.provider "vmware_workstation" do |v|
    v.gui = true
    v.vmx["memsize"] = "1024"
    v.vmx["numvcpus"] = "1"
  end
  
  config.vm.provider "virtualbox" do |v|
    v.gui = true
    v.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1"]
    v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    v.customize ["modifyvm", :id, "--vram", "32"]
  end

  config.vm.provision "shell", path: "scripts/provision-etcd.bat"

end

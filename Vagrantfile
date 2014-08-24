# -*- mode: ruby -*-
# vi: set ft=ruby :

# Defaults for options
$num_instances = 1
$vb_gui = true 
$vb_memory = 2048 
$vb_cpus = 1 

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "windows_2008_r2"
  config.vm.box_url = "http://roecloudsrv001/vagrant/windows_2008_r2_vmware.box"
  config.vm.box_url = "http://roecloudsrv001/vagrant/windows_2008_r2_virtualbox.box"
  
  #config.vm.network :forwarded_port, :host => 4001, :guest => 4001 
  #config.vm.network :forwarded_port, :host => 7001, :guest => 7001 
  config.vm.network :forwarded_port, :host => 1433, :guest => 1433  # Micrpsoft SQL Server 2012 Express

  (1..$num_instances).each do |i| 
    config.vm.define vm_name = "etcd-node-%02d" % i do |config| 
      config.vm.hostname = vm_name 

      config.vm.provider "vmware_workstation" do |vb|
        vb.gui = $vb_gui
        vb.vmx["memsize"] = $vb_memory
        vb.vmx["numvcpus"] = $vb_cpus
      end
      
      config.vm.provider "virtualbox" do |vb|
        vb.gui = $vb_gui
        vb.customize ["modifyvm", :id, "--memory", $vb_memory, "--cpus", $vb_cpus]
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
        vb.customize ["modifyvm", :id, "--vram", "32"]
      end

      #ip = "172.17.8.#{i+100}" 
      #config.vm.network :private_network, ip: ip 
      #config.vm.network :public_network

      config.vm.provision "shell", path: "scripts/provision-etcd.bat"
      #config.vm.provision "shell", path: "scripts/provision-printservice.bat"

    end
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  net_ip = "192.168.50"
  project = "nodeelect"
  os = "bento/ubuntu-20.04"
  
  vm1_name="#{project}-server"
  serverip="#{net_ip}.100"

  config.vm.define "#{vm1_name}" do |server_config|
    server_config.vm.box = "#{os}"
    server_config.vm.hostname = "#{vm1_name}"
    server_config.vm.synced_folder "./server", "/server"

    server_config.vm.provider "virtualbox" do |vb|
        vb.linked_clone = true
        vb.memory = 2048
        vb.cpus = 1
        vb.name = "#{vm1_name}"
        vb.customize ["modifyvm", :id, "--groups", "/vagrant/#{project}"]
        #fix ubuntu network issue https://stackoverflow.com/questions/18457306/how-to-enable-internet-access-inside-vagrant
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]          
    end

    server_config.vm.network "private_network", ip: "#{serverip}"

    config.vm.provision :shell, :inline => "sudo server/provision.sh"

  end

  vm2_name="#{project}-edge"
  edgeip="#{net_ip}.200"

  config.vm.define "#{vm2_name}" do |edge_config|
    edge_config.vm.box = "#{os}"
    edge_config.vm.hostname = "#{vm2_name}"
    edge_config.vm.synced_folder "./server", "/server"

    edge_config.vm.provider "virtualbox" do |vb|
        vb.linked_clone = true
        vb.memory = 512
        vb.cpus = 1
        vb.name = "#{vm2_name}"
        vb.customize ["modifyvm", :id, "--groups", "/vagrant/#{project}"]
        #fix ubuntu network issue https://stackoverflow.com/questions/18457306/how-to-enable-internet-access-inside-vagrant
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]          
    end

    edge_config.vm.network "private_network", ip: "#{edgeip}"

    config.vm.provision :shell, :inline => "echo #{serverip} > serverip"
  end




end
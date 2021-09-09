# -*- mode: ruby -*-
# vi: set ft=ruby :

servers = {
  'packer' => { 'ip' => '10.10.10.10', 'memory' => '2048', 'cpus' => '1' }
}

Vagrant.configure("2") do |config|

    servers.each do |name, conf|
      config.vm.define "#{name}" do |cfg|
        cfg.vm.box = "centos-7-x86_64-minimal-2009"
        cfg.vm.box_version = "0"
        cfg.vm.box_check_update = true
        cfg.vm.hostname = "#{name}.meudominio.local"
        cfg.vm.network "private_network", ip: "#{conf['ip']}"
        cfg.vm.provision :hosts, :sync_hosts => true
  
        cfg.vbguest.auto_update = false
  
        cfg.vm.provider "virtualbox" do |vb|
          vb.name = "#{name}"
          vb.gui = false
          vb.cpus = "#{conf['cpus']}"
          vb.memory = "#{conf['memory']}"
          # --- Add second disk with 10GB. Define the variable named 'disk'. e.g. 'disk' => '/tmp/second_disk.vdi'
          #vb.customize ['createhd', '--filename', "#{conf['disk']}", '--size', 10 * 1024]
          #vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "#{conf['disk']}"]
        end
  
        cfg.vm.provision "shell", inline: <<-SHELL
          hostnamectl
        SHELL
      end
    end
end

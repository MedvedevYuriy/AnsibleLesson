Vagrant.configure("2") do |config|
	config.vm.define "syb" do |config|
		config.vm.provider :digital_ocean do |provider, override|
			override.ssh.private_key_path = '~/.ssh/id_rsa'
			override.vm.box = 'digital_ocean'
			override.vm.box_url = 'https://github.com//devopsgroup/vagrant-digitalocean/raw/master/box/digital_ocean.box'
			override.nfs.functional = false
			provider.token = ''
			provider.image = 'ubuntu-16-04-x64'
			provider.region = 'nyc1'
			provider.size = '512mb'
		end
		config.vm.synced_folder '.', '/vagrant', disabled: true

		config.vm.provision 'ansible' do |ansible|
			ansible.playbook = '01-base.yml'
                        ansible.playbook = '02-calcapp.yml'
		end
	end

end

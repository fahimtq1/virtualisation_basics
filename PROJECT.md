# Project 

## Project brief

The basic idea of this project is as follows:

- Create a multi-machine virtual environment with the virtualisation tools: Vagrant and VirtualBox
- The content of the multi-machine virtual environment will be detailed in the Vagrantfile
- Have a monolithic application (as provided by a "developer") on your localhost, ready to deploy using the virtual machines
- In the single environment, there will be two machines: an "app" VM (for the application layer) and the "db" VM (for the data layer)
- The "app" and "db" VMs will be configured with the correct dependencies and files 
- The "app" and "db" VMs will be connected with a mongoDB IP address
- The full application will then be ready for full deployment!

## Creating the Multi-Machine Environment

The Vagrantfile script below demonstrates how to create a multi-machine environment:

```ruby
Vagrant.configure("2") do |config|   # configure two environments
    config.vm.define "app" do |app|   # configuring the first environment for the application
        app.vm.box = "ubuntu/bionic64"   # outlining the operating system
        app.vm.network "private_network", ip: "192.168.10.100"   # establishing a private network between localhost and virtual environment with the specified ip address
        app.vm.synced_folder ".", "/home/vagrant/app"   # syncing all files in localhost, where Vagrantfile is saved, into specified location in virtual environment
        app.vm.provision "shell", path: "provision.sh"   # command to run the provision script
    end

    config.vm.define "db" do |db|   # configuring the second environment
        db.vm.box = "ubuntu/bionic64"
        db.vm.network "private_network", ip: "192.168.10.150"
    end
end
```

## The "app" VM

### The dependencies

Thanks to the Vagrantfile, the majority of the "app" VM is ready, it just needs the dependencies installed and the reverse proxy set up. The dependencies are as follows:

- Nginx (used for the reverse proxy)
- Nodejs (backend javascript tool)
- pm2 (process manager for Nodejs)

### Automation the configuration of "app" with a provisioning script:

```
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs 
sudo systemctl start nodejs
sudo systemctl enable nodejs
sudo npm install pm2 -g
sudo apt-get update -y
sudo apt-get upgrade -y
```

### Testing the dependencies from the localhost

The tests for these dependencies can be found on the localhost `environment` directory:

- Navigate to the tests file `spec-tests` on your Bash terminal 
- `gem install bundler` on localhost tests file location- dependency for testing the virtual environment
- `bundle` on localhost tests file location after installation
- `rake spec` to run the tests for the dependencies

### Setting the reverse proxy

Note- This step has been automated in provision.sh, but this section will detail the manual steps

1. `cd /etc`
2. `cd nginx`
3. `cd sites-available`
4. `sudo nano default`
5. After `location / {` input `proxy pass http://localhost:3000;`
6. `sudo systemctl restart nginx`

### Setting a persistent environment variable to connect with "db"

A persistent environment variable is necessary for communication between the "app" virtual machine and the "db" virtual machine. In this case, the vairable name and variable value is as follows: `DB_HOST=mongodb://192.168.10.150:27017/posts`.

1. `sudo nano ~/.bashrc`- bashrc is a file that is executed whenever an operating system runs
2. `export [VARIABLE_NAME]=[variable_value]`- in this case the variable is DB_HOST
3. `source ~/.bashrc`- to apply the changes made to the bashrc file

## The "db" VM

The only dependency in this VM is mongoDB, and it was automated using these commands in db_provision:

```
sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927   # connect to database with MongoDB
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list   # add mongodb repo
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20   # installing mongodb dependencies
sudo cp -f mongod.conf /etc/mongod.conf   # replacing default config file with config file that allows all ips
sudo systemctl restart mongod && sudo systemctl enable mongod   # restart and enable mongodb process
sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
```

## Bringing everything together

Checklist:

- Vagrantfile that configures two virtual machines, runs the provisioning scripts in each virtual machine and syncs the necessary folders 
- Each virtual machine has its own provisioning script: the "app" provisioning script automates the reverse proxy setup and the dependencies for the app and the "db" provisioning script automates the mongodb configuration
- Now the app should run with all three pages

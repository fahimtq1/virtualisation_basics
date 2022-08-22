sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
sudo service mongod stop
sudo apt-get purge mongodb-org*
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927
echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
sudo apt-get install -y mongodb-org=3.2.20 mongodb-org-server=3.2.20 mongodb-org-shell=3.2.20 mongodb-org-mongos=3.2.20 mongodb-org-tools=3.2.20
sudo service mongod start
sudo systemctl start mongod
sudo systemctl enable mongod
sudo cp -f db/mongod.conf /etc/mongod.conf
sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
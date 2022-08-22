sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
echo "DB_HOST=mongodb://192.168.10.150:27017/posts" | sudo tee -a /etc/environment
sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y
sudo apt-get install nginx -y   # starts after installation
sudo systemctl restart nginx
sudo systemctl enable nginx
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y
sudo systemctl restart nodejs
sudo systemctl enable nodejs
sudo apt-get install npm -y
sudo npm install pm2 -g
sudo cp -f app/default /etc/nginx/sites-available/default
sudo systemctl restart nginx
sudo systemctl enable nginx
cd app/app && npm install
sudo apt-get update -y   # best to update and upgrade vm at the start
sudo apt-get upgrade -y

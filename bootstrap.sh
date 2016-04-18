#!/usr/bin/env bash

projectDir="$1"
environment="$2"
port="$3"
host="$4"

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - \
&& sudo apt-get -y install build-essential nodejs nginx git

sudo rm -f /etc/nginx/sites-enabled/default \
&& sudo tee /etc/nginx/sites-available/catzilla_front > /dev/null <<EOF
server {
  listen ${port};
  root ${projectDir}/src;
  index index.html;
  server_name ${host};
  sendfile off;
  location / {
    try_files \$uri \$uri/ /index.html;
  }
}
EOF
sudo ln -sf /etc/nginx/sites-available/catzilla_front /etc/nginx/sites-enabled/catzilla_front \
&& sudo service nginx restart

cd "${projectDir}" \
&& npm install --verbose --no-bin-links \
&& npm run prod

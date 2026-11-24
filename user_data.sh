#!/bin/bash

dnf update -y
dnf install nginx -y

systemctl enable nginx
systemctl start nginx

INSTANCE_ID=$(ec2-metadata --instance-id | cut -d " " -f 2)

cat <<EOF > /usr/share/nginx/html/index.html
<html>
<body>
    <h1>Load Balanced Application</h1>
    <h2>Server: $INSTANCE_ID</h2>
</body>
</html>
EOF

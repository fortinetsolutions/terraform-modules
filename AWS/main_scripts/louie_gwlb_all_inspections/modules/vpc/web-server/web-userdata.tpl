#!/bin/bash
mkdir /var/www/html/${web_app}
cd /var/www/html/${web_app}
echo "<!DOCTYPE html>
<html>
<head>
<title>${web_app} test page</title>
</head>
<body>
<h2>${web_app}</h2>
<h2>Instance: ${web_name}</h2>
<h2>IP: ${web_ip}</h2>
<h2>AZ: ${web_az}</h2>
<h2>VPC: ${web_vpc}</h2></html>
</body>
</html>" > index.html
#!/bin/bash
# Script de configuration pour WordPress + HTTPS autosigné

# 1. Mises à jour du système
yum update -y

# 2. Installation d’Apache, PHP, MySQL client et le module SSL
yum install -y httpd php php-mysqlnd mod_ssl openssl

# 3. Lancement et activation d’Apache
systemctl enable httpd
systemctl start httpd

# 4. Téléchargement de WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

# 5. Création du fichier de config WordPress
cp wp-config-sample.php wp-config.php
# Variables d’environnement à passer si besoin (DB_NAME, DB_USER, DB_PASSWORD, etc.)
sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sed -i "s/username_here/${DB_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" wp-config.php

# Pour la base de données en RDS :
# sed -i "s/localhost/${DB_ENDPOINT}/" wp-config.php

# Droits sur /var/www/html
chown -R apache:apache /var/www/html

# 6. Génération d’un certificat SSL autosigné
# (365 jours de validité, clé RSA 2048 bits)
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/pki/tls/private/selfsigned.key \
  -out /etc/pki/tls/certs/selfsigned.crt \
  -subj "/C=FR/ST=Paris/L=Paris/O=MyCompany/OU=IT/CN=example.com"

# 7. Configuration Apache pour activer SSL sur le port 443
# On va écraser le fichier /etc/httpd/conf.d/ssl.conf
# afin de pointer sur nos certificats et le docroot.

cat << EOF > /etc/httpd/conf.d/ssl.conf
Listen 443 https

<VirtualHost _default_:443>
    DocumentRoot "/var/www/html"
    # ServerName pourra être n’importe quel nom, ici "example.com"
    ServerName example.com

    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/selfsigned.crt
    SSLCertificateKeyFile /etc/pki/tls/private/selfsigned.key

    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

# (Optionnel) Redirection automatique HTTP -> HTTPS
# Si vous le souhaitez, vous pouvez rajouter :
<VirtualHost _default_:80>
    DocumentRoot "/var/www/html"
    ServerName example.com
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/(.*) https://%{HTTP_HOST}/$1 [R=301,L]
</VirtualHost>
EOF

# 8. Redémarrer Apache pour prendre en compte la config SSL
systemctl restart httpd

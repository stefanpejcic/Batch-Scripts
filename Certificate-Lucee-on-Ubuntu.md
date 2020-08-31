#!/bin/bash -x

# Install Certbot
sudo add-apt-repository ppa:certbot/certbot

# Update
sudo apt-get update

# Install python-certbot-apache
sudo apt-get install python-certbot-apache

# Generate new certificate with certibot
# add aliases in the same command with -d <alias.domain>
sudo certbot --apache -d <your.domain.com>

# Install the certificate manually with preferred challenges as a vertification method
sudo certbot certonly --manual --preferred-challenges dns -d <your.domain.com>

# Rename the certificate to fullcert.pem
sudo cat /etc/letsencrypt/live/<your.domain.com>/*.pem > fullcert.pem

# Add fullchain into the fullcert.pem file
openssl pkcs12 -export -out fullchain.pkcs12 -in fullchain.pem

# CD the directory containing Java Keytool
cd /opt/lucee/jdk/jre/bin/

# Generate a new certificate with the keytool
keytool -genkeypair -alias <your.domain.com> -storetype jks -keystore <your.domain.com>.jks -validity 366 -keyalg RSA -keysize 4096

# Import keystore
keytool -v -importkeystore -srckeystore fullchain.pkcs12 -destkeystore sfdcsec.ks -deststoretype JKS

# 
keytool -certreq -alias <your.domain.com> -file <your.domain.com>.csr 
        -keystore <your.domain.com>.jks -ext san=dns:<your.domain.com> 
		
# Import LetsEncrypt Certificate into Java Keystore file
keytool -importcert -alias root -file /etc/letsencrypt/live/<your.domain.com>/cert.pem -keystore <your.domain.com>.jks -trustcacerts

# Test SSL Renewal
sudo certbot renew --dry-run

# Restart the machine
sudo reboot

#!/bin/bash

echo_info() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}
echo_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}

apt-get update; apt-get install curl socat git nload speedtest-cli -y



if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sh || echo_error "Docker installation failed."
else
  echo_info "Docker is already installed."
fi

rm -r Marzban-node

git clone https://github.com/Gozargah/Marzban-node

rm -r /var/lib/marzban-node

mkdir /var/lib/marzban-node

rm ~/Marzban-node/docker-compose.yml

cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host
    environment:
      SSL_CERT_FILE: "/var/lib/marzban-node/ssl_cert.pem"
      SSL_KEY_FILE: "/var/lib/marzban-node/ssl_key.pem"
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"
      SERVICE_PROTOCOL: "rest"
    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL
curl -sSL https://raw.githubusercontent.com/Tozuck/Node_monitoring/main/node_monitor.sh | bash
cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem

-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjUxMjE4MDgzMjQ1WhgPMjEyNTExMjQwODMyNDVaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2bm3cM5Ps6D4
CoJZoeDeoUjHXV6xSt5DnwNZfKhal1ecXr4/whS4OUpOwOw/rJ9HpR5184FF3vzK
ZFWxQN3v0MOai3aUTxqRvlHjTJ0uXUmrFFcQF8pqnThVgmy+9A3vFr7yjfB12EZ8
YaguOaSgRF4zqDjjB4ZrS9JQZ23kOYV044m6G1KqrsONDBw5NwpZvunK/wcPKelQ
GFG2146KVseCqzKeGvm3bHdFHnAgjauYoDC/LNVvijnDnuS9vELwcS+/hPte3UCk
V6tnJBuRHM0vWoslr2AUAYUen/dHJrv8Qhg7dxS7mor+/ggTpE/Vn7wnj94rP2zv
i/ixH1bnHKUhX/VTdrfgJ2yTZ10ynIVB5ESARdJveCReirusKNNIbG8f3ejar87T
h1vgnVApSlCr74vt/EvdWw3oO5KnUOD+U3kZLQ0Xx8GRTXlop9O7viVK+l45+BSe
tqLG9uMaR0dBRr2tkC+HBix1n5lXhxhzz+UrLW4gl4nEhpB5619MY/mwZZW8mgFN
8/dxPX6a/VmdTIYegbP4L8xI4Xz+U2CGk/EoaPnes8CTl8uk2lMAVTwt4pzB9f2v
4hLyvDKjXO/NYLSI8qqcz/TlYrk0Q1uspWbJVSv/aZR4gGDTP/qBce3W8ExjF2R9
75h8B4vk+K30CDiCYTuddxMpeqbSvlcCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
eYtVGwLTrp7UNQSiNbRBxsiGwJqWFOiGHiaEOp6Y0OFnp1rroivZQGDUwOUjeDCf
ODzLkqa4wu9qEGw8dmDs64gQTHMpYqNBphYN6oiHeO7hwlo+6lJ76u4jYSdO1ZQb
hLomOo49iNKYoWKX4lFM8elD62GutkWoL8PLqBhoiqxz/otLjikiBVKMCuPmunQx
4Km3sZ9qzVd6GJLbHkxc7u8n9d1DM0UiVUouponZU10eHJngsYTD4oVAB8O70p0q
SmGpo3p5bpr4hnJJGFZfipMHPPp38s/erfde9cymd4aRTvItv6+/Y4bmWqQT2UjH
LAHsRXB60m6/n7nvOh/0/1iJkZcZsQjcRdvTvqQUD8KqS3npvK8tdLcJzNoFcmG7
/9IfO9NlYI6+nF0iYJ27cIORHIzFGS3T5PYTk1ZErFG7amZEcXXsV+5tHXmx5pRG
jvrRy9ka+WrpwNf5x6qFxWpWVbw2vinsbmkFezsHg1XlUx31F9G6zpiNK3IU4n9g
T044s6tR8QrYrRPS0e0pM+ir0ESqzCiVwtZsQkciXMQ+z7+z4/3mxq0irNIUvsGk
wF6jzLV6/hMV61e/qtsyF8UxeGw5VAh7tpSLITHqUfODgk7/oTe1Qc6BhNivaZq3
wykjZQvSqEunidElFBMonAqm+7i3AesmUL6iWrO2Btk=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d

echo_info "Finalizing UFW setup..."

ufw allow 22
ufw allow 80
ufw allow 2096
ufw allow 8443
ufw allow 1370
ufw allow 8080
ufw allow 62050
ufw allow 62051

ufw --force enable
ufw reload
speedtest

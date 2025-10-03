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
IBcNMjUwODMxMTUyNTE3WhgPMjEyNTA4MDcxNTI1MTdaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsGVz4f/hsnwi
4qINV/bhO1HF2xlr89H2vtdtnDWd+2mSwaFX6JOQMo3XBhW82jHYZbomm+PRateU
xy65xvqWfZsqxh76tOiiX2wxgSwaIDdZNLAahIebcNyITQ13W6dRy3rxPi8PRL59
QFEkE0oFy77c4rhDP7dOW8NkaHgKhUhHAr+w+k2iWmJAKNSlsypBTn4O3d57nb7b
Yz1Ko4wcSvL7rZi3S2M3608zNtOdgzS2Sq1P8pYJCbZDe57sVw/oMrazlRa6m7Ut
orxtG7A2jUyyui3Q7ZQMBH+mlHZpgVr6oSOyobohEas7AUPm8HSt6wDJhLlypgsi
V6l3zsKDFI0FYnd7aN4kD55vKoYbq8QK9ti74OFvOG+6cwr5DLprJQBjXoar8KB7
PCQYi1ibgIeRO0q+dGUGC8k4OhcFtCeMUFg1cPuba9yIL3VaiCeL7yy99O++ahwC
a6YSEEXPYoRrRPENa6ioEys3yQ3D5vn49x6sfaef1KJ45sEs2V92XGLEq8IXFOto
QCPycAzSzb/MPiYrdF0AzbxbxBnfTrBIpFeDAvlcJMt/8QOU48kfiJqY1tw4O6cE
WK+yQEb/tCF3lK9xYseBhAVf6zprAkKfGQ7UcfO01TiwBlk+Q+qePqPqlFMdR852
tora2HDommAiewnyX8RxkvLwhTVKQDkCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
IMo38N8UYSFVZlpur6fEr3vLAImsiy+q8iIW9wRDFID34YDGpV87N6kgCbmCbfAR
Pxkxuv6SHOvL2LfbS/T5e0NgJ9DDGKejvPwSFE8J0EfiXGFvUNW4VoHvj0guRAIJ
TRidTUGDI1XsI7d41BxrTWfmK/+LXnS9eD+3Zxi8iirt+mnLRMwuqZJ/d76y6QwO
wr9aaLchMbjByacIjAs8h+XWXnOe4Uub6Nrb8ABZxvOmhem1aqh56pg3pFrpDG2d
aTDdBsgKHzb/dN/Mk2HVvf0ODf8CQRF9PRH2WxCjGZ96DDn350wzI8QwbVbjMVsE
EeqRhb2T5sz1DNH6NpWdbg06gYQDUR+LhmUWAqiJZPdEuIsaRSJiV2wddSxgGIT3
bvidkrigrQsZOy67JHkqyQGRQkJkdYhA+tZeeYWICOuLux6lB2L9V2wD3/3PmmKZ
6KUy2cY4X+Uv9t5eJVsUioeqiwKR9QqPEugZ0EJZ7/vnwwySKwaq1ymw2hweysHU
XPR9frNZkSnA39NaoVTeFTVkGZQF3EHRdxKpFRvArsr0qCE/Y74mr9mzskmd8Y8l
9HHFnjmhBevHnPwkOOPaOOVJroV0D407oK2oMTVag6YtJVaqnK144SWqIHB5CKiZ
ZqwpBTbaORr3/6q7Vg4nznQWYNxUauJU+b7cfGv1T5E=
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

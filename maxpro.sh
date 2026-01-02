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
IBcNMjYwMTAxMjM1MTU3WhgPMjEyNTEyMDgyMzUxNTdaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtasd2lLoA148
eIPmzs5Tzqjq5RGl/ZtJSVl9SJ3gnyfi/Ycna/EIVk91nWjpFwioqdBz8r3BwbS3
+CAFmHpHy0fmGf8YRo/xO2xAzPoJ/aorZODjzpypTbncPL2DUmqvM3fe/i0NOc/6
8LQ/yEfwVLU8XSaUFUsJZ3EoqT+1phS0TfRRo36sfbremsePJGHf7wIosYOYpHfm
uuW+/HoFhJxBN/iTE4ubW3KeGKirnXCc9s8Upg4af4YeWJH91oQEsXhrsV2ztLKS
hi+ccXpyJgrApGDmh9YMBFDPUrDK9/wb+6OBDDSlqPI5XlyHLp3Jkyk9qEFOn2nZ
nf26L2bDRlJj9dryx7QRq/4zGqkcQsm1FREZM1ev5F/XB3+ze9XCX7rxEyM6yAEW
C+UaG9MYcK81T8ZJWKyl+nJTl04ono4R6el3aqM0lI0crw0v4h6S88CI6y46Gv3X
o/awwQ5GkXKg1FOOdBlq4/pnbmWw1M5Zo5tMdWgP7oqPdiIuic0IPyd2LAEXzAYe
TWE1KqJjX6ijVRbbrUoTKQ7v+AFbEyOBoEm3UfIESgsujxddTeU/BvpzYyJQWh0q
e6R9xjtxXzmSNtzzWeNaCCP6774GoburgY776+rbxh6XNnrz9azOXw4OloBpGkwB
pIUPf257t9g10bZ4vQz698hf/v0kfUkCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
IdcQevKYF/MBIogdDSRrOW0BdSRRVQXjGicWtYICV5KTEVN0A3CbPyslfAH1HX4r
Zh9lirgHHV/EHtptf0NMr2vc5PjlgbSD6WkhXYLoiqe96mVzXqlHgLGgUu82BlH4
0744UGNtfR1iqLlLFkY5B2ZzG2SHWkZEj5AH4cXHxRKCnDzfaTgntCLZ0tXI7Odw
GdpQgvfWDNp9anp4mLX3y+IFeB+HiVw2N1tDKgySm0AyGjyG1KRGSEtq3WfxQYBa
dny1lyhsW/Nr9SwlfROsRXkGDHOkXZ1tmFWWJmu20B8HMkwdtBoKZnBTAR6aeLwv
SIGXzusRgbFCkeO6O5/AJ6Ig58RqCeD7oOZT7EysEvofZbOPiSCfSiUaiDBEYJXs
RlNzZK7nn4j9LJOG3MLNNFIjpt3YaDk+bstT+lQwaGMwCkXvuPQ+6nwCTbkS+Xyb
5ZgUfz1Aj+34m5q6XOcsaHSu15wBMhAir2F6Ffqz3qlfuZ4U1EELvmlHtmsT42Yc
TMduRD43o73UbPmLKkA5+hZcaUyKXQUjrXTYlDNiE7RUkddUCrWJi6gKceXNNVZ8
NnIG9bS2ft1p3s1baNDI9G0VL6lDV82XPJ3A8Zu4/iwRD716/txEUwmrhgjGU04I
joE6Jun50IxvWbkS51fnUbyTVXiT4h4cC3yFupC2uuU=
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

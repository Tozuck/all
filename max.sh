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
rm /var/lib/marzban-node/ssl_client_cert.pem

cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjUxMDE3MTkzOTA4WhgPMjEyNTA5MjMxOTM5MDhaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAryjiLfYQXY3q
bI0x0yMfwTtQkZr5DCTOhhs4pbzOdAB1c4rVBMgaoYGMZaLizDKV2frJsASQjyVh
o6M3wLFiUx0xc7I8PAhqFIwzkKTCEMxqi4kk4TwxyTCQakkLtIH1pwJYXNym/Zn3
xPd2Q/MFi1R5lgcBJnVNl4ZAbuPbY6r0iJh43m9UqP5ehg9qS1ZXSfbGoGpOSItP
ozyu/uE853bDdX5Z7blmQoBtEybCWPcF00nZI8l65GyU1v77EKT8CaHU0CPdz5R8
gfBDpSrf9Fmfwk53Wg0wiqOgrgpXzF4q+JEILIBg/zRXpDjTpmZxZWyR/0EoMUTj
4D6/cIb4pip1TZFE4SGzBsoQDhIL68zwzlV+cgd5pfUZCk/ivYcKRkfHZFxrjdIP
vuyHliXBZgTBxfLzLPBWC4NQdbps2hmiCiCZTqBjBXFXAaYI968htVMupXmVHbNs
OBg8/TZsf1IFz+RZ5V1C5f3LlpvsCQY2EZt9Bu71kuGvq9fPAaxR/SJxnxGYx+oG
TBwdX5QZ8cZ5Mq5RB9HQKatLDxPVWeW1EPo1eaAAJDaQpivSj0LrNslt4kyAXT1g
9T8+HEnLWMrIB7Ki6VnL7xc41P+iIyKdKpdGRxBZFNXmLYLD+4up/DGbgGEpzR6B
R1YRFcIx9HvfuDMi5ZP58RZ/Qau8ThUCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
QGv8vD7Kz7l+vQDBuGs0AME/lRFfc5xW78qS9C8PTPAKxICbrdODONoS9Damp4o/
tbBWM9vZpqkdJq0E9JjzgGUakjjT4gjN2Z3xwDYof6Eql7+IS6AMbsjrSKxSM9aK
7PXT+4weElMMZcy6D4rQPlShzR0dk2UjCTc13JFs1vODyoJSnJPl7VQRqUsXBMdC
1dOVehFsOpDuPHUtp4BRsNOppvmTCHvdckubRolS3W1ul9w1CIKD2DS0T+s4CMZH
O6gJS29m/SUH1GSiVNl60y5b6AAeBmLCmv1ExFcaarV9b1gS0DXZ1SvtBvPfxhPK
cdP7ItKqzcUVAiyCkIrDLVJRiCZsyGDM6wpNbI9vuzgQURbG4OtP+YGxbBSExqZW
6UXwhCRq3BwE92f5D49mjdmIAkAWarZ08yiEoJxAqsg/Gvk7IroyB77cyv7waJiC
bzRNgaBYebCJRnDcCvbH9OevMAUz/PCANx4dekrIrR1nwFhc89EdX6Mx9jg86h57
G0hvdJhMov8I6lPqNTKfX+2NzvNNKW/A5IjrrhipxCNVG5yB7glpPGIAXrEyyPYV
eq/lYGkCQmnhayMTqvekBNV9izu9rqsiDnqf3Ev+OnXWmE/zRF+9jffDsdRs+4VU
xh4sKnrbBIjewxAgp890zuSBkqN4gGyL1rEMpRkfDoo=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d

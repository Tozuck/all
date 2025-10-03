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
IBcNMjUwODIxMTkxNzQ1WhgPMjEyNTA3MjgxOTE3NDVaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA3/cAdxjeomWp
cZ6i2rH3bLZYNsnpXAZADxK9s1F3ha6NbIAaAWpkEzPGSCWYwO52kb18z0UVH11P
3UZckk54LHKBt/d8HvikLZlqqGfx9JhwVYmtC2GgVyGC2SMkW6d/bP59hN3fypbW
RxvvScs0YFz+WpQ7IUUo+H5vIGKy3bxGbNv95hPMbwxtK6sGdkLWAIpoBAAezXLt
dffFUtQJatGsGRmUueGH1tbsAIjDQJRFcDBQW9zgg65V1HDMVPdgxHlWfcuLPAOe
qgDZqaAp/ToidQrFsN6L6fnSpCdgKHH7+W2A1/T0Ve9ucfV/Eh+DBhm1Saqat4Hg
d52CODpcVW/BTXcIlZRvmLJmGalsCK9sAC4cAb0xTGUttDL38q9CpCwxjStYcVbg
yQLYKsWISU9GOncCZOFU+xZl+NUWjEpa6dbRCOOcL4ialwL5NsRjmhLaFT0wE39n
v44qtNoo4Wixm2Azkf4R30yN8sgLNggkQHoRKZAY+Fur1oLmFJpfBbfci7dIY8rr
KN4boqj742WxqJc8VQHiCt1c5CqrOJ8pE0mW5rzFK6d7f03JVzY8mABSec3K4ER4
a8OUo348G+nj5rKFsNVp/qs6BLMyS/sJXpZJE6T1orW5eDNdsyEy52d3XrxSL7dT
PxryLq7rCIuXCRY1yR/KYAuPyKgyvZkCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
YE6pod8b8RnolPYrwboNB1i6kFBiL/UJw0Mx9WxTfrVeMlO4ft+nHyc9/SdFVfgG
Rbm8xm6MO27VbrK5seSnMUcGwF1wSsFA9hoCpBcTVHbdhC3y1lrvM1bDxSQsoRca
M/7lLZ96fWwxv9G7ISlqu+IRgVTltXdNaOv6V5YxFhqKVN6jQ68kYFzR9Oje+rCN
DAbLZODNOmqw2Pyh5anEsQ3oCWgeqEVtzE1dbCVWfxhF1YE72V/YMr3+B+a8gvD7
wUTVNLYvfLDOJRlDCMHxt9rB6r0DST/YZ53rbA3J/QGXK7sVRwN9/ZYbjNgmLxN9
HcLkabwHQ/WG5NR/Xfx84vijur1Zwbis/IoqkceqOH2NPuTtTjI1sVinWh29DI5M
nUx1pXlrRuSdMkNbo0w8ldU+NgQ74QApxq491/wYegcOBBd9nUHbA70U9cT4CosQ
96XLvLMNVReBVMw6zP6VT+Xz0TP4JOo6ZEfGbRS8D2lC/TmjaVFXq4m9oUKl0n68
YpapkBX7rpzSQQ1hsiUfjOeeSlbhGnwcS7rMsaRxfl7W/P8+MQ3S0RbS8PyJ/ety
luommIPU6pqjjE5dMjp016QiUHe7ZiyYM1i/0mJqOyyyQL635ceKzNuRJlZDW3VP
8gad65M6K7lT3wMwFvi1dyUPyTGh0eBw41VDtlzl+l0=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d

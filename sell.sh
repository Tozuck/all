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
IBcNMjUwNjI3MTYzNjU1WhgPMjEyNTA2MDMxNjM2NTVaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvythDRY1b/Al
2DqZbZ/XB6+HOtRUas6dY+XsdVmUVxP6IJ6wKDAMH0J+XJRU/pEjRtvGX10yV7Iz
p7q04jZUd45uMe12MqzwFgCzGn5KBFcWI0yUhK28bl7lh25sJjp44MoxD9ga2/UC
7B5ToJgTn+g/imPsvp5GQgNig9YIU3HRCXznMICGjbIerFiAGy16jexb7gKT98IX
+ZaezX8dNyI9iCQLMbEejmheYrqYH+mT8ZKtUwtlj6imH9O+jcbAnXN7wJ7l3EIZ
9iv8iYMnKfWnl7t6rYQCoO+HbJTmaKpfoNkV2S8CT3crN8+bZns5BMohHY0mzHnK
aUv2edMtGfz5TP0jt8GvEKba5J/m3y7FYNIW+689/+0K2E7/iH8FyMkB2xe6etEO
MOjzjqMz2l3KuTIFld40n5UbAgVOopTiMPALVxQLR9LaNO1AJCBGa+0J2ws8WjZw
K7RuqRlp/0II9DCfGq7GlVCp0J8R5mTqJswhuWFY5QOeRV4xVvwHIqI+Rrfis8Vk
DKm+PjvK6HHwKlC2IDNHyAraXs3uEfWyF2gTYngWTa4FGsFucl7OWGhZSoMzuTxe
tggN0EfhjLI56S42k+XLGbz7mPqWa8AOzUXwY/31rIyUjzcIjFzhbH1J3qE7Wlmc
7re8R780w5LDkhNIDcHac0kOCRS84e8CAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
vNqvM5FZoWxVwtFVBJZA3GPnjVhDHrYkugUh9RD5CEZzV0GoSIKrhlSMNsaiJkEj
PmUwJqGz+oKfRII5Zb8UQjVTIcRCXjKz29PCH8i8kJrW8mAoNWFgZoZiwEMPUvRY
u5j9BHyhI97/kDxQ3yqMsvi4hIGAYHK300cQlO7rAPlUwu2sGy4yEPO2TV6nsdYM
RsHvePU5jfj5AdswBBuIm0GFwrPsL6R8aio7lzkCdDAopy81u1zkzWu0RYqrIWKa
ocq2wZ5JacNDk9+80P8i8mCRDISYUxS4fj4Lvzl1/+4I96Vkim5mfDnWD8bBHaWN
caGbYnrtW2nirlCVdpnA03Uz/02MBbTWWp6/GV2CrwxLgNiZcguEhFunFjP5JH5q
yzHqJktr9vvPSsBdZd3DCaMo7GlNcXVhScos7zgOk/udvpQg75U11TxR2EcGSiII
EimJiHpfofC+xUnsUNis9AMggUyP5Ro6pshEZutaecUVKRqzd5xBe/YJja2OkRqA
oRYGzb2YgQoe2PGiCQFRethl1AndCU+zkYlnCxTKjhZIJ3bN7khDLWp+qxyYxA9r
NuUbWQyp5lhKhnC+i/dvVjlGmnlrIpBJ2QWMQ6vkmj5+wwwbEd4s+PVUZtKrYm7F
rbHA+6WuAj/+dfnBocKTReSATQ2G1bUinyvXqxjeRVs=
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

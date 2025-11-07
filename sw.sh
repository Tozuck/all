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
IBcNMjUxMTA3MTkwMTUwWhgPMjEyNTEwMTQxOTAxNTBaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA68LmtbiPLZjP
ahu3sxvS5+FNTcZFwD4/w437gw5JM0p9NIHugbQw1LnBGtTJOPNjyTpykxxAmMsj
rNQ6V7LA+3pxWklMEjb2AoJaYRJ4EL4hNmwRbWtne68tFhQMGFiyrDAXBO0YO+7L
3bvlvmn17SJgx88DaK45dpKLltx/Pu2OPjaRFoOsw/O52uWIk4FmSl9Fj3vtYsWq
ZbKvEf6lySFjUBnnkJE5rsgsVCq+vXxekjvxPpqGHnTlzyf4/mGmTRKFLpRRN6hL
suq9OxG1+kiIlLYLpn8mEd990TOz1J/un1xWADIBg74wkhQ6TYi/M9xReIignW08
5WB2mSjIqgiJ1nf4XTWvYFod2VeIbIu4Bj/RKyIe9wQfoQRM70puScylw0qtc7Su
doSmk2EP2S1dJ6ZttTyx0fmPM+9a+sIilXn++jqCBY7gT3zCzk0JKPvqDpOU/iyj
dIyIiZEE5I52HDMZ3TGjmgAw2X/qfNfjl8dSWsz8k4lf0xUw5xS3Cp3XXeL4x8I7
HVCCNTAkE1Wuffm+eQ1YwUxo3m/FbNFYKr+pkCCiotMmd1ysV5VJ0PhnxBRZHTMn
VEqnHK0XjA/Xu3R8/s34Zb7H1fJCiwMcLsdw60cOMclgzRVkFhOBP/jIX8RzAF3R
8uyvs8mnwIV5q/a30JVdzlE5RLYAqaUCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
36G3o/2cpx/C00uR+ZLvctUyabF7LYRn9PALaXPfSmbMqx1y86jwXrw90Uosk1w1
ZZGf/KNM6Yb1y5ziFGuB81fY47xa/wiR5DW/40ZwdV0LZlIuhdDP1VXYQ9jkDOzC
Ogl51BHTEQzzoapGpnm5dvvL9u1TfhgmDBrcJ2VBNks5/uhjyuwmRy3ALoLU3NwJ
pOUn3HJkREz2zUK2eN6eY6iu8POVcry5tKMoDuslosXqKS/UCEjGXuMqFq7//1ln
+gO/qTvWKlekDRImV3tlpZkhMswPHUGBDiyUVy3HryvmU6QAm83oBPwfvtnBi6Wt
YpAI97OGPxdOgOfJO3i59GgOT9r8Azzs+fTtEaQ+yoczDSQhVr3Y4paQpSWeF2jh
y4lJLl28qH5INqjRdhXpUug8ubhjXwnxsMU6Fp1ooL0QGNAFZYl/8oFhlNhsS+Rk
mQyAN2s8uvigxjvdl1PqcRo+SnEf8wf7eWT0O2X4wrTg0ZJ6+p5kCc2EnCb6y4eH
zky49U2xFJ8zbmnjIWW86tJafOSb9itNZBbJdFtV00DKYjV+u611bVT4Q8j5SjS5
M5X2HwZs2VmMvPemX9E8tR2aNxhbS1000x9adfah/0/xl6vngwQv5F+rjMuaJQ+8
Mbmfc1SGUoafn3Zo7gU5M/fggfjH42u7qAJLpadGx10=
-----END CERTIFICATE-----

EOL

cd ~/Marzban-node
docker compose up -d

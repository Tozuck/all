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
IBcNMjUxMjE1MTczMjQxWhgPMjEyNTExMjExNzMyNDFaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAppO2Z+6vrJru
+vC3Yhj785v66MK+8tBUSlLtfE5nqQ759SpgfJ83abzu9Nmf3ROQpglhcpCEgmzd
Gwu4aMzkg7qQa/Q/QxbtZnRSJN/30F0PLg7PO9XwfsAPf48T7qxIL6Czrlx7mBW+
XWK9v0/Zy6TzypAZrxJ//0KuPXgaj9vAyKxLPhtZWT7JtlvkGwlSHMAYDXs4qqqC
60RbL3Zyg/VNtehKv3Atq7FiAw8yKvNRFGr6otUSn/eAIGIacdZ7AXsAFE3rxZfh
ZMrV4DjZLClV49UcQenjRJgCb0jiMRM4/H3eVpg/p2EWRsnAGmz7ae9zm2NJP1Lo
2KvLcPuk+dw2f5a9/LALsQW78mcwm9LbRmkrdEhRPpvfULfuuDhvAr3ENxXWxggr
qTf2v0c5ZOAYtVWSnnB3h7S44G9ks9uW22AsmASL/qneVckwn4PXBHXrUdfDgdri
FJVwt2hsZARXRwIp+Oftu8f63gpVNxzEItIanprByxUs8uvQiEWHwpSxcHFqz7Lh
v+nG4VC6a8ZCLy+0XbqKaDJIpoeAd+9E3Dq9V5tW7fnoKjZL0N7Y2P3m/8Dwgl6r
OT4uFxdo2wb9IYKGZKaO1vPJTAFixQfCfJ4+PqIOMuIzl0uZWO26+drn3OnfFgsE
H11IA3/HQd5GsKoIgOr3Z/5/uc3xru0CAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
bRhRjfDZ+9ucwXeyniMzpEeEhk3ki8NozuIESHVAqMLIuiEBYnQFnc5iYgSKk9fK
d2vmbP3NTMZhSdtE+2sqU/KwCMePQcrdIb6VZriHi8NH0FTiIQJvLj0XTSdzs7Jh
l7U0jSc1zpxaMe9HKD2d5MMln8kcKDqvxu73KKeQAT0/6fCkR7KTeLpIEv/bqOKc
kwY/uRoPv9OZt4qmP6VtxRVySo+ZwILnM7VGh0/IY9kVvgjIO65X1uIx3BMw+JJ+
u5rFB+HyAntw4QM6TGWvTqmGoVyeeTnjGnux5yHJ+btDkXH7Eihn1v9mnQ9Bi9Mx
ghro+oWxRUlOWccC250ROe1Vbv2aZ0mN7nG8h7m949W0WCIFhqhydoP/+7kzFJ6M
u8K2hv2o15tia/Kvwd7DwQ4gkeukdPz2jYFgy0W4dd+V0uxWTPRkUir+MBII1glp
6rmCanDJ5VghNqDVH3ce2NJZEQAwO7/nz0oBmZEVfOv/m/pzDs6N7AIbVwDEl1Um
kLdBO0C1g/WEbZFBnOHgeIzFJmrhD3c1o2y8077+VeWYLUuNzF2TsBrN8VQhZwRV
5gB/KpW4UxVKhxYse7Ah7TNIOaGHHPZGtoSchs5Xsl046Y5ANY+d6TEDqK3Dm3T+
p32yIk2oAvJnsa6i+YRsttnEc5S3b33tgrOmt8k4exc=
-----END CERTIFICATE-----

EOL

cd ~/Marzban-node
docker compose up -d

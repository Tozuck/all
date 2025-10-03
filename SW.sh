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
IBcNMjUwOTIyMTYwMjIzWhgPMjEyNTA4MjkxNjAyMjNaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA50QuyBr97sBR
KTmhp/F7Lxswd+sphNoVYK4bpzHxCTVhSoiFjGCYQB/70MrgrcJrOiWEGccx4GtZ
62kBAsPIJsj7TnifhHIBfOz0GSatJ1HZIN/2VzLUq4mPGSp+DyxpUKGEoT2AmDQV
ORN7gDTKbUq+R2fSYm/RDV2pkPvbjszkDHQJYXbmhLPAw4T26+U/0MUE1PlHMVTq
2st20OBKmayeX03S4w29maTD1CcuU+LX0jOeZXu7BWXlJrrTxKSb6itrNaoraCFk
gRB/9U/MZIz7BG4rf0XpQdCkNNE9sZ/6vxXWWdViIBEyUiWoYUFJbyLqSyyruhtd
yLyKzyqw181TwNAyARqDNHzjd2+1dXQ+muu4Ac3niVKX77rZIB+bHCMIeRYIDJxb
+bsjL9WQE28e+iger7MeXTYIxkm20jZuroItq/kPj134pxD4avVgNI3c+X58bjK/
KwBrjIK+doRpzUfHljbDapKN/gxbP/HIsJIJiD8pJ9ntZcP+j9y6FlsXi9Z3aSgY
6E8aXSBjmTRZzyQglG0bBi+UmHT+/VBEYcJdEvOFInqUGGBJB/+66wo0pXZkAmL9
7hDrhc8dSC1TVLJykfHyHDIy56lmdX05HhAPEyC8hW5HAg2s3HiDx3WdCxBZ469j
MVbJv/T2JFReGETskxatckk9JtWZQtUCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
jf62kU0RWHfdT7cuSi5EY8+7jPBHWNNv52K7IJL0wtq7uv2JQJRwyz0zPQf9xC1h
RlNNYm3BFFx62uYiaj8kOSwTNEXI+OhH3MwPt05m1Vl4uYVvjLUzJZiR3WP7sHwE
1aEMcjXQ6OPRmYWMM4JZ0EFL31yOlSaV0h+xvIHyGO0NMD0UQvUBbfOx/ruCzOb+
s/g8xwOO8WvcTAas+TLIGctN+kHKDIJb8Mpuv8BDqMNIuCrvEQdZHljBFOmleqN3
Vq991dBevOj5qUvMe9igcfgY0Z8S0DeHg3tIen8MH9S9yQpASchE1KBheoVigN1L
nX13RH9Gp2obmyIey0pX+MvEzQLhvxNtVpZ8X1zcmsclSEop9htYUAQGR0FwHVu/
VJvkA/lmtrUbpBFKatSEKCGLMHLLp7Oav5CQRKYFZAIBXjqrfNRKg4JpXtAsY30i
UnRPs3LdR8FlFU4zPcty/VPELO4FlsePq956ifvZ9Gix9fDdiP65p8qN3jWFCuPs
nW1dCRXloQdI1rpBkfs6XSne4oqMEA9KGJqoBJ5ebrRVgFKAiMLJt0OC70v1y0rU
XJXkAQtF58b+eWNDM5r+U9fFJxLxm0QdKZEN58QWWYdpZzXPTgIFowVHpuH0IXsa
UgRNHeriSj+hlWKfKrjeVmBmZR1K2fi4NG/+lZeZ7Oc=
-----END CERTIFICATE-----

EOL

cd ~/Marzban-node
docker compose up -d

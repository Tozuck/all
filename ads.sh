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
IBcNMjUxMTIwMTY0NTIwWhgPMjEyNTEwMjcxNjQ1MjBaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxgKz0xzABFAl
sJUjzWXLrdgmoqBr9EfIdv8CAaH25cKP813npI9SJObiCy4etC9PkD/BAotC5470
Oh0ErQq6cmjdvN78tSWeTmL+w2U2utQtnyLL5itQY70Ew6sx3UeyHCss49Zu6FP7
vzvRB6SSjcpoB4doGtTCAzdUq/7pQnJ+Uo6gY4CQ3lNTeZk7foDZxER4kHGOKdk3
eG7TAGSlNkael6LNbF3CYyLgENYyhFn9QFYGbxLlcdv2qfscV0EIGXH4ZYFZt/mk
X35EcxGFRGFLKLYvbbgK8sWkBF2MUnd6JO4ajhKdMh6LvI5VF9HzxPjCnmxQUrdK
+P7BxbIsvSnKwHHvfLeHz4AVacIOxXJ4p+hoX6t1GcPIjBMUeVNIoXQWXQXrIzfi
ZGRBMNTqvYlgbDwlu8tkZLhRmtVJpbJYgdbXMhLHLWRh5AEMKH3dPWRRfs9Szqbe
GGe6BisXbjxmsu3yS+VYBnc6xJdK3gh67svl1Nbt0sepljiINUM1dx7GzD7P3cs7
h5oxGUjsbtC+8NKp1WEoqJlobtNlRdGFJYQftBO0KcB0evIdhn9pIzkLm0aUQ8uZ
LS/x8OGOxxkRL9em3Ns9UwKE2x4mX+dEFM7vixO9FYGKlDWHjw3CVHfl0BK6wjBa
fPr2xnDK7OZCNQHGYIYv3/1DOM4WywcCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
hKP6E0ho45tpwI8p9vCAfQz2894sF3rrD8ShLNhHXGBO6UwddATGLkPGyoEP8Z6B
5L1hvtM7lE2r9VyZ3Zf++yUF+hsVLkRmI2kfI1J6g1rFWUCmzPzTLgjhM6MxRPBC
z2P+R80vl2z5wf5RmF+lIZTy5iW42V7EmMgRXWTGS1Qw+2Clxpxl0mZlh12uCWpW
hBwfsTpNJ1j2HYElBYqo+uXgULj1SRr0SzfGs2rcwwejrFEf5cQA96F/75jgjlf8
nGHJyUFLnzGfFmIHmNNn9Jyn1KbsCD5bLNVFt0JbNj+sgBKb0zEE+jGSZ1NpdKTp
YKqhQ8m28Vvm5DOOrSHa1OynuVKxiFjRjP4bAUhm0jnh7kBC16M/F4csG7/S5AnF
tsD6KF9mrHvhp/7lqx1zFd4aA1sI3B5kemEjBnpmEbuQuOvt7eM91csptY3BkLZI
hE1ZeamNfk4Iosg2uXLmsb7egs7mHZCpAycuAd35y5EQYa7YCAFihs+bY2WFr7Y9
AaoLzLgBc5O529SC/KBeWHe+F4KPf5a+2G6ToeZqkWIhda5xWNJvdomNOwwH0FJ/
Q+rjzBBLs0uCcX2PoLeOXHQ+6xXMj6553RZRC7RmUOdAH9F6ylIBARiluPWF/yoI
rhjqYBmlPj0dDD/dY8wFLpEYs5vQwHZ8y8CbZtOm7HY=
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
ufw allow 62050
ufw allow 62051

ufw --force disable
ufw reload
speedtest

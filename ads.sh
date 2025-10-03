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
IBcNMjUwNzI3MTkwMjUwWhgPMjEyNTA3MDMxOTAyNTBaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAs24tQsfYDr3R
JD/PBQbHTS5W5J/UFznep82wUqnmDf+mY00X7puk13nrgdCnqXYTksM3mUFIwuh/
nn2PqpkASR3TIvZxlhh1sQ0wrAmEGBdBBIsX0f0CiCU4rcc7u5oWO5T0asy2cOMW
5Mou9yY8aVXPfS28r2SAvqsdjM4bcqoyhe6Q/pCHKGn8v6seIeoJHEKFDIcmDod/
kvsKhybrl2CqjhIQueYTwdLsmws/J8hJXBrLAtoW81Hgix3mZRd4IcsJeHdK9RYI
cMXAr0cme7IhGIxpnbDohYnQW+NK5KIZ31JK1cVD2kjp6RAtGwI9m31f9fr9UtK/
RLitP2an6SfigTNJZBjMyNTWSWKIGAsw579JDbMhQlC1csgmndJ63dFOn38qjCqV
q1KP+xKr4t7EpRfG5geNNcD5/aK+c0nex0kgAR/DoldpkhtZIP9qXL91tLtR57AQ
d6M1JxuNMMLAz4mQN7eFEV0IN2Iai0snbiWUhCmht0hJtpwC1l2s7NUe5AhCM8B6
owdEMIxu2HU42PjIx+icMnV9Y+cUXpfYRUIjplBU78FVvVVzBtFDWwpGO3wr4B+X
BdiL3qTZfThl3WlGjZZMppJd+VL+0gxDDIIwNAgBnd77ci4iTQB6Uz8sZu29rC+z
wMJrgfcR0w0BFSQe4As9zXPoKs3eErUCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
hvEhVwk5BLgthpqWWKPG24+gFcOac/W6HFhWdPi/oVU24C4gGPWp/2y/R+HXJ+A/
HtWmwPsHN1dplOMSh/HDM+1VrJMZa1wz8sWEHUXycF0Tn041KcSHcz5SrhErMqIG
CHmZRoBSoH0PZZ2TMoasqJABlwatoQ4JXWx5zpRbyHZ8pWiOoznX2VdI6EHkmfu3
EWRW3wmdDIYuuXzln/thLMs+z2TvbbyX4yayh+G5oPPVTE9rlBTgf9gej4iIYvQh
3RV3EqGu5fQE66MeJTpeUyb0cOREbcaLfI34F6cstEU1rj1U/tNQx7e7H+K5e4pp
NwnCqyBDB9tw/nxNiUWpyFDIE5Cm5lYZlAqIWJGzMuqdCDJp5jSFAa+MyAgDONBH
F8xvMiGxSUpJIeULdA/3SL7HBlcWWBOn8p3ruke/DL8vMjqEtSCgSQsSxJa6f8PR
GuZ2u1KlRL0zYPByUdzt89RNBMom9M+B5A36fPs7NgEWGHsel1LK4V25n87cDeg5
D2kV01rjrPaXsT0nUKFoCrP8+l3OlSBZ7LXkOW5NBOF9aWduqVE7XUY2nEp3+ACr
AGvx6gOImSrsDkyS+y03ecaBEsUzgs3INXR4mYXyqT441PelJwahrOKuS7XtqGU1
KUx1vpB/F54WzXH9Z6GBuOILFVHbYP80hEmJGY5ma80=
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

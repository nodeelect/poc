make-cadir poc_ca
# todo prod: set all these information via environment variable
cp -f /server/cert.conf poc_ca/vars
chmod +x poc_ca/vars
./easyrsa init-pki
export EASYRSA_REQ_CN TENANTNAME
./easyrsa build-ca nopass

make-cadir poc_ca
# todo prod: set all these information via environment variable
cp -f /server/cert.conf poc_ca/vars
chmod +x poc_ca/vars
cd poc_ca
easyrsa init-pki
mv openssl-easyrsa.cnf pki/
easyrsa gen-dh
export EASYRSA_REQ_CN=TENANTNAME
easyrsa build-ca nopass
#return ca-crt (public)
#return ca.key (as part of the sign package)
make-cadir poc_ca
cp -f /server/cert.conf poc_ca/vars
chmod +x poc_ca/vars
./easyrsa init-pki
./easyrsa build-ca nopass

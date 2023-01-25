DOMAIN=$1

openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout $DOMAIN.key -out $DOMAIN.crt -config <(cat <<- TEXT
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
countryName             = KR
stateOrProvinceName     = Seoul
localityName            = Seonyudo
organizationName        = SPACESOFT
organizationalUnitName  = Dev Team
CN = $DOMAIN
[v3_req]
keyUsage = critical, digitalSignature, keyAgreement
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
TEXT
) -sha256


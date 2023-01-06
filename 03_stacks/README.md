To generate a hashed password for traefik:

`export HASHED_PASSWORD=$(openssl passwd -apr1 hallo | sed -e s/\\$/\\$\\$/g)`

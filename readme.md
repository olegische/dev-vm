# Description
My dev machine configs

# Notes
Password sha-512 hash generation
```bash
python3 -c 'import crypt; print(crypt.crypt("password", crypt.mksalt(crypt.METHOD_SHA512)))'
```

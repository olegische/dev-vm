# Description
My dev machine configs

# Notes
Password sha-512 hash generation
```bash
python3 -c 'import crypt; print(crypt.crypt("password", crypt.mksalt(crypt.METHOD_SHA512)))'
```

Mounting vm disk
```bash
sudo mount UUID="935f992f-b135-468a-9669-a622bb343244" /mnt/vm
```

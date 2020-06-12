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

Install dev-vm
```bash
chmod +x ./bootstrap/virt.sh
sudo ./bootstrap/virt.sh
```

Connect to dev-vm and install docker
```bash
sudo apt update && \
sudo apt install -yq=2 \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common && \
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
sudo apt-key fingerprint 0EBFCD88 && \
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable" && \
sudo apt update && \
sudo apt install -yq=2 \
  docker-ce \
  docker-ce-cli \
  containerd.io && \
sudo docker run hello-world
```

# Caliban TU Graz Desktop

## Binary Cache

Also see [Binary Cache](https://nixos.wiki/wiki/Binary_Cache).

### Setup

```bash
cd /etc
sudo nix-store --generate-binary-cache-key caliban.netbird.cloud cache-priv-key.pem cache-pub-key.pem
sudo chmod 600 cache-priv-key.pem
cat cache-pub-key.pem

# You need to do this after the nix-serve user is created by the nix-serve service
sudo chown nix-serve cache-priv-key.pem
```

# docker-vpn-proxy
Docker IPSec VPN Proxy

## How to

### Build

```bash
docker build -t cloudmatic/vpnproxy:0.1 .
```

### Run

```bash
docker run --privileged -d -p 8213:23128 -p 20022:20022 --name vpnproxy cloudmatic/vpnproxy:0.1
```

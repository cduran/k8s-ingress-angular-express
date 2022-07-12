<h1 align="center">
  Demo app
</h1>
<h5 align="center">
  Technologies used:
</h5>
<h6 align="center">
   Angular 13, Node 14 (express), nginx. Deployed to a Kubernetes cluster with NGINX Ingress Controller installed.
</h6>

📖 Prerequistes:
- Docker installed (to build the images)
- Kubernetes cluster with NGINX Ingress Controller installed
- The domain name to use, must be pointing to the Kubernetes cluster or modified your hosts file with the domain and ip of the Kubernetes cluster

## ⚡️  Quick start
Update the `env-global` file with your data
```bash

```

Then just run make:
```bash
make
```

To delete everything built with this example:
```bash
make cleanup
```

More information found in the `Makefile` file.

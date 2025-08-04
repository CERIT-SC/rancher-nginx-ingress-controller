# Custom NGINX Ingress Controller

This project is a customized build of the official [NGINX Ingress Controller](https://github.com/kubernetes/ingress-nginx), packaged in a Dockerfile, with key enhancements to improve stability under high traffic conditions.

## ⚙️ Summary of Changes

The default behavior of the original NGINX Ingress Controller is to forward error responses (404/500/503) to a default backend service. Under high traffic, this results in a large number of downstream TCP connections, which:

- Are required to remain in the `TIME_WAIT` state for at least 60 seconds (as per [RFC 793](https://datatracker.ietf.org/doc/html/rfc793)),
- Can overwhelm the host by exhausting the available ephemeral TCP ports.

### 🔧 Custom Modification

This version introduces a patch in `nginx.tmpl` to serve error pages (404, 500, 503) directly from local static files within the NGINX container instead of routing them to the default backend. This change helps to:

- **Reduce TCP connection overhead**
- **Improve resilience under high traffic**
- **Prevent port exhaustion**

👉 Custom error backends (if explicitly configured) are **still supported** and will override the local fallback behavior.

## 🐳 Docker

A custom `Dockerfile` is included to build the controller with the modified `nginx.tmpl`.

### Build

```bash
docker build -t cerit.io/rancher/nginx-ingress-controller:v1.12.4-hardened2 .
```

### Run

Use this image with your Kubernetes manifests or Helm values to deploy it as a drop-in replacement for the default controller.

## 📁 File Structure

- `Dockerfile` – Builds the custom NGINX Ingress Controller image.
- `nginx.tmpl` – Modified template to handle error responses locally.
- `custom-errors` -- Error pages content.

## 📌 Notes

- This change is primarily beneficial for high-load environments.
- Behavior remains consistent with the default controller in normal conditions.
- Be sure to test in staging before production deployment.

## 🛠 Contribution & Issues

Feel free to open issues or submit PRs if you have improvements or run into problems.

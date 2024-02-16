
To set up the project, follow these steps:

1. Start Minikube with volume mounting:
   ```bash
   minikube start --mount --mount-string="$HOME/vol:/src"
   ```

2. Run bootstrap:
   ```bash
   make bootstrap
   ```

To verify the setup, run the following commands:

- Check ArgoCD at [192.168.49.2:31607](http://192.168.49.2:31607)
- Access Prometheus at [192.168.49.2:30001](http://192.168.49.2:30001)
- Log in to Grafana at [192.168.49.2:30002/login](http://192.168.49.2:30002/login)

For access credentials, use the following:

- Argo CD:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

- Grafana:
  ```bash
  kubectl -n grafana get secret grafana -o jsonpath="{.data.admin-password}" | base64 -d
  ```

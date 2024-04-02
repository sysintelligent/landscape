Follow these steps to set up the project:

1. Start Minikube with volume mounting:
   ```bash
   minikube start --mount --mount-string="$HOME/vol:/src"
   ```

2. Run bootstrap:
   ```bash
   make bootstrap
   curl $(minikube ip):30000
   ```

To verify the setup, execute the following commands:

- ArgoCD: Visit [192.168.49.2:31607](http://192.168.49.2:31607)
- Prometheus: Access [192.168.49.2:30001](http://192.168.49.2:30001)
- Grafana: Log in at [192.168.49.2:30002/login](http://192.168.49.2:30002/login)

Use the following credentials for access:

- Argo CD:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

- Grafana:
  ```bash
  kubectl -n grafana get secret grafana -o jsonpath="{.data.admin-password}" | base64 -d
  ```
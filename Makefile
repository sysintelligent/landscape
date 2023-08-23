deploy-local:
    kubectl apply -f system/ingress-controller.yaml
    kubectl apply -f system/grafana.yaml
    kubectl apply -f system/loki.yaml
    kubectl apply -f system/prometheus.yaml

clean-local:
    kubectl delete -f system/prometheus.yaml
    kubectl delete -f system/loki.yaml
    kubectl delete -f system/grafana.yaml
    kubectl delete -f system/ingress-controller.yaml

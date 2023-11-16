#!/bin/sh

VALUES="values.yaml"

kubectl get ingress argocd-server --namespace argocd \
    || VALUES="values-seed.yaml"

helm template \
    --dependency-update \
    --include-crds \
    --namespace argocd \
    --values "${VALUES}" \
    argocd . \
    | kubectl apply -n argocd -f -

# If you want to install argocd with the latest version using the manifests
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd wait --timeout=60s --for condition=Established \
       crd/applications.argoproj.io \
       crd/applicationsets.argoproj.io
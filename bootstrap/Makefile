.POSIX:

default: namespace argocd

namespace:
	kubectl create namespace argocd --dry-run=client --output=yaml \
		| kubectl apply -f -

.PHONY: argocd
argocd:
	# cd argocd && ./apply.sh
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

.PHONY: root
root:
	cd root && ./apply.sh
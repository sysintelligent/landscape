.POSIX:

default: namespace argocd

namespace:
	kubectl create namespace argocd --dry-run=client --output=yaml \
		| kubectl apply -f -

.PHONY: argocd
argocd:
	cd argocd && ./apply.sh

.PHONY: root
root:
	cd root && ./apply.sh
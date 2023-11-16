.POSIX:

default: argocd

.PHONY: argocd
argocd:
	kubectl create namespace argocd --dry-run=client --output=yaml \
		| kubectl apply -f -
	cd argocd && ./apply.sh

.PHONY: root
root:
	cd root && ./apply.sh
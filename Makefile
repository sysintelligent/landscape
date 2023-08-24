# Makefile for Kubernetes Deployment

.PHONY: add-session-token get-session-token test-existing-profile

# Define variables
EXISTING_PROFILE_NAME = mfa
MFA_SERIAL_NUMBER = arn:aws:iam::199644197629:mfa/dmi
DURATION_SECONDS = 129600

add-session-token:
	# Prompt for the MFA token code
	read -p "Enter MFA token code: " TOKEN_CODE; \
	echo "Adding session token to AWS CLI profile..."; \
	aws sts get-session-token \
		--serial-number $(MFA_SERIAL_NUMBER) \
		--duration-seconds $(DURATION_SECONDS) \
		--token-code $$TOKEN_CODE | \
		awk '/AccessKeyId|SecretAccessKey|SessionToken/ { print }' > session_token.txt; \
	aws configure --profile $(PROFILE_NAME) \
		set aws_access_key_id $$(grep 'AccessKeyId' session_token.txt | cut -d'"' -f4); \
	aws configure --profile $(PROFILE_NAME) \
		set aws_secret_access_key $$(grep 'SecretAccessKey' session_token.txt | cut -d'"' -f4); \
	aws configure --profile $(PROFILE_NAME) \
		set aws_session_token $$(grep 'SessionToken' session_token.txt | cut -d'"' -f4); \
	rm session_token.txt; \
	echo "Session token added to profile $(PROFILE_NAME)."

get-session-token:
	# Prompt for the MFA token code
	read -p "Enter MFA token code: " TOKEN_CODE; \
	echo "Updating existing AWS CLI profile..."; \
	aws sts get-session-token \
		--serial-number $(MFA_SERIAL_NUMBER) \
		--duration-seconds $(DURATION_SECONDS) \
		--token-code $$TOKEN_CODE | \
		grep 'AccessKeyId\|SecretAccessKey\|SessionToken' > session_token.txt; \
	AWS_ACCESS_KEY_ID=$$(grep 'AccessKeyId' session_token.txt | awk '{print $$2}'); \
	AWS_SECRET_ACCESS_KEY=$$(grep 'SecretAccessKey' session_token.txt | awk '{print $$2}'); \
	AWS_SESSION_TOKEN=$$(grep 'SessionToken' session_token.txt | awk '{print $$2}'); \
	aws configure --profile $(EXISTING_PROFILE_NAME) \
		set aws_access_key_id $$AWS_ACCESS_KEY_ID; \
	aws configure --profile $(EXISTING_PROFILE_NAME) \
		set aws_secret_access_key $$AWS_SECRET_ACCESS_KEY; \
	aws configure --profile $(EXISTING_PROFILE_NAME) \
		set aws_session_token $$AWS_SESSION_TOKEN; \
	rm session_token.txt; \
	echo "Existing profile $(EXISTING_PROFILE_NAME) updated."

test-existing-profile:
	# Test the updated existing profile
	aws sts get-caller-identity --profile $(EXISTING_PROFILE_NAME)

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

deploy-aws-cluster:
	eksctl create cluster -f platform/aws-cluster.yaml --profile mfa

delete-aws-cluster:
	eksctl delete cluster -f platform/aws-cluster.yaml --profile mfa
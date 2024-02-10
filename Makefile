token := $$(yc iam create-token)

.PHONY: create destroy

create:
	YC_TOKEN=$(token) terraform apply -target yandex_kubernetes_cluster.k8s -auto-approve
	YC_TOKEN=$(token) terraform apply -target yandex_kubernetes_node_group.k8s-nodes -auto-approve
	YC_TOKEN=$(token) yc managed-kubernetes cluster get-credentials default --external --force

destroy:
	YC_TOKEN=$(token) terraform destroy -target yandex_kubernetes_node_group.k8s-nodes -auto-approve
	YC_TOKEN=$(token) terraform destroy -target yandex_kubernetes_cluster.k8s -auto-approve

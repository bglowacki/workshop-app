# Workshop Plan
#NorthPass

- ~~infrastructure overview~~
---
## SSO
- ustawimy credentiale
- skonfigurujemy sobie kubectl za pomocą eksctla
	- `kubectl config get-contexts`
	- `kubectl config current-context`
	- `eksctl get cluster -p northpass-dev`
	- `eksctl utils write-kubeconfig -n workshop -p northpass-dev  --set-kubeconfig-context`
	- `kubectl config current-context`
	- `kubectl config get-contexts`
- zmiana kontekstów w kubectl
	- `kubectl config get-contexts`
	- `kubectl config use-context`
	- `kubectl config current-context`
---
## Cluster Work
1. Namespace
	- `kubectl apply -f manifests/01_namespace.yaml`
2. sprawdzić czy namespace się utworzył
	- `kubectl get namespaces`
	- `kubectl get namespaces bartek`
	- `kubectl describe namespaces bartek`
	- można używać skrótów `ns` dla namespaces
3. Utworzyć pod z redisem 
	- `kubectl apply -f manifests/02_redis-pod.yaml`
	- `kubectl get pods -n bartek`
	- `kubectl logs -n bartek redis`
	- `kubectl exec -it -n bartek redis — bash`

4. Postgres Deployment
	- `kubectl apply -f manifests/03_postgresql-deployment.yaml`
	- `kubectl port-forward -n bartek postgresql-aw1edascx 5433:5432`
	- `psql -h 127.0.0.1 -p 5433 -U myuser -W workshop`
5. Postgres Service
	- `kubectl apply -f manifests/04_postgresql-service.yaml`
	- `kubectl get svc -n bartek`
	- `kubectl describe svc -n bartek postgresql`
	- `kubectl get endpoints -n bartek`
	- dodać więcej replik żeby sprawdzić czy jest więcej enepointów do postgresa
	- zmienić repliki na 1
6. Setup bazy Jobem
	- `kubectl apply -f manifests/05_db-create.yaml`
7. Migracja bazy jobem
	- `kubectl apply -f manifests/06_db-migration.yaml`
8.  API railsowe deployment
	- `kubectl apply  -f manifests/07_api-deployment.yaml`
	- `kubectl get pods -n bartek`
	- `kubectl logs -n bartek api-dascz-123`
	- `kubectl exec -it -n bartek api-da3easc -- rails c`
	- zeskalujemy api na więcej replik
9.  Wspólne configi
	- `kubectl apply -f manifests/07a_api-configmap.yaml`
	- zmienić żeby envy brać z configmapy
	- `kubectl rollout history -n bartek deploy api`
	- `kubectl apply -f manifests/07_api-deployment.yaml`
	- `kubectl describe deploy -n bartek api`
	- `kubectl rollout history -n bartek deploy api`
	- `kubectl rollout undo -n bartek deploy api`
10. hasło do bazki do secretsa
	- `kubectl create secret -n bartek generic db-secret --from-literal=password=mypassword`
	- `kubectl get secret -n bartek`
	- `kubectl get secret -n bartek db-secret -o yaml`
	- `echo bXlwYXNzd29yZA== | base64 -D`
	- `kubectl delete -f manifests/07_api-deployment.yaml`
	- `kubectl apply -f manifests/07_api-deployment.yaml`
	- `kubectl logs -n bartek api-dascz-123`
11. Odpytanie API
	- ` kubectl port-forward -n bartek api-6969d6c48f-5rs65 3000:3000`
	- `curl localhost:3000`
	- ustawić enva `NAME`
12. Serwis API z zewnętrznym loadbalancerem 
	- 	`kubectl apply -f 08_api-service.yaml`
	- `kubectl get svc -n bartek`
	- `curl a9e4939c6f4c511e992ff0af85063012-627040138.us-east-1.elb.amazonaws.com:3000`
	- uzupełnić enva `ELB_HOST`
	- `kubectl apply -f manifests/07_api-deployment.yaml`
13. Dodać ENVa `NAME`
	- ustawić env `NAME` z namespace’a
14. czyszczenie
	- `kubectl delete -f manifests`
15. Ponowny setup
	- `kubectl apply -f manifests`

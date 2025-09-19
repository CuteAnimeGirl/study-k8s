# init-pods.sh
#!/bin/bash

# Ждем создания подов
sleep 30

# Создаем индивидуальные страницы для каждого пода app1
for pod in $(kubectl get pods -l app=app1 -o name); do
  kubectl exec -it $pod -- sh -c 'echo "Hello from App1 - Pod: $HOSTNAME" > /usr/share/nginx/html/index.html'
done

# Создаем индивидуальные страницы для каждого пода app2
for pod in $(kubectl get pods -l app=app2 -o name); do
  kubectl exec -it $pod -- sh -c 'echo "Hello from App2 - Pod: $HOSTNAME" > /usr/share/nginx/html/index.html'
done
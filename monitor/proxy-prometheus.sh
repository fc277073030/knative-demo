kubectl port-forward -n knative-monitoring \
$(kubectl get pods -n knative-monitoring \
--selector=app=prometheus --output=jsonpath="{.items[0].metadata.name}") \
9090

# url
echo visit: http://localhost:3000
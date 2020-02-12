#!/usr/bin/env bash

echo jaeger: http://localhost:8001/api/v1/namespaces/istio-system/services/jaeger-query:16686/proxy/search/
echo zipkin: http://localhost:8001/api/v1/namespaces/istio-system/services/zipkin:9411/proxy/zipkin/
#!/bin/bash
# run-kube-bench.sh
# Runs CIS Kubernetes Benchmark using kube-bench
# Usage: ./scripts/run-kube-bench.sh [master|node|etcd|policies]

set -euo pipefail

COMPONENT=${1:-"master"}
REPORT_DIR="./reports/kube-bench"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🔍 Running kube-bench for: $COMPONENT"
mkdir -p "$REPORT_DIR"

# Run kube-bench as a Job in the cluster
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: kube-bench-$COMPONENT-$TIMESTAMP
  namespace: default
spec:
  template:
    spec:
      hostPID: true
      nodeSelector:
        node-role.kubernetes.io/$COMPONENT: ""
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          effect: NoSchedule
      containers:
        - name: kube-bench
          image: aquasec/kube-bench:latest
          command: ["kube-bench", "run", "--targets", "$COMPONENT", "--json"]
          volumeMounts:
            - name: var-lib-etcd
              mountPath: /var/lib/etcd
              readOnly: true
            - name: etc-kubernetes
              mountPath: /etc/kubernetes
              readOnly: true
      restartPolicy: Never
      volumes:
        - name: var-lib-etcd
          hostPath:
            path: /var/lib/etcd
        - name: etc-kubernetes
          hostPath:
            path: /etc/kubernetes
EOF

echo "⏳ Waiting for kube-bench job to complete..."
kubectl wait --for=condition=complete job/kube-bench-$COMPONENT-$TIMESTAMP --timeout=120s

# Save report
kubectl logs job/kube-bench-$COMPONENT-$TIMESTAMP > "$REPORT_DIR/report_${COMPONENT}_${TIMESTAMP}.json"
echo "✅ Report saved: $REPORT_DIR/report_${COMPONENT}_${TIMESTAMP}.json"

# Print summary
echo ""
echo "📊 Summary:"
cat "$REPORT_DIR/report_${COMPONENT}_${TIMESTAMP}.json" | jq '.[] | {total_pass: .total_pass, total_fail: .total_fail, total_warn: .total_warn}'

# Cleanup
kubectl delete job kube-bench-$COMPONENT-$TIMESTAMP
# 🔐 Kubernetes Security Hardening (CKS-Grade)

> A comprehensive, production-ready Kubernetes security hardening toolkit based on CKS exam objectives, CIS Benchmarks, and real-world security best practices.

## 🎯 What This Repo Covers

| Domain | Tools / Techniques |
|--------|-------------------|
| **Cluster Hardening** | RBAC, ServiceAccount restrictions, API server flags |
| **Workload Security** | Pod Security Standards, SecurityContext, Non-root containers |
| **Supply Chain Security** | Trivy image scanning, Cosign image signing, OPA Gatekeeper policies |
| **Runtime Security** | Falco rules, Audit logging, Seccomp/AppArmor profiles |
| **Network Security** | NetworkPolicy, Istio mTLS, Egress controls |
| **Secrets Management** | HashiCorp Vault, Sealed Secrets, External Secrets Operator |

## 📁 Structure

```
k8s-security-hardening/
├── rbac/                    # Roles, ClusterRoles, RoleBindings
├── pod-security/            # PodSecurityStandards, SecurityContext
├── network-policies/        # Deny-all + allow-rules patterns
├── opa-gatekeeper/          # Constraint templates + constraints
├── falco/                   # Custom Falco rules
├── trivy/                   # Image scanning CI integration
├── vault/                   # Vault PKI + secret injection
├── audit/                   # K8s audit policy
└── scripts/                 # kube-bench, kube-audit automation
```

## 🚀 Quick Start

```bash
# Run CIS benchmark against your cluster
./scripts/run-kube-bench.sh

# Apply all hardening policies
kubectl apply -k .

# Scan all running images with Trivy
./scripts/scan-all-images.sh
```

## 📊 CIS Benchmark Coverage

| Section | Status |
|---------|--------|
| Control Plane Configuration | ✅ Covered |
| etcd | ✅ Covered |
| Control Plane Policies | ✅ Covered |
| Worker Nodes | ✅ Covered |
| Kubernetes Policies | ✅ Covered |

## 🔗 References
- [CKS Exam Curriculum](https://github.com/cncf/curriculum)
- [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)
- [NSA Kubernetes Hardening Guide](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF)
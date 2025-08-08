import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.io.k8s.api.rbac.v1 as rbacv1
import file

version = file.read_env("UP_CHART_VERSION")
_items = [
    metav1alpha1.E2ETest{
        metadata.name: "addon-argocd-core"
        spec= {
            crossplane.autoUpgrade.channel: "Rapid"
            defaultConditions: ["Installed", "Healthy"]
            initResources: [
                rbacv1.ClusterRoleBinding{
                    metadata.name: "upbound-controller-manager-cluster-admin"
                    roleRef: {
                        apiGroup: "rbac.authorization.k8s.io"
                        kind: "ClusterRole"
                        name: "cluster-admin"
                    }
                    subjects: [
                        {
                            kind: "ServiceAccount"
                            name: "upbound-controller-manager"
                            namespace: "crossplane-system"
                        }
                    ]
                }
            ]
            manifests: [
                {
                    apiVersion: "pkg.upbound.io/v1beta1"
                    kind: "AddOn"
                    metadata: {
                        name: "pkg-addon-argocd-core"
                    }
                    spec: {
                        package: "xpkg.upbound.io/upbound/addon-argocd-core:"+ version
                    }
                }
            ]
            extraResources: []
            skipDelete: False
            timeoutSeconds: 4500
        }
    }
]
items= _items

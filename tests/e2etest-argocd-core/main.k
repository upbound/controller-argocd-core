import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import file

version = file.read_env("UP_CHART_VERSION")
_items = [
    metav1alpha1.E2ETest{
        metadata.name: "addon-argocd-core"
        spec= {
            crossplane.autoUpgrade.channel: "Rapid"
            defaultConditions: ["Installed", "Healthy"]
            manifests: [
                {
                    apiVersion: "pkg.upbound.io/v1beta1"
                    kind: "Addon"
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

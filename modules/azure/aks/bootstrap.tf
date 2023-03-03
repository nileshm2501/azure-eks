resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster_node_pool.workerpool]
  filename   = "kubeconfig"
  content    = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}

resource "null_resource" "copy_kubeconfig" {
  provisioner "local-exec" {
    command = "cp ./kubeconfig ~/.kube/config"
  }
  depends_on = [
    local_file.kubeconfig
  ]
}

resource "helm_release" "ingress-nginx" {
  depends_on = [local_file.kubeconfig]

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  timeout          = 1000
  create_namespace = "true"

  set {
    name  = "controller.replicaCount"
    value = 2
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.nodeSelector.nodepool-type"
    value = "system"
  }
}


resource "helm_release" "cert-manager" {
  depends_on       = [local_file.kubeconfig]
  count            = var.install_cert_manager ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  timeout          = 1000
  create_namespace = "true"

  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "clusterResourceNamespace"
    value = "cert-manager"
  }
}


# Create the "services" namespace
resource "kubernetes_namespace" "services" {
  depends_on = [local_file.kubeconfig]
  metadata {
    name = "services"
  }
}

# Create the "monitoring" namespace
resource "kubernetes_namespace" "monitoring" {
  depends_on = [local_file.kubeconfig]
  metadata {
    name = "monitoring"
  }
}



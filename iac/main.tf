terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
    }
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s-iniciativa" {
    name = var.k8s_name #nome na digitalocean
    region = var.k8s_regiao
    version = "1.22.8-do.1"

    node_pool {
      name = "default"
      size = "s-2vcpu-2gb" #config da maquina virtual
      node_count = 3
    }
}

resource "digitalocean_kubernetes_node_pool" "node_premium" {
  cluster_id = digitalocean_kubernetes_cluster.k8s-iniciativa.id
  name = "premium"
  size = "s-4vcpu-8gb"
  node_count = 2
}

variable "do_token" {}      #
variable "k8s_name" {}      # Definir em terraform.tfvars
variable "k8s_regiao" {}    #

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s-iniciativa.endpoint
}

resource "local_file" "kube_config" {
    content = digitalocean_kubernetes_cluster.k8s-iniciativa.kube_config.0.raw_config
    filename = "kube_config.yaml"
}


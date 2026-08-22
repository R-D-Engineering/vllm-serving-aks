terraform {
  required_version = "~> 1.15"

  # Using local backend (store state in local `terraform.tfstate`).
  # Previously this used Terraform Cloud; to use Terraform Cloud again, add
  # a `cloud { organization = "..." }` block here or configure a remote backend.

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
  }
}

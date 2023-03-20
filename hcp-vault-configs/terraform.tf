terraform {
  cloud {
    organization = "my-demo-account"
    workspaces {
      name = "hcp-vault-configs-demo"
    }
  }
  required_providers {
    vault = {
        source = "hashicorp/vault"
        version = "~> 3.14.0"
    }
  }
}
terraform {
  required_version = "~>1.16.0"

  cloud {
    
    organization = "Adeolus_Private_Lab"

    workspaces {
      name = "terraform-tutorial"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
  }
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }

  cloud {
    organization = "SujaysTerraformLab"
    workspaces {
      name = "terraform-pawfect"
    }
  }
}

provider "random" {}

# Generate a random pet name with a unique suffix
resource "random_pet" "unique_identifier" {
  length    = 2 # Generates a name with 2 words
  separator = var.separator
  prefix    = var.prefix
  keepers = {
    # This ensures a new pet name on each apply
    timestamp = timestamp()
  }
}

variable "prefix" {
  description = "The prefix to use for the pet name"
  type        = string
  default     = "pet"

}

variable "separator" {
  description = "The separator to use between words in the pet name"
  type        = string
  default     = "-"

}

# Generate an additional random pet as a backup identifier
resource "random_pet" "backup_identifier" {
  length    = 3
  separator = "_"
}

output "primary_identifier" {
  value       = random_pet.unique_identifier.id
  description = "A unique identifier generated using a random pet name"
}

output "backup_identifier" {
  value       = random_pet.backup_identifier.id
  description = "An alternative unique identifier using a random pet name"
}

output "combined_identifier" {
  value       = "${random_pet.unique_identifier.id}-${random_pet.backup_identifier.id}"
  description = "A combined unique identifier using two random pet names"
}

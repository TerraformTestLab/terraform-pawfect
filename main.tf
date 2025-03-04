terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }

  backend "s3" {
    bucket = "terraformtestlabatlas"
    key = "terraform.tfstate"
    region = "us-west-1"
  }
}

provider "random" {}

# Generate a random pet name with a unique suffix
resource "random_pet" "unique_identifier" {
  length    = 2  # Generates a name with 2 words
  separator = "-"
  keepers = {
    # This ensures a new pet name on each apply
    timestamp = timestamp()
  }
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
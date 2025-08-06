# Terraform AWS State Bootstrap Module

This Terraform module creates the necessary infrastructure for bootstrapping remote state storage in AWS, including an S3 bucket for state storage and optionally a DynamoDB table for state locking.

## Features

- **S3 Bucket**: Secure state storage with encryption and versioning
- **KMS Encryption**: Customer-managed KMS key for state encryption
- **Optional DynamoDB Locking**: Configurable state locking via `use_lockfile` flag
- **Latest AWS Provider**: Uses AWS Provider v6.0+

## Variables

| Variable       | Type   | Default | Required | Description |
|----------------|--------|---------|----------|-------------|
| `env`          | string | -       | Yes      | Environment name (e.g., `dev`, `prod`) |
| `region`       | string | -       | Yes      | AWS region (e.g., `eu-west-2`, `us-east-1`) |
| `org`          | string | -       | Yes      | Organization name |
| `app`          | string | -       | Yes      | Application name |
| `use_lockfile` | bool   | `true`  | No       | If true, DynamoDB table is not created. If false, DynamoDB table is created for state locking |

## Usage

```hcl
module "tfstate_bootstrap" {
  source = "git::https://github.com/your-org/terraform-tf-state-bootstrap.git"
  
  env          = "dev"
  region       = "eu-west-2"
  org          = "myorg"
  app          = "myapp"
  use_lockfile = false  # Set to false to create DynamoDB table for state locking
}
```

## Outputs

| Output                | Description |
|----------------------|-------------|
| `s3_bucket_name`     | Name of the S3 bucket for state storage |
| `dynamodb_table_name`| Name of the DynamoDB table for state locking (null if use_lockfile is true) |
| `kms_key_arn`        | ARN of the KMS key used for encryption |

## Examples

### Basic Usage (No State Locking)

```hcl
module "tfstate_bootstrap" {
  source = "./terraform-tf-state-bootstrap"
  
  env    = "dev"
  region = "eu-west-2"
  org    = "acme"
  app    = "webapp"
  # use_lockfile defaults to true (no DynamoDB table)
}
```

### With State Locking

```hcl
module "tfstate_bootstrap" {
  source = "./terraform-tf-state-bootstrap"
  
  env          = "prod"
  region       = "us-east-1"
  org          = "acme"
  app          = "webapp"
  use_lockfile = false  # Creates DynamoDB table for state locking
}
```

## Resource Naming Convention

Resources are named using the pattern: `{org}-{app}-{env}-{region}-{resource-type}`

Example:
- S3 Bucket: `acme-webapp-dev-eu-west-2-tf-state`
- DynamoDB Table: `acme-webapp-dev-eu-west-2-tf-state-lock`
- KMS Key: `acme-webapp-dev-eu-west-2-tf-state-key`

## Prerequisites

- Terraform >= 1.0
- AWS Provider >= 6.0
- Appropriate AWS credentials configured
- Required AWS permissions for S3, DynamoDB, and KMS resources

## Backend Configuration

After running this module, you can configure your Terraform backend to use the created resources:

```hcl
terraform {
  backend "s3" {
    bucket         = "acme-webapp-dev-eu-west-2-tf-state"
    key            = "path/to/your/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-2:123456789012:key/12345678-1234-1234-1234-123456789012"
    dynamodb_table = "acme-webapp-dev-eu-west-2-tf-state-lock"  # Only if use_lockfile = false
  }
}
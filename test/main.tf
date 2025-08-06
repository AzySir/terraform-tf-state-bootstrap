module "tfstate" {
  source = "../"
  
  env          = var.env
  region       = var.region
  org          = var.org
  app          = var.app
  use_lockfile = var.use_lockfile
}
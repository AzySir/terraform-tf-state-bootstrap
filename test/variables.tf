variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "org" {
  type = string
}

variable "app" {
  type = string
}

variable "use_lockfile" {
  type        = bool
  default     = true
  description = "If true, DynamoDB table is not created. If false, DynamoDB table is created for state locking."
}
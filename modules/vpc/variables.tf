variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to create subnets in."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 1
    error_message = "az_count must be at least 1."
  }
}

variable "cluster_name" {
  description = "Name of the cluster; used to name resources and tags."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources (merged with module tags)."
  type        = map(string)
  default     = {}
}


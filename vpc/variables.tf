variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

# variable "vpc_name" {
#   description = "Name of the VPC"
#   type        = string
# }

# variable "cluster_name" {
#   description = "Name of the EKS cluster"
#   type        = string
# }
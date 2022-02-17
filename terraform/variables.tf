variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "test"
}

variable "region" {
  description = "The region the environment is going to be installed into"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr_block" {
  description = "CIDR range of VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
  #default   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
  #default   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "image_name" {
  description = "The name and version of the image"
  type        = string
}

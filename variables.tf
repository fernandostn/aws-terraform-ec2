# Used in the Terrafile.tf

variable "owner_project" {
  description = "Owner of this project"
  type        = string
  default     = "Fernando Santana"
}

variable "managed_by_project" {
  description = "How this project is managed or created"
  type        = string
  default     = "IAC Terraform"
}

variable "region_project" {
  description = "Region used in this project"
  type        = string
  default     = "us-west-2"
}


# Used in the Terrafile.tf to populate the Network module

variable "vpc_cidr_project" {
  description = "VPC CIDR used in this project"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count_project" {
  description = "Quantity of Availability Zones used in this project"
  type        = number
  default     = 2
}


# Used in the Terrafile.tf to populate the EC2 module

variable "instance_type_project" {
  description = "Instance type used in this project"
  type        = string
  default     = "t3.micro"
}
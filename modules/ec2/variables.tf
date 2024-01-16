variable "subnet" {
  description = "Subnet created in the network module (Input on the Terrafile of the project)"
}

variable "sg" {
  description = "Security Group created in the network module (Input on the Terrafile of the project)"
}

variable "instance_type" {
  description = "Instance type of the EC2 instance (Input on the Terrafile of the project)"
}

# variable "db_add" {
#   description = "DB address of the database (Input on the Terrafile of the project)"
# }
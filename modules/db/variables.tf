variable "subnet0" {
  description = "Subnet created in the network module (Input in the Terrafile of the project)"
}

variable "subnet1" {
  description = "Subnet created in the network module (Input in the Terrafile of the project)"
}

variable "sg" {
  description = "Security Group created in the network module (Input in the Terrafile of the project)"
}

variable "az_count" {
  description = "Quantity of Availability Zones used to multi-az purposes (Input in the Terrafile of the project)"
}

variable "master_username" {
  description = "Master username of the database"
  default     = "awsuser"
}
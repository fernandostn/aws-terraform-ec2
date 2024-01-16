variable "instance_type" {
  description = "Instance type of the EC2 instance (Input in the Terrafile of the project)"
}

variable "subnet" {
  description = "Subnet created in the network module (Input in the Terrafile of the project)"
}

variable "sg" {
  description = "Security Group created in the network module (Input in the Terrafile of the project)"
}
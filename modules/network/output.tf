output "subnet_public_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public[*].id
}

output "subnet_private_db_id" {
  description = "ID of the private db subnet"
  value       = aws_subnet.private_db[*].id
}

output "sg_public_id" {
  description = "ID of the Public security group"
  value       = aws_security_group.public_sg.id
}

output "sg_private_db_id" {
  description = "ID of the db security group"
  value       = aws_security_group.private_db_sg.id
}
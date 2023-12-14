output "subnet_public_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public[*].id
}

output "subnet_private_web_id" {
  description = "ID of the private web subnet"
  value       = aws_subnet.private_web[*].id
}

output "subnet_private_db_id" {
  description = "ID of the private db subnet"
  value       = aws_subnet.private_db[*].id
}

output "sg_private_web_id" {
  description = "ID of the web security group"
  value       = aws_security_group.private_web_sg.id
}

output "sg_private_db_id" {
  description = "ID of the db security group"
  value       = aws_security_group.private_db_sg.id
}
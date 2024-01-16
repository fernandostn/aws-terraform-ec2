output "ec2_public_dns" {
  description = "Public DNS of the EC2 Instance"
  value       = aws_instance.ec2.public_dns
}
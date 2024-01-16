output "ec2_public_dns" {
  description = "Public DNS of the EC2 Instance"
  value       = module.ec2.ec2_public_dns
}
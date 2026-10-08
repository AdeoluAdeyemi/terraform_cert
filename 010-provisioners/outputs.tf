output "instance_public_ips" {
  description = "The public IP addresses of the created EC2 instances."
  value  = [for instance in aws_instance.ec2-server: instance.public_ip]
}
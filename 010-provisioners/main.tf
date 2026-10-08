provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  environment = "dev"
  regions     = ["us-east-1", "us-west-2", "eu-west-1"]
  #instance_types_list = tolist(var.AWS_INSTANCE_TYPE)
  instance_types = [var.AWS_INSTANCE_TYPE[4], var.AWS_INSTANCE_TYPE[5]]
  instance_names = ["web-server", "monitoring-server"]
}

resource "aws_key_pair" "ssh_key_deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/mac_aws.pub")
}

resource "aws_instance" "ec2-server" {
  ami   = data.aws_ami.latest_amazon_linux.id
  count = length(local.instance_names)

  key_name = aws_key_pair.ssh_key_deployer.key_name
  instance_type = local.instance_types[count.index]

  tags = {
    Name        = local.instance_names[count.index]
    Environment = local.environment
  }

  provisioner "local-exec" {
    command = <<-EOT
            cat > "instance_info_server_${count.index}.txt" <<EOF
            Private IP: ${self.private_ip}
            Public IP: ${self.public_ip}
            Instance Type: ${self.instance_type}
            Instance ID: ${self.id}
            Instance Name: ${self.tags["Name"]}
            Environment: ${self.tags["Environment"]}
            EOF
    EOT
  }

  provisioner "file" {
    content     = "This is a test file for ${self.tags["Name"]} in ${local.environment} environment."
    destination = "/tmp/test_file_${count.index}.txt"

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("~/.ssh/mac_aws")
        host        = self.public_ip
    } 
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from ${self.tags["Name"]} in ${local.environment} environment!' > /tmp/hello_${count.index}.txt",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>Hello from ${self.tags["Name"]} in ${local.environment} environment!</h1>' | sudo tee /var/www/html/index.html",
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("~/.ssh/mac_aws")
        host        = self.public_ip
    } 
  }

}
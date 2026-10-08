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

resource "aws_instance" "ec2-server" {
  ami   = data.aws_ami.latest_amazon_linux.id
  count = length(local.instance_names)

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
}
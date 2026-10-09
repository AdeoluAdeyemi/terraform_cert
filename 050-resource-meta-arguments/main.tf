locals {
    environment = "dev"
    regions     = ["us-east-1", "us-west-2", "eu-west-1"]
    instance_types = ["t3.small", "t3.micro"]
    instance_names = ["web-server", "monitoring-server"]
}

data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_instance" "count_example" {
    count         = 2
    ami           = data.aws_ami.latest_amazon_linux.id
    instance_type = local.instance_types[count.index]

    tags = {
        Name = "Server ${count.index + 1}"
    }
}
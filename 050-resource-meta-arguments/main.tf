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
    for_each = {
        small = "t3.small"
        micro = "t3.micro"
    }

    ami           = data.aws_ami.latest_amazon_linux.id
    instance_type = each.value

    tags = {
        Name = "Server ${each.key}"
    }
}

output "instance_ip" {
    # value = {
    #     for instance in aws_instance.count_example : instance.tags["Name"] => instance.public_ip
    # }


    value = values(aws_instance.count_example)[*].public_ip
}
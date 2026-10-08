
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "tf-instance-1" {
    ami           = "ami-0d53cc9bd365ad65b" #data.aws_ami.ubuntu.id
    instance_type = "t3.micro"

    provisioner "local-exec" {
        command = "echo ${self.public_ip} > ${path.module}/instance_ip.txt"
    }
}
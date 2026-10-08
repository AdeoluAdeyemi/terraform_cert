locals {
  env = "dev"
}

resource "local_file" "test" {
  content  = "Hello, World!"
  filename = "${path.module}/hello-${local.env}.txt"
}
variable "AWS_DEFAULT_REGION" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "AWS_INSTANCE_TYPE" {
  description = "The AWS instance type to create."
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t2.medium", "t2.large", "t3.micro", "t3.small", "t3.medium", "t3.large"]
  validation {
    condition = length(var.AWS_INSTANCE_TYPE) > 0 && alltrue([
      for instance_type in var.AWS_INSTANCE_TYPE : startswith(instance_type, "t2.") || startswith(instance_type, "t3.")
    ])
    error_message = "Every AWS_INSTANCE_TYPE value must be a t2 or t3 instance type."
  }
}

# variable AWS_SECRET_ACCESS_KEY {
#   description = "The AWS secret access key."
#   type        = string

#   validation {
#     condition = length(var.AWS_SECRET_ACCESS_KEY) > 0
#     error_message = "The AWS secret access key must not be empty."
#   }
# }
# variable AWS_ACCESS_KEY_ID {
#   description = "The AWS access key ID."
#   type        = string
  
#   validation {
#     condition = length(var.AWS_ACCESS_KEY_ID) > 0
#     error_message = "The AWS access key ID must not be empty."
#   }
# }
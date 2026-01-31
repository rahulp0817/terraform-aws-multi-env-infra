variable "bucket_name" {
  description = "This is bucket"
  type = string
}

variable "instance_count" {
  description = "This is the number of instance count"
  type = number
}

variable "instance_type" {
  description = "This is the instance type"
  type = string
}

variable "ec2_default_root_storage_size" {
  default = 10
  type    = number
}

variable "ec2_ami_id" {
  default = "ami-0b6c6ebed2801a5cb" # ubuntu
  type    = string
}

variable "hash_key" {
  description = "This is the hash key for DynamoDB table"
  type = string
}

variable "env" {
  description = "This is my workspace environment"
  type = string
}
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.env}-${var.bucket_name}"
  tags = {
    Name = "remote_bucket"
    Environment = var.env
  }
}
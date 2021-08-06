provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
  region = var.region
}
resource "aws_db_instance" "lavagna" {
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "lavagna"
 allocated_storage     = 50
  max_allocated_storage = 100
  # Set the secrets from variables
  username             = var.username
  password             = var.password
}
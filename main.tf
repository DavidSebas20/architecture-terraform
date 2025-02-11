# Configuración del proveedor AWS
provider "aws" {
  region                   = "us-east-1" # Cambia a tu región preferida
  access_key               = var.aws_access_key_id
  secret_key               = var.aws_secret_access_key
  token                    = var.aws_session_token
}

# Crear un par de claves SSH
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
# Crear un grupo de seguridad único para cada instancia
resource "aws_security_group" "instance_sg" {
  count = 4

  name_prefix = "instance-${count.index + 1}"
  vpc_id      = "vpc-07d9bd0b898725449" # Tu VPC específica

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permite acceso SSH desde cualquier IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permite todo el tráfico saliente
  }
}

# Crear 4 instancias EC2
resource "aws_instance" "ec2_instance" {
  count = 4

  ami           = "ami-04b4f1a9cf54c11d0" # AMI de Ubuntu
  instance_type = "t2.micro"

  key_name = aws_key_pair.key_pair.key_name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.instance_sg[count.index].id]

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}
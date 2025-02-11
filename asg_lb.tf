# Obtener las instancias EC2 ya creadas
data "aws_instances" "existing_instances" {
  count = 4

  filter {
    name   = "tag:Name"
    values = ["Instance-${count.index + 1}"]
  }

  depends_on = [aws_instance.ec2_instance] # Asegura que las instancias estén creadas
}

# Crear Launch Templates para los Auto Scaling Groups
resource "aws_launch_template" "instance_template" {
  count = 4

  name_prefix   = "instance-template-${count.index + 1}"
  image_id      = "ami-04b4f1a9cf54c11d0" # AMI de Ubuntu
  instance_type = "t2.micro"

  key_name = "my-key-pair"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance_sg[count.index].id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Crear Auto Scaling Groups
resource "aws_autoscaling_group" "asg" {
  count = 4

  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  launch_template {
    id      = aws_launch_template.instance_template[count.index].id
    version = "$Latest"
  }

  # Especificar subredes en diferentes zonas de disponibilidad
  vpc_zone_identifier = [
    "subnet-041cbc7f89b590956", # Reemplaza con la ID de tu primera subred
    "subnet-03a0b49bf24b5e7f9"  # Reemplaza con la ID de tu segunda subred
  ]

  tag {
    key                 = "Name"
    value               = "Instance-${count.index + 1}"
    propagate_at_launch = true
  }
}

# Crear Load Balancers
resource "aws_lb" "load_balancer" {
  count = 4

  name               = "lb-instance-${count.index + 1}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instance_sg[count.index].id]

  # Especificar subredes en diferentes zonas de disponibilidad
  subnets = [
    "subnet-041cbc7f89b590956", # Reemplaza con la ID de tu primera subred
    "subnet-03a0b49bf24b5e7f9"   # Reemplaza con la ID de tu segunda subred
  ]
}
# Crear Target Groups
resource "aws_lb_target_group" "tg" {
  count = 4

  name     = "tg-instance-${count.index + 1}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-07d9bd0b898725449" # Tu VPC específica
}

# Crear Listeners para los Load Balancers
resource "aws_lb_listener" "listener" {
  count = 4

  load_balancer_arn = aws_lb.load_balancer[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[count.index].arn
  }
}

# Registrar las instancias existentes en los Target Groups
resource "aws_lb_target_group_attachment" "attachment" {
  count = 4

  target_group_arn = aws_lb_target_group.tg[count.index].arn
  target_id        = data.aws_instances.existing_instances[count.index].ids[0]
  port             = 80

  depends_on = [aws_instance.ec2_instance] # Asegura que las instancias estén creadas
}
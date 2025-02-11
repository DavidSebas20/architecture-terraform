# Mostrar las IPs públicas y DNS públicos de las instancias
output "instance_public_ips_and_dns" {
  value = [
    for instance in aws_instance.ec2_instance : {
      public_ip  = instance.public_ip
      public_dns = instance.public_dns
    }
  ]
}

# Mostrar los DNS de los Load Balancers
output "load_balancer_dns_names" {
  value = [for lb in aws_lb.load_balancer : lb.dns_name]
}

# Mostrar la clave privada SSH generada
output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
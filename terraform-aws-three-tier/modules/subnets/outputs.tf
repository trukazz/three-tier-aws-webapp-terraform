output "subnets_id" {
  description = "IDs of all created subnets"
  value       = [for s in aws_subnet.this : s.id]
}

output "public_subnet_ids" {
  value = {
    for k, s in aws_subnet.this : k => s.id
    if s.map_public_ip_on_launch
  }
}

output "private_subnet_ids" {
  value = {
    for k, s in aws_subnet.this : k => s.id
    if !s.map_public_ip_on_launch
  }
}

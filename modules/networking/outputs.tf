output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

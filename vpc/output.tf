output "vpc_id" {
  value = aws_vpc.eks-vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
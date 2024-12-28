output "vpc_id" {
    value = aws_vpc.my-vpc.id
}

output "public_subnet_ids" {
    value = [for key, subnet in aws_subnet.my-public-subnet : subnet.id if var.subnets[key].public == true]
}

output "private_subnet_ids" {
    value = [for key, subnet in aws_subnet.my-public-subnet : subnet.id if var.subnets[key].public == false]
}

resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc-cidr
    enable_dns_hostnames = true
    enable_dns_support = true
  
}

resource "aws_internet_gateway" "my-igw" {
    vpc_id = aws_vpc.my-vpc.id
  
}

resource "aws_subnet" "my-public-subnet" {
    for_each = var.subnets
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = each.value.cidr
    map_public_ip_on_launch = each.value.public
    availability_zone = each.value.public

  
}

resource "aws_route_table" "my-public-route" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = var.route-cidr
        gateway_id = aws_internet_gateway.my-igw.id
    }
  
}

resource "aws_route_table_association" "my-public-rtba" {
    for_each = {for key, subnet in var.subnets : key => subnet if subnet.public == true}
    subnet_id = aws_subnet.my-public-subnet[each.key].id
    route_table_id = aws_route_table.my-public-route.id
  
}

resource "aws_eip" "my-eip" {
    domain = true
  
}

resource "aws_nat_gateway" "my-nat" {
    allocation_id = aws_eip.my-eip.id
    subnet_id = aws_subnet.my-public-subnet[each.key].id
  
}

resource "aws_route_table" "my-private-route" {
    vpc_id = aws_vpc.my-vpc.id
    route {
        cidr_block = var.route-cidr
        gateway_id = aws_nat_gateway.my-nat.id
    }
  
}

resource "aws_route_table_association" "my-private-rtba" {
  for_each = {for key , subnet in var.subnets : key => subnet if subnet.public == false}
  subnet_id = aws_subnet.my-public-subnet[each.key].id
  route_table_id = aws_route_table.my-private-route.id
}
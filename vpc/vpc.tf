data "aws_availability_zones" "available" {
  state = "available"
}

# VPC 
resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "eks-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "k8svpc-igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "k8svpc-igw"
  }
}
#Private Subnet

resource "aws_subnet" "private" {
 count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.eks-vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name                              =   "privateSubnet-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/mycluster" = "owned"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                         = "publicSubnet-${count.index}"
    "kubernetes.io/role/elb"     = "1" #this instruct the kubernetes to create public load balancer in these subnets
    "kubernetes.io/cluster/mycluster" = "owned"
  }
}

# NAT GATEWAT
resource "aws_eip" "nat" {
  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, 0) # Assuming NAT gateway is in the first public subnet

  depends_on = [aws_internet_gateway.k8svpc-igw]
}


# routing table - public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8svpc-igw.id
  }
    tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private"
  }
}


# routing table association

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
















# k8s_private_subnet variable
locals {
  private_subnet_map = {
    "private-1" = aws_subnet.private_subnet_1.id
    "private-2" = aws_subnet.private_subnet_2.id
    "private-3" = aws_subnet.private_subnet_3.id
  }
}

#################################################
# Internet_Gateway 생성
resource "aws_internet_gateway" "k8s_igw" {
    vpc_id = aws_vpc.k8s_vpc.id

    tags = {
        Name = "K8S_IGW"
    }
}

##################################################
# NAT_Gateway 생성
# 1. NAT 용 EIP 생성
resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags = {
        Name = "NAT-EIP"
    }
}

# 2. NAT_Gateway 생성
resource "aws_nat_gateway" "nat_gw"  {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet_1.id
    tags = {
        Name = "K8S-NAT-GW"
    }
    depends_on = [aws_internet_gateway.k8s_igw] # => igw가 먼저 생성이 되어야함. 을 의미미
}

##################################################
# Public Route Table 생성 #
resource "aws_route_table" "k8s_bastion_rt" {
    vpc_id = aws_vpc.k8s_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s_igw.id
    }

    tags = {
        Name = "K8S_BASTION_RT"
    }
}

# Public Subnet과 route table 연결
resource "aws_route_table_association" "k8s_rt_public_subnet_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.k8s_bastion_rt.id
}

####################################################
# Private Route Table 생성 #
resource "aws_route_table" "k8s_private_rt" {
    vpc_id = aws_vpc.k8s_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }

    tags = {
        Name = "K8S_PRIVATE_RT"
    }
}

# NAT Routetable <-> Private K8S MasterNode
resource "aws_route_table_association" "k8s_private_rt_assoc" {
  for_each       = local.private_subnet_map
  subnet_id      = each.value
  route_table_id = aws_route_table.k8s_private_rt.id
}
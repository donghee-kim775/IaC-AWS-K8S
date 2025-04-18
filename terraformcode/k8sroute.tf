# Internet_Gateway 생성
resource "aws_internet_gateway" "k8s_igw" {
    vpc_id = aws_vpc.k8s_vpc.id

    tags = {
        Name = "K8S_IGW"
    }
}

# Route Table 생성
resource "aws_route_table" "k8s_rt" {
    vpc_id = aws_vpc.k8s_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.k8s_igw.id
    }

    tags = {
        Name = "K8S_RT"
    }
}

# Public Subnet과 route table 연결
resource "aws_route_table_association" "k8s_rt_public_subnet_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.k8s_rt.id
}
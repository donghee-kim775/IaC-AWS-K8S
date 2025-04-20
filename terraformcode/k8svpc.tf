# VPC 생성
resource "aws_vpc" "k8s_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support   = true   # AWS 내부 DNS (default : true)
    enable_dns_hostnames = false  # Public DNS

    tags = {
        Name = "K8S-VPC"
    }
}

# Subnet 생성 : BastionHost
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = true # Public IP 자동할당

    tags = {
        Name = "K8S-PUBLIC-1"
    }
}

# Subnet 생성 : MasterNode & WorkerNode1 - Private Subnet
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "ap-northeast-2a"

    tags = {
        Name = "K8S-PRIVATE-1"
    }
}

# Subnet 생성 : WorkerNode2 - Private Subnet
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-northeast-2c"

    tags = {
        Name = "K8S-PRIVATE-2"
    }
}

# Subnet 생성 : WorkerNode3 - Private Subnet
resource "aws_subnet" "private_subnet_3" {
    vpc_id = aws_vpc.k8s_vpc.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "ap-northeast-2c"

    tags = {
        Name = "K8S-PRIVATE-3"
    }
}
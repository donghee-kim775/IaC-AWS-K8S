# AWS Provider 설정
provider "aws" {
    region = "ap-northeast-2" # Region 설정
}

# VPC 생성
resource "aws_vpc" "k8s_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support   = true   # AWS 내부 DNS (default : true)
    enable_dns_hostnames = false  # Public DNS

    tags = {
        Name = "K8S-VPC"
    }
}
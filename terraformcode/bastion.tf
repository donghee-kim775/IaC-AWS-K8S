###############
# SSH Key Gen #
###############
# tls_private_key
# 1. private_key_pem => EC2 접근 시 사용할 private_key_pem
# 2. public_key_pem => AWS에 등록할 공개 public_key_pem
resource "tls_private_key" "k8s-bastion-key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "k8s-bastion-key" {
    key_name = "k8s-bastion-key"
    public_key = tls_private_key.k8s-bastion-key.public_key_openssh
}

resource "local_file" "bastion_private_key" {
    content = tls_private_key.k8s-bastion-key.private_key_pem
    filename = "${path.module}/key/bastion-key.pem"
    file_permission = "0600"
}

################
# 보안 그룹 생성 #
################
resource "aws_security_group" "bastion_sg" {
    name = "bastion-sg"
    description = "Allow SSH from my IP"
    vpc_id = aws_vpc.k8s_vpc.id

    # 인바운드 규칙
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # 전 세계 모두 허용
    }

    # 아웃바운드 규칙
    egress {
        from_port = 0
        to_port = 0
        protocol = -1 # 모든 프로토콜
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#########################
# bastion instance 생성 #
#########################
resource "aws_instance" "bastion" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet_1.id
    associate_public_ip_address = true
    key_name = "k8s-bastion-key"
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]

    tags = {
        Name = "BastionHost"
    }
}
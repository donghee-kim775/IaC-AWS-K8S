###############
# SSH Key Gen #
###############
# Jump Proxy 용 Pem Key 생성
resource "tls_private_key" "k8s_cluster_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "k8s_cluster_key" {
  key_name   = "k8s-cluster-key"
  public_key = tls_private_key.k8s_cluster_key.public_key_openssh
}

resource "local_file" "k8s_cluster_private_key" {
  content         = tls_private_key.k8s_cluster_key.private_key_pem
  filename        = "${path.module}/key/cluster-key.pem"
  file_permission = "0600"
}

################
# 보안 그룹 생성 #
################
resource "aws_security_group" "k8s_node_sg" {
  name        = "k8s-node-sg"
  description = "Allow SSH from bastion only"
  vpc_id      = aws_vpc.k8s_vpc.id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "K8S-Node-SG"
  }
}

#########################
# K8S instance 생성 #
#########################
# MasterNode EC2
resource "aws_instance" "k8s_master_node" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type = "t2.medium"
    subnet_id     = aws_subnet.private_subnet_1.id
    key_name      = aws_key_pair.k8s_cluster_key.key_name
    vpc_security_group_ids = [aws_security_group.k8s_node_sg.id]
    private_ip = "10.0.2.10"
    tags = {
        Name = "K8S-MasterNode"
    }
}

# WorkerNode1 EC2
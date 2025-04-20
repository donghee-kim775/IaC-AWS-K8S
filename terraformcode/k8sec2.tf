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

#########################
# K8S instance 생성 #
#########################
# MasterNode EC2
resource "aws_instance" "k8s_master_node" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type = "t2.medium"
    subnet_id     = aws_subnet.private_subnet_1.id
    key_name      = aws_key_pair.k8s_cluster_key.key_name
    vpc_security_group_ids = [aws_security_group.k8s_master_sg.id]
    private_ip = "10.0.2.10"
    tags = {
        Name = "K8S-MasterNode"
    }
}

# WorkerNode1 EC2
resource "aws_instance" "k8s_worker_node_1" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type = "t2.medium"
    subnet_id     = aws_subnet.private_subnet_1.id
    key_name      = aws_key_pair.k8s_cluster_key.key_name
    vpc_security_group_ids = [aws_security_group.k8s_worker_sg.id]
    private_ip = "10.0.2.11"
    tags = {
        Name = "K8S-WORKERNODE1"
    }
}

# WorkerNode2 EC2
resource "aws_instance" "k8s_worker_node_2" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type = "t2.medium"
    subnet_id     = aws_subnet.private_subnet_2.id
    key_name      = aws_key_pair.k8s_cluster_key.key_name
    vpc_security_group_ids = [aws_security_group.k8s_worker_sg.id]
    private_ip = "10.0.3.11"
    tags = {
        Name = "K8S-WORKERNODE2"
    }
}

# WorkerNode3 EC2
resource "aws_instance" "k8s_worker_node_3" {
    ami = "ami-0c9c942bd7bf113a2"
    instance_type = "t2.medium"
    subnet_id     = aws_subnet.private_subnet_3.id
    key_name      = aws_key_pair.k8s_cluster_key.key_name
    vpc_security_group_ids = [aws_security_group.k8s_worker_sg.id]
    private_ip = "10.0.4.11"
    tags = {
        Name = "K8S-WORKERNODE3"
    }
}
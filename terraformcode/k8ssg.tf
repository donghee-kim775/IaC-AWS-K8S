#############
# Master SG #
#############
resource "aws_security_group" "k8s_master_sg" {
  name        = "k8s-master-sg"
  description = "K8s Master Node SG"
  vpc_id      = aws_vpc.k8s_vpc.id

  # SSH from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "SSH from Bastion"
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from all sources"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "K8S-Master-SG"
  }
}

#############
# Worker SG #
#############
resource "aws_security_group" "k8s_worker_sg" {
  name        = "k8s-worker-sg"
  description = "K8s Worker Node SG"
  vpc_id      = aws_vpc.k8s_vpc.id

  # SSH from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id, aws_security_group.k8s_master_sg.id]
    description     = "SSH from Bastion"
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from all sources"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "K8S-Worker-SG"
  }
}

#####################################################################
#################
# K8S Master SG #
################# 
# API Server access from Workers → Master
resource "aws_security_group_rule" "api_from_workers" {
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_master_sg.id
  source_security_group_id = aws_security_group.k8s_worker_sg.id
  description              = "K8s API Server access from workers"
}

# etcd from Workers → Master
resource "aws_security_group_rule" "etcd_from_workers" {
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2380
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_master_sg.id
  source_security_group_id = aws_security_group.k8s_worker_sg.id
  description              = "etcd Cluster access from workers"
}

#################
# K8S Worker SG #
################# 

# Kubelet API from Master → Workers
resource "aws_security_group_rule" "kubelet_from_master" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_worker_sg.id
  source_security_group_id = aws_security_group.k8s_master_sg.id
  description              = "Kubelet API from master"
}

# NodePort Services from Master → Workers
resource "aws_security_group_rule" "nodeport_from_master" {
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_worker_sg.id
  source_security_group_id = aws_security_group.k8s_master_sg.id
  description              = "NodePort access from master"
}

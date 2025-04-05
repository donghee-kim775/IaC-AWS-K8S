# SSH Key Gen
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
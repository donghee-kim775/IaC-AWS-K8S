sudo timedatectl set-timezone Asia/Seoul

chmod +x ./env.sh

# env 환경 밀어넣기
set -a # 자동 export 활성화
source .env
set +a

# Generate SSH config
cat > ~/.ssh/config <<EOF
Host bastion
    HostName ${Bastion_IP}
    User ubuntu
    IdentityFile ${bastion_key}

Host master-node
    HostName 10.0.2.10
    User ubuntu
    IdentityFile ${cluster_key}
    ProxyJump bastion
EOF

chmod 600 ~/.ssh/config
source venv/bin/activate

cd ./kubespray

ansible-playbook -i /home/donghee/work/ec2k8s/install_k8s/hosts.yaml cluster.yml \
  -u ubuntu \
  --become \
  --private-key="/home/donghee/work/ec2k8s/terraformcode/key/cluster-key.pem" \
  --ssh-extra-args="-o ProxyCommand='ssh -i /home/donghee/work/ec2k8s/terraformcode/key/bastion-key.pem -W %h:%p ubuntu@${Bastion_IP}'"
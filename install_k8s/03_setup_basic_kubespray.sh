cd kubespray

cp -rfp inventory/sample inventory/mycluster

# 다시 생성: inventory.ini 대신 hosts.yaml로 만들기
declare -a IPS=(10.0.2.10 10.0.2.11 10.0.3.11 10.0.4.11)
CONFIG_FILE=inventory/mycluster/hosts.yaml \
  python3 contrib/inventory_builder/inventory.py ${IPS[@]}
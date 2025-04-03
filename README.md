# Install K8S in AWS with Terraform
| Terraform과 .sh 파일들을 통해 AWS위 K8S 구축 자동화 극대화
이후, K8S 위에서 다양한 실습을 하고자한다.

---
### Manual - 작성 중
| https://youthful-yew-08d.notion.site/Install-K8S-with-IaC-1b05c482697580feba6cd0b997b0ab20?pvs=4

---
### .env 설정
```
# 공백이 있으면 안됨...!
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""

# AWS INFRA
# AWS CLI => VPC_ID (ps. Values는 지은이가 k8svpc.tf에서 VPC tags name을 "K8S-VPC"로 주었음..!)
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=K8S-VPC" --query "Vpcs[0].VpcId" --output text --region ap-northeast-2 || echo "None")

# Testing EnvVariable
testing="A"
```
---
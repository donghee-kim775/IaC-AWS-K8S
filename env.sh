chmod +x ./env.sh

# env 환경 밀어넣기
set -a # 자동 export 활성화
source .env
set +a
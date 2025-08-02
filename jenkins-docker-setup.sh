#!/bin/bash

# Jenkins Docker 컨테이너 재설정 스크립트
# Docker-in-Docker 및 볼륨 마운트 설정

echo "=== Jenkins Docker 컨테이너 재설정 ==="

# 1. 기존 Jenkins 컨테이너 정지 및 제거
echo "기존 Jenkins 컨테이너 정리 중..."
docker stop jenkins 2>/dev/null || true
docker rm jenkins 2>/dev/null || true

# 2. Jenkins 데이터 볼륨 생성 (기존 데이터 보존)
echo "Jenkins 데이터 볼륨 생성 중..."
docker volume create jenkins_home 2>/dev/null || true

# 3. 배포 디렉토리 생성 및 권한 설정
echo "배포 디렉토리 준비 중..."
sudo mkdir -p /volume1/homes/joopok/java/job_finder
sudo chown -R 1000:1000 /volume1/homes/joopok/java/job_finder

# 4. Docker 그룹 ID 확인
DOCKER_GID=$(getent group docker | cut -d: -f3)
echo "Docker 그룹 ID: $DOCKER_GID"

# 5. Jenkins 컨테이너 실행 (Docker-in-Docker 지원)
echo "Jenkins 컨테이너 실행 중..."
docker run -d \
  --name jenkins \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /volume1/homes/joopok/java/job_finder:/volume1/homes/joopok/java/job_finder \
  -v /usr/bin/docker:/usr/bin/docker:ro \
  --group-add ${DOCKER_GID} \
  -e TZ=Asia/Seoul \
  jenkins/jenkins:lts

echo "Jenkins 컨테이너 시작 완료!"
echo "Jenkins URL: http://localhost:8080"
echo ""
echo "=== 설정 확인 ==="
sleep 10

# 6. 설정 확인
echo "컨테이너 상태:"
docker ps | grep jenkins

echo ""
echo "Docker 명령어 테스트:"
docker exec jenkins docker --version

echo ""
echo "배포 디렉토리 접근 테스트:"
docker exec jenkins ls -la /volume1/homes/joopok/java/

echo ""
echo "🎉 Jenkins Docker 설정이 완료되었습니다!"
echo "이제 Jenkins에서 Docker 명령어와 배포 디렉토리를 사용할 수 있습니다."
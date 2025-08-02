#!/bin/bash

# Jenkins Java 8 컨테이너 재설정 스크립트
# Java 21 → Java 8로 변경

echo "=== Jenkins Java 8 컨테이너 설정 ==="

# 1. 기존 Jenkins 컨테이너 정지 및 데이터 백업
echo "기존 Jenkins 컨테이너 백업 및 정리 중..."
docker stop jenkins 2>/dev/null || true

# Jenkins 데이터 백업 (안전을 위해)
docker run --rm -v jenkins_home:/source -v $(pwd):/backup alpine \
  tar czf /backup/jenkins-backup-$(date +%Y%m%d).tar.gz -C /source . 2>/dev/null || echo "백업 건너뜀"

docker rm jenkins 2>/dev/null || true

# 2. 배포 디렉토리 생성 및 권한 설정
echo "배포 디렉토리 준비 중..."
sudo mkdir -p /volume1/homes/joopok/java/job_finder
sudo chown -R 1000:1000 /volume1/homes/joopok/java/job_finder

# 3. Docker 그룹 ID 확인
DOCKER_GID=$(getent group docker | cut -d: -f3)
echo "Docker 그룹 ID: $DOCKER_GID"

# 4. Jenkins Java 8 컨테이너 실행
echo "Jenkins Java 8 컨테이너 실행 중..."
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
  -e JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
  jenkins/jenkins:lts-jdk8

echo "Jenkins Java 8 컨테이너 시작 완료!"
echo "Jenkins URL: http://localhost:8080"
echo ""
echo "=== 설정 확인 ==="
sleep 15

# 5. 설정 확인
echo "컨테이너 상태:"
docker ps | grep jenkins

echo ""
echo "Java 버전 확인:"
docker exec jenkins java -version

echo ""
echo "Docker 명령어 테스트:"
docker exec jenkins docker --version 2>/dev/null || echo "Docker 명령어 설정 필요"

echo ""
echo "배포 디렉토리 접근 테스트:"
docker exec jenkins ls -la /volume1/homes/joopok/java/ 2>/dev/null || echo "볼륨 마운트 확인 필요"

echo ""
echo "🎉 Jenkins Java 8 설정이 완료되었습니다!"
echo "이제 Java 8 환경에서 빌드가 가능합니다."
#!/bin/bash

# Jenkins Execute Shell Script for Java Spring Boot Deployment
# 복사해서 Jenkins Execute Shell에 붙여넣기용

set -e  # 에러 발생 시 즉시 중단

echo "=== Jenkins 배포 시작 ==="
echo "빌드 번호: $BUILD_NUMBER"
echo "작업 공간: $WORKSPACE"
echo "배포 시간: $(date)"

# 변수 설정
DEPLOY_DIR="/volume1/homes/joopok/java/job_finder"
APP_NAME="job-platform"
CONTAINER_NAME="job-platform-container"
IMAGE_NAME="job-platform:latest"
JAR_FILE="jobfinder-backend-1.0.0.jar"

# 1. 기존 컨테이너 정리
echo "=== 기존 컨테이너 정리 ==="
if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
    echo "기존 컨테이너 중지 중..."
    docker stop $CONTAINER_NAME || true
fi

if docker ps -aq -f name=$CONTAINER_NAME | grep -q .; then
    echo "기존 컨테이너 삭제 중..."
    docker rm $CONTAINER_NAME || true
fi

if docker images -q $IMAGE_NAME | grep -q .; then
    echo "기존 이미지 삭제 중..."
    docker rmi $IMAGE_NAME || true
fi

# 2. 배포 디렉토리 준비
echo "=== 배포 디렉토리 준비 ==="
mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR

# 3. Git에서 최신 소스 가져오기
echo "=== Git 소스 가져오기 ==="
if [ -d ".git" ]; then
    echo "기존 저장소 업데이트 중..."
    git fetch origin
    git reset --hard origin/main
else
    echo "새로운 저장소 클론 중..."
    git clone /volume1/homes/joopok/java/git_project.git .
fi

echo "현재 커밋: $(git rev-parse --short HEAD)"
echo "마지막 커밋 메시지: $(git log -1 --pretty=%B)"

# 4. Gradle 빌드
echo "=== Gradle 빌드 시작 ==="
chmod +x ./gradlew

# 빌드 전 정리
./gradlew clean

# Java 8 호환성 확인
echo "Java 버전 확인:"
./gradlew --version

# 빌드 실행 (테스트 제외)
echo "애플리케이션 빌드 중..."
./gradlew build -x test

# JAR 파일 확인
if [ ! -f "build/libs/$JAR_FILE" ]; then
    echo "ERROR: JAR 파일을 찾을 수 없습니다: build/libs/$JAR_FILE"
    ls -la build/libs/
    exit 1
fi

echo "빌드 완료: $(ls -lh build/libs/$JAR_FILE)"

# 5. Docker 이미지 빌드
echo "=== Docker 이미지 빌드 ==="
if [ ! -f "Dockerfile" ]; then
    echo "ERROR: Dockerfile을 찾을 수 없습니다"
    exit 1
fi

echo "Docker 이미지 빌드 중..."
docker build -t $IMAGE_NAME .

echo "빌드된 이미지 확인:"
docker images $IMAGE_NAME

# 6. Docker 컨테이너 실행
echo "=== Docker 컨테이너 실행 ==="
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p 9090:9090 \
    -e SPRING_PROFILES_ACTIVE=prod \
    -e TZ=Asia/Seoul \
    $IMAGE_NAME

# 7. 배포 확인
echo "=== 배포 상태 확인 ==="
sleep 10

# 컨테이너 상태 확인
if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" -q | grep -q .; then
    echo "✅ 컨테이너가 성공적으로 실행 중입니다"
    docker ps --filter "name=$CONTAINER_NAME"
else
    echo "❌ 컨테이너 실행 실패"
    echo "컨테이너 로그:"
    docker logs $CONTAINER_NAME
    exit 1
fi

# 헬스체크
echo "애플리케이션 헬스체크 중..."
for i in {1..12}; do
    if curl -f -s http://localhost:9090/actuator/health > /dev/null 2>&1; then
        echo "✅ 애플리케이션이 정상적으로 시작되었습니다"
        break
    elif [ $i -eq 12 ]; then
        echo "❌ 애플리케이션 시작 실패 (헬스체크 타임아웃)"
        docker logs --tail 50 $CONTAINER_NAME
        exit 1
    else
        echo "헬스체크 시도 $i/12..."
        sleep 5
    fi
done

# 8. 배포 완료 정보
echo "=== 배포 완료 ==="
echo "📱 애플리케이션 URL: http://localhost:9090"
echo "📚 Swagger UI: http://localhost:9090/swagger-ui.html"
echo "❤️ 헬스체크: http://localhost:9090/actuator/health"
echo "🐳 컨테이너 이름: $CONTAINER_NAME"
echo "🏷️ 이미지: $IMAGE_NAME"
echo "📅 배포 완료 시간: $(date)"

# 컨테이너 리소스 정보
echo ""
echo "=== 컨테이너 리소스 정보 ==="
docker stats --no-stream $CONTAINER_NAME

echo ""
echo "🎉 Jenkins 배포가 성공적으로 완료되었습니다!"
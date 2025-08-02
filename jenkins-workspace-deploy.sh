#!/bin/bash

# Jenkins Execute Shell Script (작업공간 기반 배포)
# Docker-in-Docker 없이 Jenkins 작업공간에서 직접 빌드

set -e  # 에러 발생 시 즉시 중단

echo "=== Jenkins 배포 시작 ==="
echo "빌드 번호: $BUILD_NUMBER"
echo "작업 공간: $WORKSPACE"
echo "배포 시간: $(date)"

# 변수 설정 (Jenkins 작업공간 사용)
WORK_DIR="$WORKSPACE"
APP_NAME="job-platform"
JAR_FILE="jobfinder-backend-1.0.0.jar"
DEPLOY_TARGET="/volume1/homes/joopok/java/job_finder"

echo "=== 작업 디렉토리 확인 ==="
echo "현재 디렉토리: $(pwd)"
echo "작업공간 내용:"
ls -la $WORK_DIR

# 1. Gradle 빌드
echo "=== Gradle 빌드 시작 ==="
cd $WORK_DIR

# gradlew 실행 권한 설정
chmod +x ./gradlew

# 빌드 전 정리
echo "이전 빌드 정리 중..."
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

# 2. 배포 파일 복사 (호스트 시스템으로)
echo "=== 배포 파일 준비 ==="

# 배포 디렉토리가 마운트되어 있는지 확인
if [ -d "$DEPLOY_TARGET" ]; then
    echo "배포 디렉토리에 파일 복사 중..."
    
    # JAR 파일 복사
    cp build/libs/$JAR_FILE $DEPLOY_TARGET/app.jar
    
    # Dockerfile 복사 (있다면)
    if [ -f "Dockerfile" ]; then
        cp Dockerfile $DEPLOY_TARGET/
    fi
    
    # 배포 스크립트 생성
    cat > $DEPLOY_TARGET/deploy.sh << 'EOF'
#!/bin/bash
# 호스트에서 실행할 배포 스크립트

CONTAINER_NAME="job-platform-container"
IMAGE_NAME="job-platform:latest"

echo "=== Docker 배포 시작 ==="

# 기존 컨테이너 정리
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true
docker rmi $IMAGE_NAME 2>/dev/null || true

# Docker 이미지 빌드
docker build -t $IMAGE_NAME .

# 컨테이너 실행
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p 9090:9090 \
    -e SPRING_PROFILES_ACTIVE=prod \
    -e TZ=Asia/Seoul \
    $IMAGE_NAME

echo "배포 완료!"
echo "애플리케이션 URL: http://localhost:9090"
echo "Swagger UI: http://localhost:9090/swagger-ui.html"
EOF
    
    chmod +x $DEPLOY_TARGET/deploy.sh
    
    echo "✅ 배포 파일이 준비되었습니다: $DEPLOY_TARGET"
    echo "📋 다음 단계: 호스트에서 다음 명령어 실행"
    echo "   cd $DEPLOY_TARGET && ./deploy.sh"
    
else
    echo "⚠️ 배포 디렉토리를 찾을 수 없습니다: $DEPLOY_TARGET"
    echo "Jenkins 컨테이너에 볼륨이 마운트되지 않았습니다."
    echo "현재 JAR 파일 위치: $WORK_DIR/build/libs/$JAR_FILE"
fi

# 3. 빌드 결과 요약
echo ""
echo "=== 빌드 결과 요약 ==="
echo "✅ Java 애플리케이션 빌드 완료"
echo "📦 JAR 파일: build/libs/$JAR_FILE ($(ls -lh build/libs/$JAR_FILE | awk '{print $5}'))"

if [ -d "$DEPLOY_TARGET" ]; then
    echo "📁 배포 파일 위치: $DEPLOY_TARGET"
    echo "🚀 배포 명령어: cd $DEPLOY_TARGET && ./deploy.sh"
else
    echo "📁 JAR 파일 위치: $WORK_DIR/build/libs/$JAR_FILE"
fi

echo ""
echo "🎉 Jenkins 빌드가 성공적으로 완료되었습니다!"
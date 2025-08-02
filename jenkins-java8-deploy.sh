#!/bin/bash

# Jenkins Execute Shell Script (Java 8 강제 사용)
# Java 버전 호환성 문제 해결

set -e  # 에러 발생 시 즉시 중단

echo "=== Jenkins 배포 시작 ==="
echo "빌드 번호: $BUILD_NUMBER"
echo "작업 공간: $WORKSPACE"
echo "배포 시간: $(date)"

# Java 8 경로 설정 (Jenkins 컨테이너 내부)
export JAVA_HOME=/opt/java/openjdk-8
export PATH=$JAVA_HOME/bin:$PATH

# Java 버전 확인
echo "=== Java 환경 확인 ==="
echo "JAVA_HOME: $JAVA_HOME"
java -version
javac -version

# 변수 설정 (Jenkins 작업공간 사용)
WORK_DIR="$WORKSPACE"
APP_NAME="job-platform"
JAR_FILE="jobfinder-backend-1.0.0.jar"
DEPLOY_TARGET="/volume1/homes/joopok/java/job_finder"

echo "=== 작업 디렉토리 확인 ==="
echo "현재 디렉토리: $(pwd)"
ls -la $WORK_DIR

# 1. Gradle 빌드 (Java 8 사용)
echo "=== Gradle 빌드 시작 ==="
cd $WORK_DIR

# gradlew 실행 권한 설정
chmod +x ./gradlew

# Gradle 데몬 정리 (Java 버전 충돌 방지)
./gradlew --stop || true
rm -rf ~/.gradle/daemon/ || true

# 빌드 전 정리
echo "이전 빌드 정리 중..."
./gradlew clean --no-daemon

# Java 8 호환성 확인
echo "Gradle Java 버전 확인:"
./gradlew --version --no-daemon

# 빌드 실행 (테스트 제외, 데몬 비활성화)
echo "애플리케이션 빌드 중..."
./gradlew build -x test --no-daemon

# JAR 파일 확인
if [ ! -f "build/libs/$JAR_FILE" ]; then
    echo "ERROR: JAR 파일을 찾을 수 없습니다: build/libs/$JAR_FILE"
    echo "사용 가능한 JAR 파일:"
    ls -la build/libs/
    # 첫 번째 JAR 파일 사용
    JAR_FILE=$(ls build/libs/*.jar | head -1 | xargs basename)
    echo "대체 JAR 파일 사용: $JAR_FILE"
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
    else
        echo "Dockerfile이 없으므로 생성 중..."
        cat > $DEPLOY_TARGET/Dockerfile << 'DOCKEREOF'
# Spring Boot 애플리케이션을 위한 Dockerfile
# Java 8 기반 경량 Alpine Linux 이미지 사용
FROM openjdk:8-jre-alpine

# 작업 디렉토리 설정
WORKDIR /app

# 애플리케이션 정보
LABEL maintainer="doshyun@gmail.com"
LABEL description="Job Platform Spring Boot Application"
LABEL version="1.0.0"

# 시간대 설정 (한국 시간)
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    apk del tzdata

# JAR 파일을 컨테이너로 복사
COPY app.jar app.jar

# 애플리케이션 실행을 위한 포트 노출
EXPOSE 9090

# JVM 옵션 설정 (메모리 최적화)
ENV JAVA_OPTS="-Xms256m -Xmx512m -Djava.security.egd=file:/dev/./urandom"

# Spring Boot 프로파일 설정 (기본값)
ENV SPRING_PROFILES_ACTIVE=prod

# 헬스체크 설정
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9090/actuator/health || exit 1

# 애플리케이션 실행
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
DOCKEREOF
    fi
    
    # 배포 스크립트 생성
    cat > $DEPLOY_TARGET/deploy.sh << 'DEPLOYEOF'
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
echo "Docker 이미지 빌드 중..."
docker build -t $IMAGE_NAME .

# 컨테이너 실행
echo "컨테이너 실행 중..."
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p 9090:9090 \
    -e SPRING_PROFILES_ACTIVE=prod \
    -e TZ=Asia/Seoul \
    $IMAGE_NAME

# 배포 확인
sleep 10
if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" -q | grep -q .; then
    echo "✅ 배포 완료!"
    echo "📱 애플리케이션 URL: http://localhost:9090"
    echo "📚 Swagger UI: http://localhost:9090/swagger-ui.html"
    echo "❤️ 헬스체크: http://localhost:9090/actuator/health"
    docker ps --filter "name=$CONTAINER_NAME"
else
    echo "❌ 컨테이너 실행 실패"
    docker logs $CONTAINER_NAME
fi
DEPLOYEOF
    
    chmod +x $DEPLOY_TARGET/deploy.sh
    
    echo "✅ 배포 파일이 준비되었습니다: $DEPLOY_TARGET"
    echo "📁 배포된 파일:"
    ls -la $DEPLOY_TARGET/
    
else
    echo "⚠️ 배포 디렉토리를 찾을 수 없습니다: $DEPLOY_TARGET"
    echo "Jenkins 컨테이너에 볼륨이 마운트되지 않았습니다."
    echo "현재 JAR 파일 위치: $WORK_DIR/build/libs/$JAR_FILE"
fi

# 3. 빌드 결과 요약
echo ""
echo "=== 빌드 결과 요약 ==="
echo "✅ Java 8로 애플리케이션 빌드 완료"
echo "📦 JAR 파일: build/libs/$JAR_FILE ($(ls -lh build/libs/$JAR_FILE | awk '{print $5}'))"

if [ -d "$DEPLOY_TARGET" ]; then
    echo "📁 배포 파일 위치: $DEPLOY_TARGET"
    echo "🚀 다음 단계: 호스트에서 배포 실행"
    echo "   ssh joopok@192.168.0.109"
    echo "   cd $DEPLOY_TARGET"
    echo "   ./deploy.sh"
else
    echo "📁 JAR 파일 위치: $WORK_DIR/build/libs/$JAR_FILE"
fi

echo ""
echo "🎉 Jenkins 빌드가 성공적으로 완료되었습니다!"
#!/bin/bash

# Jenkins Execute Shell Script (Java 경로 자동 탐지)
# Java 8 호환성 문제 해결

set -e  # 에러 발생 시 즉시 중단

echo "=== Jenkins 배포 시작 ==="
echo "빌드 번호: $BUILD_NUMBER"
echo "작업 공간: $WORKSPACE"
echo "배포 시간: $(date)"

# Java 경로 자동 탐지
echo "=== Java 경로 탐지 ==="
echo "기본 Java 위치:"
which java
echo "기본 Javac 위치:"
which javac
echo "현재 Java 버전:"
java -version

# 가능한 Java 경로들 확인
POSSIBLE_JAVA_HOMES=(
    "/usr/lib/jvm/java-8-openjdk-amd64"
    "/usr/lib/jvm/java-1.8.0-openjdk"
    "/opt/java/openjdk"
    "/usr/java/latest"
    "/usr/lib/jvm/default-java"
    "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home"
    "/usr/lib/jvm/adoptopenjdk-8-hotspot"
)

JAVA_8_HOME=""
echo "Java 설치 경로 검색 중..."

for path in "${POSSIBLE_JAVA_HOMES[@]}"; do
    if [ -d "$path" ]; then
        echo "발견된 Java 경로: $path"
        if [ -f "$path/bin/java" ]; then
            VERSION_OUTPUT=$($path/bin/java -version 2>&1)
            if echo "$VERSION_OUTPUT" | grep -q "1.8\|openjdk 8"; then
                JAVA_8_HOME="$path"
                echo "✅ Java 8 발견: $JAVA_8_HOME"
                break
            else
                echo "❌ Java 8이 아님: $path"
            fi
        fi
    fi
done

# Java 8을 찾지 못한 경우 현재 Java 사용 (호환성 위험 감수)
if [ -z "$JAVA_8_HOME" ]; then
    echo "⚠️ Java 8을 찾을 수 없습니다. 현재 Java 사용 (호환성 문제 가능)"
    JAVA_REAL_HOME=$(dirname $(dirname $(readlink -f $(which java))))
    export JAVA_HOME="$JAVA_REAL_HOME"
    echo "현재 JAVA_HOME: $JAVA_HOME"
else
    export JAVA_HOME="$JAVA_8_HOME"
    export PATH="$JAVA_HOME/bin:$PATH"
    echo "✅ Java 8 설정: $JAVA_HOME"
fi

# Java 버전 최종 확인
echo "=== 최종 Java 환경 확인 ==="
echo "JAVA_HOME: $JAVA_HOME"
echo "PATH: $PATH"
java -version
javac -version

# 변수 설정 (Jenkins 작업공간 사용)
WORK_DIR="$WORKSPACE"
APP_NAME="job-platform"
JAR_FILE="jobfinder-backend-1.0.0.jar"
DEPLOY_TARGET="/volume1/homes/joopok/java/job_finder"

echo "=== 작업 디렉토리 확인 ==="
echo "현재 디렉토리: $(pwd)"

# 1. Gradle 빌드
echo "=== Gradle 빌드 시작 ==="
cd $WORK_DIR

# gradlew 실행 권한 설정
chmod +x ./gradlew

# Gradle 설정 확인
echo "build.gradle 확인:"
if [ -f "build.gradle" ]; then
    echo "✅ build.gradle 존재"
    grep -E "(sourceCompatibility|targetCompatibility|java\.sourceCompatibility)" build.gradle || echo "Java 버전 설정 없음"
else
    echo "❌ build.gradle 없음"
    exit 1
fi

# Gradle Wrapper 속성 확인
if [ -f "gradle/wrapper/gradle-wrapper.properties" ]; then
    echo "Gradle Wrapper 버전:"
    grep distributionUrl gradle/wrapper/gradle-wrapper.properties
fi

# Gradle 데몬 정리 (Java 버전 충돌 방지)
echo "Gradle 데몬 정리 중..."
./gradlew --stop 2>/dev/null || true
rm -rf ~/.gradle/daemon/ 2>/dev/null || true

# 빌드 전 정리
echo "이전 빌드 정리 중..."
./gradlew clean --no-daemon --stacktrace

# Gradle 버전 및 Java 호환성 확인
echo "Gradle 환경 확인:"
./gradlew --version --no-daemon

# 빌드 실행 (테스트 제외, 데몬 비활성화, 상세 로그)
echo "애플리케이션 빌드 중..."
./gradlew build -x test --no-daemon --stacktrace --info

# JAR 파일 확인
echo "=== 빌드 결과 확인 ==="
ls -la build/libs/

if [ ! -f "build/libs/$JAR_FILE" ]; then
    echo "⚠️ 예상 JAR 파일을 찾을 수 없습니다: build/libs/$JAR_FILE"
    echo "사용 가능한 JAR 파일:"
    JAR_FILES=(build/libs/*.jar)
    if [ ${#JAR_FILES[@]} -gt 0 ] && [ -f "${JAR_FILES[0]}" ]; then
        JAR_FILE=$(basename "${JAR_FILES[0]}")
        echo "✅ 대체 JAR 파일 사용: $JAR_FILE"
    else
        echo "❌ JAR 파일을 찾을 수 없습니다!"
        exit 1
    fi
fi

echo "빌드 완료: $(ls -lh build/libs/$JAR_FILE)"

# 2. 배포 파일 복사
echo "=== 배포 파일 준비 ==="

# 배포 디렉토리가 마운트되어 있는지 확인
if [ -d "$DEPLOY_TARGET" ]; then
    echo "배포 디렉토리에 파일 복사 중..."
    
    # JAR 파일 복사
    cp build/libs/$JAR_FILE $DEPLOY_TARGET/app.jar
    
    # Dockerfile 처리
    if [ -f "Dockerfile" ]; then
        cp Dockerfile $DEPLOY_TARGET/
        echo "✅ 기존 Dockerfile 복사됨"
    else
        echo "Dockerfile 생성 중..."
        cat > $DEPLOY_TARGET/Dockerfile << 'DOCKEREOF'
# Spring Boot 애플리케이션을 위한 Dockerfile
FROM openjdk:8-jre-alpine

WORKDIR /app

LABEL maintainer="doshyun@gmail.com"
LABEL description="Job Platform Spring Boot Application"
LABEL version="1.0.0"

# 시간대 설정 (한국 시간)
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    apk del tzdata

# JAR 파일 복사
COPY app.jar app.jar

# 포트 노출
EXPOSE 9090

# JVM 옵션
ENV JAVA_OPTS="-Xms256m -Xmx512m -Djava.security.egd=file:/dev/./urandom"
ENV SPRING_PROFILES_ACTIVE=prod

# 헬스체크
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9090/actuator/health || exit 1

# 애플리케이션 실행
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
DOCKEREOF
        echo "✅ Dockerfile 생성됨"
    fi
    
    # 배포 스크립트 생성
    cat > $DEPLOY_TARGET/deploy.sh << 'DEPLOYEOF'
#!/bin/bash
# 호스트에서 실행할 배포 스크립트

CONTAINER_NAME="job-platform-container"
IMAGE_NAME="job-platform:latest"

echo "=== Docker 배포 시작 ==="
cd $(dirname $0)

# 기존 컨테이너 정리
echo "기존 컨테이너 정리 중..."
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
echo "배포 상태 확인 중..."
sleep 15

if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" -q | grep -q .; then
    echo "✅ 배포 성공!"
    echo ""
    echo "=== 접속 정보 ==="
    echo "📱 애플리케이션: http://localhost:9090"
    echo "📚 Swagger UI: http://localhost:9090/swagger-ui.html"
    echo "❤️ 헬스체크: http://localhost:9090/actuator/health"
    echo ""
    echo "=== 컨테이너 상태 ==="
    docker ps --filter "name=$CONTAINER_NAME"
    echo ""
    echo "=== 애플리케이션 로그 (최근 20줄) ==="
    docker logs --tail 20 $CONTAINER_NAME
else
    echo "❌ 배포 실패!"
    echo ""
    echo "=== 컨테이너 로그 ==="
    docker logs $CONTAINER_NAME
    echo ""
    echo "=== 디버깅 정보 ==="
    docker ps -a --filter "name=$CONTAINER_NAME"
fi
DEPLOYEOF
    
    chmod +x $DEPLOY_TARGET/deploy.sh
    
    echo ""
    echo "✅ 배포 파일 준비 완료: $DEPLOY_TARGET"
    echo "📁 배포된 파일:"
    ls -la $DEPLOY_TARGET/
    
else
    echo "⚠️ 배포 디렉토리를 찾을 수 없습니다: $DEPLOY_TARGET"
    echo "Jenkins 컨테이너에 /volume1 볼륨이 마운트되지 않았습니다."
    echo ""
    echo "현재 JAR 파일 위치: $WORK_DIR/build/libs/$JAR_FILE"
    echo "수동으로 파일을 복사해야 합니다."
fi

# 3. 빌드 결과 요약
echo ""
echo "=== 빌드 결과 요약 ==="
echo "✅ Spring Boot 애플리케이션 빌드 완료"
echo "🔧 사용된 Java: $(java -version 2>&1 | head -1)"
echo "📦 JAR 파일: build/libs/$JAR_FILE ($(ls -lh build/libs/$JAR_FILE | awk '{print $5}'))"

if [ -d "$DEPLOY_TARGET" ]; then
    echo "📁 배포 위치: $DEPLOY_TARGET"
    echo ""
    echo "🚀 다음 단계: 호스트에서 배포 실행"
    echo "   ssh joopok@192.168.0.109"
    echo "   cd $DEPLOY_TARGET"
    echo "   ./deploy.sh"
else
    echo "📁 현재 위치: $WORK_DIR/build/libs/$JAR_FILE"
    echo ""
    echo "🚀 수동 배포 필요: JAR 파일을 호스트로 복사 후 Docker 빌드"
fi

echo ""
echo "🎉 Jenkins 빌드가 완료되었습니다!"
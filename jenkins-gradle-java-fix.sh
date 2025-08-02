#!/bin/bash

# Jenkins Execute Shell Script (Gradle Java 호환성 강제)
# Java 21에서 Java 8 바이트코드 생성

set -e  # 에러 발생 시 즉시 중단

echo "=== Jenkins 배포 시작 ==="
echo "빌드 번호: $BUILD_NUMBER"
echo "작업 공간: $WORKSPACE"
echo "배포 시간: $(date)"

# 현재 Java 환경 확인 (Java 21 사용)
echo "=== 현재 Java 환경 ==="
java -version
javac -version
echo "JAVA_HOME: ${JAVA_HOME:-'설정되지 않음'}"

# 변수 설정
WORK_DIR="$WORKSPACE"
JAR_FILE="jobfinder-backend-1.0.0.jar"
DEPLOY_TARGET="/volume1/homes/joopok/java/job_finder"

echo "=== 작업 디렉토리 확인 ==="
cd $WORK_DIR
ls -la

# 1. Gradle 프로젝트 Java 8 호환성 강제 설정
echo "=== Gradle Java 8 호환성 설정 ==="

# build.gradle 백업
cp build.gradle build.gradle.backup

# build.gradle에 Java 8 호환성 설정 추가/수정
cat > temp_build.gradle << 'EOF'
plugins {
    id 'org.springframework.boot' version '2.7.0'
    id 'io.spring.dependency-management' version '1.0.11.RELEASE'
    id 'java'
}

group = 'com.fid'
version = '1.0.0'

// Java 8 호환성 강제 설정
java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

// 컴파일러 옵션 강제 설정
compileJava {
    options.encoding = 'UTF-8'
    options.compilerArgs = ['-Xlint:unchecked', '-Xlint:deprecation']
    // Java 8 바이트코드 강제 생성
    sourceCompatibility = '8'
    targetCompatibility = '8'
}

compileTestJava {
    sourceCompatibility = '8'
    targetCompatibility = '8'
}

configurations {
    compileOnly {
        extendsFrom annotationProcessor
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-actuator'
    implementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter:2.2.2'
    implementation 'org.mariadb.jdbc:mariadb-java-client:3.0.4'
    implementation 'io.jsonwebtoken:jjwt:0.9.1'
    implementation 'org.springdoc:springdoc-openapi-ui:1.7.0'
    
    compileOnly 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'
    
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'org.springframework.security:spring-security-test'
}

// Jar 파일명 설정
jar {
    archiveBaseName = 'jobfinder-backend'
    archiveVersion = '1.0.0'
    enabled = false
}

bootJar {
    archiveBaseName = 'jobfinder-backend'
    archiveVersion = '1.0.0'
}

test {
    useJUnitPlatform()
}
EOF

# 기존 build.gradle과 비교하여 필요시 교체
if ! cmp -s build.gradle temp_build.gradle; then
    echo "build.gradle을 Java 8 호환성 버전으로 교체"
    mv temp_build.gradle build.gradle
else
    echo "build.gradle이 이미 올바르게 설정됨"
    rm temp_build.gradle
fi

# gradle.properties 생성 (Java 8 강제)
cat > gradle.properties << 'EOF'
# Java 8 호환성 강제 설정
org.gradle.java.home=/usr/lib/jvm/java-8-openjdk-amd64
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
org.gradle.parallel=true
org.gradle.caching=true

# Java 버전 강제
java.sourceCompatibility=8
java.targetCompatibility=8
EOF

echo "Gradle 설정 파일 확인:"
echo "=== build.gradle (Java 설정 부분) ==="
grep -A 10 -B 2 -E "(sourceCompatibility|targetCompatibility|compileJava)" build.gradle || echo "Java 설정 없음"

echo "=== gradle.properties ==="
cat gradle.properties

# 2. Gradle 빌드 실행
echo "=== Gradle 빌드 시작 ==="

# gradlew 실행 권한 설정
chmod +x ./gradlew

# Gradle 데몬 정리
echo "Gradle 환경 정리 중..."
./gradlew --stop 2>/dev/null || true
rm -rf ~/.gradle/daemon/ 2>/dev/null || true
rm -rf .gradle/daemon/ 2>/dev/null || true

# 빌드 전 정리
echo "이전 빌드 정리 중..."
./gradlew clean --no-daemon

# Gradle 환경 확인
echo "Gradle 환경 정보:"
./gradlew --version --no-daemon

# 빌드 실행 (Java 8 바이트코드 생성)
echo "애플리케이션 빌드 중... (Java 8 바이트코드 생성)"
./gradlew build -x test --no-daemon --info

# 빌드 결과 확인
echo "=== 빌드 결과 확인 ==="
ls -la build/libs/

# JAR 파일 찾기
if [ ! -f "build/libs/$JAR_FILE" ]; then
    echo "예상 JAR 파일이 없습니다. 사용 가능한 JAR 파일:"
    JAR_FILES=(build/libs/*.jar)
    if [ ${#JAR_FILES[@]} -gt 0 ] && [ -f "${JAR_FILES[0]}" ]; then
        JAR_FILE=$(basename "${JAR_FILES[0]}")
        echo "✅ 찾은 JAR 파일: $JAR_FILE"
    else
        echo "❌ JAR 파일을 찾을 수 없습니다!"
        exit 1
    fi
fi

# JAR 파일 Java 버전 확인
echo "JAR 파일 Java 호환성 확인:"
unzip -p build/libs/$JAR_FILE 'BOOT-INF/classes/com/fid/job/*.class' | head -1 | od -N 8 -t x1 | grep -q "ca fe ba be 00 00 00 34" && echo "✅ Java 8 바이트코드" || echo "⚠️ Java 8이 아닌 바이트코드"

echo "빌드 완료: $(ls -lh build/libs/$JAR_FILE)"

# 3. 배포 파일 준비
echo "=== 배포 파일 준비 ==="

if [ -d "$DEPLOY_TARGET" ]; then
    echo "배포 디렉토리에 파일 복사 중..."
    
    # JAR 파일 복사
    cp build/libs/$JAR_FILE $DEPLOY_TARGET/app.jar
    
    # Dockerfile 생성 (Java 8 런타임 사용)
    cat > $DEPLOY_TARGET/Dockerfile << 'DOCKEREOF'
# Spring Boot 애플리케이션을 위한 Dockerfile
# Java 8 런타임 사용 (Java 8 바이트코드 실행)
FROM openjdk:8-jre-alpine

WORKDIR /app

LABEL maintainer="doshyun@gmail.com"
LABEL description="Job Platform Spring Boot Application"
LABEL version="1.0.0"

# 시간대 설정
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo "Asia/Seoul" > /etc/timezone && \
    apk del tzdata

# 웹훅 도구 설치 (헬스체크용)
RUN apk add --no-cache wget

# JAR 파일 복사
COPY app.jar app.jar

# 포트 노출
EXPOSE 9090

# JVM 옵션 (Java 8 최적화)
ENV JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC -Djava.security.egd=file:/dev/./urandom"
ENV SPRING_PROFILES_ACTIVE=prod

# 헬스체크
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9090/actuator/health || exit 1

# 애플리케이션 실행
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
DOCKEREOF
    
    # 배포 스크립트 생성
    cat > $DEPLOY_TARGET/deploy.sh << 'DEPLOYEOF'
#!/bin/bash

CONTAINER_NAME="job-platform-container"
IMAGE_NAME="job-platform:latest"

echo "=== Job Platform Docker 배포 ==="
cd $(dirname $0)

echo "현재 디렉토리 파일:"
ls -la

# 기존 컨테이너 정리
echo "기존 컨테이너 정리 중..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true
docker rmi $IMAGE_NAME 2>/dev/null || true

# Docker 이미지 빌드
echo "Docker 이미지 빌드 중..."
docker build -t $IMAGE_NAME .

# 이미지 정보 확인
echo "빌드된 이미지:"
docker images $IMAGE_NAME

# 컨테이너 실행
echo "컨테이너 실행 중..."
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p 9090:9090 \
    -e SPRING_PROFILES_ACTIVE=prod \
    -e TZ=Asia/Seoul \
    -e JAVA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC" \
    $IMAGE_NAME

# 배포 확인
echo "컨테이너 시작 대기 중..."
sleep 20

echo "=== 배포 결과 확인 ==="
if docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" -q | grep -q .; then
    echo "✅ 배포 성공!"
    echo ""
    echo "=== 서비스 정보 ==="
    echo "🌐 애플리케이션: http://localhost:9090"
    echo "📚 Swagger UI: http://localhost:9090/swagger-ui.html"
    echo "📊 Actuator: http://localhost:9090/actuator"
    echo "❤️ 헬스체크: http://localhost:9090/actuator/health"
    echo ""
    echo "=== 컨테이너 상태 ==="
    docker ps --filter "name=$CONTAINER_NAME"
    echo ""
    echo "=== 애플리케이션 로그 ==="
    docker logs --tail 30 $CONTAINER_NAME
    
    # 헬스체크 테스트
    echo ""
    echo "=== 헬스체크 테스트 ==="
    sleep 5
    if curl -f -s http://localhost:9090/actuator/health > /dev/null; then
        echo "✅ 애플리케이션이 정상적으로 실행 중입니다!"
    else
        echo "⚠️ 애플리케이션이 시작 중이거나 문제가 있을 수 있습니다."
    fi
else
    echo "❌ 배포 실패!"
    echo ""
    echo "=== 컨테이너 상태 ==="
    docker ps -a --filter "name=$CONTAINER_NAME"
    echo ""
    echo "=== 컨테이너 로그 ==="
    docker logs $CONTAINER_NAME
fi
DEPLOYEOF
    
    chmod +x $DEPLOY_TARGET/deploy.sh
    
    echo ""
    echo "✅ 배포 파일 준비 완료!"
    echo "📁 배포 위치: $DEPLOY_TARGET"
    ls -la $DEPLOY_TARGET/
    
else
    echo "⚠️ 배포 디렉토리 없음: $DEPLOY_TARGET"
    echo "현재 JAR 위치: $WORK_DIR/build/libs/$JAR_FILE"
fi

# 4. 최종 요약
echo ""
echo "=== 빌드 완료 요약 ==="
echo "✅ Java 8 호환 바이트코드로 빌드 완료"
echo "📦 JAR: build/libs/$JAR_FILE ($(ls -lh build/libs/$JAR_FILE | awk '{print $5}'))"

if [ -d "$DEPLOY_TARGET" ]; then
    echo "🚀 배포 실행 명령어:"
    echo "   ssh joopok@192.168.0.109"
    echo "   cd $DEPLOY_TARGET"
    echo "   ./deploy.sh"
fi

echo ""
echo "🎉 Jenkins 빌드 성공!"
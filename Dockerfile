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
COPY build/libs/jobfinder-backend-1.0.0.jar app.jar

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
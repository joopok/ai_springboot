#!/bin/bash

# 색상 정의
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 로그 파일 경로
LOG_FILE="application.log"

# 포트 체크 함수
check_port() {
    if lsof -i :8081 > /dev/null 2>&1; then
        echo -e "${RED}Port 8081 is already in use. Stopping existing process...${NC}"
        lsof -i :8081 | grep LISTEN | awk '{print $2}' | xargs -r kill -9
        sleep 2
    fi
}

# 메뉴 표시 함수
show_menu() {
    echo -e "\n${BLUE}==================================="
    echo "PM7 Spring Boot Application Manager"
    echo -e "===================================${NC}"
    echo
    echo "2. Restart Application"
    echo "3. Exit"
    echo -e "\n${YELLOW}Select an option (2-3):${NC} "
}

# Maven 의존성 체크 및 업데이트
check_maven() {
    echo -e "${BLUE}Checking Maven dependencies...${NC}"
    ./mvnw clean install -DskipTests
    if [ $? -ne 0 ]; then
        echo -e "${RED}Maven build failed. Please check your dependencies.${NC}"
        read -p "Press Enter to continue..."
        return 1
    fi
    return 0
}

# 애플리케이션 시작 함수
start_app() {
    echo -e "${GREEN}Starting PM7 Application...${NC}"
    
    # Maven 체크
    check_maven || return
    
    # 포트 체크 및 정리
    check_port
    
    # 로그 파일 초기화
    > "$LOG_FILE"
    
    # 로그 출력을 위한 named pipe 생성
    PIPE="/tmp/spring_app_pipe"
    [ -p "$PIPE" ] || mkfifo "$PIPE"
    
    # 애플리케이션 시작 (디버그 모드로 실행)
    (SPRING_PROFILES_ACTIVE=local \
    LOGGING_LEVEL_ROOT=INFO \
    LOGGING_LEVEL_COM_EXAMPLE_PM7=DEBUG \
    LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_WEB=DEBUG \
    LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_SECURITY=DEBUG \
    LOGGING_LEVEL_ORG_MYBATIS=DEBUG \
    ./mvnw spring-boot:run \
    -Dspring-boot.run.arguments="--debug --mybatis.mapper-locations=classpath:mapper/**/*.xml" \
    | tee "$PIPE" > "$LOG_FILE") &
    
    APP_PID=$!
    echo $APP_PID > app.pid
    
    echo -e "${GREEN}Application is starting in debug mode... Please wait.${NC}"
    sleep 3
    
    # 로그 출력과 메뉴 동시 표시
    show_menu
    
    # 로그 실시간 출력
    cat "$PIPE" | grep --line-buffered -E "DEBUG|INFO|WARN|ERROR" &
    TAIL_PID=$!
    
    # 사용자 입력 처리
    while true; do
        read choice
        case $choice in
            2)
                echo -e "${GREEN}Restarting application...${NC}"
                kill $TAIL_PID 2>/dev/null
                stop_app
                start_app
                ;;
            3)
                kill $TAIL_PID 2>/dev/null
                cleanup
                ;;
            *)
                echo -e "${RED}Invalid option. Please select 2 or 3${NC}"
                echo -e "${YELLOW}Select an option (2-3):${NC} "
                ;;
        esac
    done
}

# 애플리케이션 중지 함수
stop_app() {
    echo -e "${RED}Stopping PM7 Application...${NC}"
    if [ -f app.pid ]; then
        kill $(cat app.pid) 2>/dev/null
        rm app.pid
    fi
    lsof -i :8081 | grep LISTEN | awk '{print $2}' | xargs -r kill -9 2>/dev/null
    echo -e "${RED}Application has been stopped.${NC}"
    sleep 2
    
    # named pipe 제거
    [ -p "/tmp/spring_app_pipe" ] && rm "/tmp/spring_app_pipe"
}

# 종료 전 정리
cleanup() {
    stop_app
    echo -e "${BLUE}Exiting...${NC}"
    exit 0
}

# Ctrl+C 처리
trap cleanup SIGINT SIGTERM

# Maven wrapper 실행 권한 부여
chmod +x mvnw

# 애플리케이션 바로 시작
start_app 
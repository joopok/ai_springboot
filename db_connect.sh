#!/bin/bash

# 실행 권한 부여 chmod +x db_connect.sh

# MariaDB 접속 정보
HOST="192.168.0.109"  # 1.109에서 0.109로 수정
PORT="3307"
USER="root"
PASSWORD="~Asy10131227"
DATABASE="pms7"

# SQL 쿼리를 실행하는 함수
execute_query() {
    mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DATABASE" -e "$1"
}

# 쿼리 파일을 실행하는 함수
execute_file() {
    mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DATABASE" < "$1"
}

# 대화형 모드로 접속
connect_interactive() {
    mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DATABASE"
}

# 명령행 인자에 따라 실행
case "$1" in
    "-q")
        # 쿼리 실행: ./db_connect.sh -q "SELECT * FROM users;"
        execute_query "$2"
        ;;
    "-f")
        # 파일 실행: ./db_connect.sh -f query.sql
        execute_file "$2"
        ;;
    *)
        # 대화형 모드로 접속
        connect_interactive
        ;;
esac


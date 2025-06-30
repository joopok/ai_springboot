-- ===================================================================
-- PMS7 Database Schema (DDL)
-- MariaDB/MySQL Compatible
-- Created: 2025-07-01
-- Description: Project Management System Version 7 Database Schema
-- ===================================================================

-- Create database with proper charset
CREATE DATABASE IF NOT EXISTS pms7 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE pms7;

-- ===================================================================
-- 1. ROLES TABLE - 사용자 역할 테이블
-- ===================================================================
CREATE TABLE roles (
    role_id INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL COMMENT '역할 이름',
    role_description VARCHAR(255) DEFAULT NULL COMMENT '역할 설명',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자 역할 테이블';

-- ===================================================================
-- 2. USERS TABLE - 사용자 테이블
-- ===================================================================
CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL COMMENT '사용자명',
    username1 VARCHAR(50) NOT NULL COMMENT '사용자영문명',
    email VARCHAR(100) NOT NULL COMMENT '이메일',
    password VARCHAR(255) NOT NULL COMMENT '비밀번호 (해시)',
    role_id INT NOT NULL COMMENT '역할 ID',
    is_active TINYINT(1) DEFAULT 1 COMMENT '활성 상태',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id),
    INDEX role_id (role_id),
    CONSTRAINT users_ibfk_1 FOREIGN KEY (role_id) REFERENCES roles (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자 테이블';

-- ===================================================================
-- 3. CATEGORIES TABLE - 카테고리 테이블
-- ===================================================================
CREATE TABLE categories (
    category_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT DEFAULT NULL,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 4. JOBS TABLE - 채용공고 테이블
-- ===================================================================
CREATE TABLE jobs (
    job_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    salary_range VARCHAR(255) DEFAULT NULL,
    posted_by INT NOT NULL,
    posted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    category_id INT DEFAULT NULL,
    PRIMARY KEY (job_id),
    INDEX posted_by (posted_by),
    INDEX FK_category_id (category_id),
    CONSTRAINT FK_category_id FOREIGN KEY (category_id) REFERENCES categories (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 5. APPLICATIONS TABLE - 지원서 테이블
-- ===================================================================
CREATE TABLE applications (
    application_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    job_id INT NOT NULL,
    cover_letter TEXT DEFAULT NULL,
    status ENUM('pending','approved','rejected') DEFAULT 'pending',
    applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (application_id),
    INDEX user_id (user_id),
    INDEX job_id (job_id),
    CONSTRAINT applications_ibfk_2 FOREIGN KEY (job_id) REFERENCES jobs (job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 6. SESSIONS TABLE - 세션 테이블
-- ===================================================================
CREATE TABLE sessions (
    session_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    session_token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (session_id),
    INDEX user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 7. NOTICES TABLE - 공지사항 테이블
-- ===================================================================
CREATE TABLE notices (
    id BIGINT NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    read_count INT DEFAULT 0,
    author VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_top TINYINT(1) DEFAULT 0,
    login_required TINYINT(1) DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 8. NOTICE_ATTACHMENTS TABLE - 공지사항 첨부파일 테이블
-- ===================================================================
CREATE TABLE notice_attachments (
    id BIGINT NOT NULL AUTO_INCREMENT,
    notice_id BIGINT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX notice_id (notice_id),
    CONSTRAINT notice_attachments_ibfk_1 FOREIGN KEY (notice_id) REFERENCES notices (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 9. EVENTS TABLE - 이벤트 테이블
-- ===================================================================
CREATE TABLE events (
    event_id BIGINT NOT NULL AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT DEFAULT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ===================================================================
-- 10. MENU_TYPES TABLE - 메뉴 타입 테이블
-- ===================================================================
CREATE TABLE menu_types (
    type_id INT NOT NULL AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL COMMENT '메뉴 타입 이름',
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴 타입(카테고리) 테이블';

-- ===================================================================
-- 11. MENUS TABLE - 메뉴 테이블 (1차 메뉴)
-- ===================================================================
CREATE TABLE menus (
    menu_id INT NOT NULL AUTO_INCREMENT,
    type_id INT NOT NULL COMMENT '메뉴 타입 ID',
    menu_name VARCHAR(50) NOT NULL COMMENT '메뉴 이름',
    icon VARCHAR(50) DEFAULT NULL COMMENT '아이콘 이름',
    path VARCHAR(100) DEFAULT NULL COMMENT '경로',
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    is_visible TINYINT(1) DEFAULT 1 COMMENT '표시 여부',
    badge_count INT DEFAULT 0 COMMENT '배지 카운트 (있을 경우)',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_hidden TINYINT(1) DEFAULT 0 COMMENT '메뉴 숨김 여부 (True: 숨김, False: 표시)',
    hide_reason VARCHAR(255) DEFAULT NULL COMMENT '숨김 이유',
    PRIMARY KEY (menu_id),
    INDEX type_id (type_id),
    CONSTRAINT menus_ibfk_1 FOREIGN KEY (type_id) REFERENCES menu_types (type_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴 테이블 (1차 메뉴)';

-- ===================================================================
-- 12. SUB_MENUS TABLE - 서브메뉴 테이블 (2차 메뉴)
-- ===================================================================
CREATE TABLE sub_menus (
    sub_menu_id INT NOT NULL AUTO_INCREMENT,
    menu_id INT NOT NULL COMMENT '상위 메뉴 ID',
    sub_menu_name VARCHAR(50) NOT NULL COMMENT '서브메뉴 이름',
    path VARCHAR(100) NOT NULL COMMENT '경로',
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    is_visible TINYINT(1) DEFAULT 1 COMMENT '표시 여부',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_hidden TINYINT(1) DEFAULT 0 COMMENT '서브메뉴 숨김 여부 (True: 숨김, False: 표시)',
    hide_reason VARCHAR(255) DEFAULT NULL COMMENT '숨김 이유',
    PRIMARY KEY (sub_menu_id),
    INDEX menu_id (menu_id),
    CONSTRAINT sub_menus_ibfk_1 FOREIGN KEY (menu_id) REFERENCES menus (menu_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='서브메뉴 테이블 (2차 메뉴)';

-- ===================================================================
-- 13. MENU_PERMISSIONS TABLE - 메뉴 권한 테이블
-- ===================================================================
CREATE TABLE menu_permissions (
    permission_id INT NOT NULL AUTO_INCREMENT,
    role_id INT NOT NULL COMMENT '역할 ID',
    menu_id INT DEFAULT NULL COMMENT '메뉴 ID',
    sub_menu_id INT DEFAULT NULL COMMENT '서브메뉴 ID',
    can_access TINYINT(1) DEFAULT 0 COMMENT '접근 권한',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (permission_id),
    INDEX menu_id (menu_id),
    INDEX sub_menu_id (sub_menu_id),
    CONSTRAINT menu_permissions_ibfk_1 FOREIGN KEY (menu_id) REFERENCES menus (menu_id) ON DELETE CASCADE,
    CONSTRAINT menu_permissions_ibfk_2 FOREIGN KEY (sub_menu_id) REFERENCES sub_menus (sub_menu_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴 권한 테이블';

-- ===================================================================
-- 14. USER_MENU_CUSTOMIZATIONS TABLE - 사용자별 메뉴 커스터마이징
-- ===================================================================
CREATE TABLE user_menu_customizations (
    customization_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '사용자 ID',
    menu_id INT DEFAULT NULL COMMENT '메뉴 ID',
    sub_menu_id INT DEFAULT NULL COMMENT '서브메뉴 ID',
    is_hidden TINYINT(1) DEFAULT 0 COMMENT '사용자별 숨김 여부',
    display_order INT DEFAULT NULL COMMENT '사용자별 표시 순서',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (customization_id),
    INDEX user_id (user_id),
    INDEX menu_id (menu_id),
    INDEX sub_menu_id (sub_menu_id),
    CONSTRAINT user_menu_customizations_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT user_menu_customizations_ibfk_2 FOREIGN KEY (menu_id) REFERENCES menus (menu_id) ON DELETE CASCADE,
    CONSTRAINT user_menu_customizations_ibfk_3 FOREIGN KEY (sub_menu_id) REFERENCES sub_menus (sub_menu_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자별 메뉴 커스터마이징';

-- ===================================================================
-- 15. USER_MENU_FAVORITES TABLE - 사용자별 메뉴 즐겨찾기
-- ===================================================================
CREATE TABLE user_menu_favorites (
    favorite_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '사용자 ID',
    menu_id INT DEFAULT NULL COMMENT '메뉴 ID',
    sub_menu_id INT DEFAULT NULL COMMENT '서브메뉴 ID',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (favorite_id),
    INDEX user_id (user_id),
    INDEX menu_id (menu_id),
    INDEX sub_menu_id (sub_menu_id),
    CONSTRAINT user_menu_favorites_ibfk_1 FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT user_menu_favorites_ibfk_2 FOREIGN KEY (menu_id) REFERENCES menus (menu_id) ON DELETE CASCADE,
    CONSTRAINT user_menu_favorites_ibfk_3 FOREIGN KEY (sub_menu_id) REFERENCES sub_menus (sub_menu_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자별 메뉴 즐겨찾기';

-- ===================================================================
-- 16. G5_MENU TABLE - G5 메뉴 (레거시)
-- ===================================================================
CREATE TABLE g5_menu (
    me_id INT NOT NULL AUTO_INCREMENT,
    me_code VARCHAR(255) NOT NULL DEFAULT '',
    me_name VARCHAR(255) NOT NULL DEFAULT '',
    me_link VARCHAR(255) NOT NULL DEFAULT '',
    me_target VARCHAR(255) NOT NULL DEFAULT '',
    me_order INT NOT NULL DEFAULT 0,
    me_use TINYINT(4) NOT NULL DEFAULT 0,
    me_mobile_use TINYINT(4) NOT NULL DEFAULT 0,
    PRIMARY KEY (me_id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ===================================================================
-- TRIGGERS - 이벤트 상태 자동 업데이트
-- ===================================================================

-- 이벤트 삽입 시 상태 자동 설정
DELIMITER ;;
CREATE TRIGGER before_event_insert BEFORE INSERT ON events
FOR EACH ROW
BEGIN
    IF NEW.end_date < NOW() THEN
        SET NEW.status = 'FINISHED';
    ELSEIF NEW.start_date <= NOW() AND NEW.end_date >= NOW() THEN
        SET NEW.status = 'IN_PROGRESS';
    ELSE
        SET NEW.status = 'UPCOMING';
    END IF;
END;;

-- 이벤트 업데이트 시 상태 자동 설정
CREATE TRIGGER before_event_update BEFORE UPDATE ON events
FOR EACH ROW
BEGIN
    IF NEW.end_date < NOW() THEN
        SET NEW.status = 'FINISHED';
    ELSEIF NEW.start_date <= NOW() AND NEW.end_date >= NOW() THEN
        SET NEW.status = 'IN_PROGRESS';
    ELSE
        SET NEW.status = 'UPCOMING';
    END IF;
END;;
DELIMITER ;

-- ===================================================================
-- DDL 생성 완료
-- ===================================================================
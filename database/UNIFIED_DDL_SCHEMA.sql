-- =====================================================
-- PM7 PROJECT - UNIFIED DATABASE SCHEMA (DDL)
-- Database: jobtracker
-- Version: 2.0 (통합버전)
-- Created: 2025-01-02
-- Description: MASTER_DATABASE_SCHEMA_ORDERED.sql과 V1_CREATE_SCHEMA.sql의 통합본
-- =====================================================

-- =====================================================
-- DATABASE SETUP
-- =====================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS `jobtracker` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `jobtracker`;

-- Set charset
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- =====================================================
-- DROP EXISTING TABLES (역순 - 외래키 제약 고려)
-- =====================================================

SET FOREIGN_KEY_CHECKS = 0;

-- V1에만 있는 테이블 삭제
DROP TABLE IF EXISTS `project_images`;
DROP TABLE IF EXISTS `project_faqs`;
DROP TABLE IF EXISTS `project_stages`;

-- 프로젝트 관련 추가 테이블 삭제
DROP TABLE IF EXISTS `project_bookmarks`;
DROP TABLE IF EXISTS `project_views`;
DROP TABLE IF EXISTS `project_responsibilities`;
DROP TABLE IF EXISTS `project_requirements`;
DROP TABLE IF EXISTS `project_benefits`;
DROP TABLE IF EXISTS `project_skills`;
DROP TABLE IF EXISTS `project_applications`;

-- 기타 테이블 삭제
DROP TABLE IF EXISTS `search_logs`;
DROP TABLE IF EXISTS `system_settings`;
DROP TABLE IF EXISTS `tags`;
DROP TABLE IF EXISTS `file_uploads`;
DROP TABLE IF EXISTS `user_sessions`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `messages`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `comments`;
DROP TABLE IF EXISTS `community_posts`;
DROP TABLE IF EXISTS `blog_posts`;
DROP TABLE IF EXISTS `portfolios`;
DROP TABLE IF EXISTS `job_postings`;
DROP TABLE IF EXISTS `projects`;
DROP TABLE IF EXISTS `freelancers`;
DROP TABLE IF EXISTS `companies`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 테이블 생성 (의존성 순서대로)
-- =====================================================

-- =====================================================
-- 1. TABLE: users (사용자 기본 테이블) - 독립 테이블
-- Note: V1과 MASTER의 차이점 통합
-- =====================================================

CREATE TABLE `users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL COMMENT '로그인ID',
    `email` VARCHAR(255) NOT NULL COMMENT '이메일',
    `password` VARCHAR(255) NOT NULL COMMENT '비밀번호 (BCrypt)', -- V1: password_hash
    `name` VARCHAR(100) NOT NULL COMMENT '사용자명',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '전화번호',
    `profile_image` VARCHAR(500) DEFAULT NULL COMMENT '프로필 이미지 URL', -- V1: 500자
    `role` VARCHAR(50) NOT NULL DEFAULT 'USER' COMMENT '역할', -- MASTER: ADMIN/PM/DEVELOPER 등, V1: freelancer/client/admin
    `status` ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active' COMMENT '계정 상태', -- V1 추가
    `bio` TEXT DEFAULT NULL COMMENT '자기소개', -- V1 추가
    `location` VARCHAR(100) DEFAULT NULL COMMENT '지역', -- V1 추가
    `website` VARCHAR(255) DEFAULT NULL COMMENT '개인 웹사이트', -- V1 추가
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '활성 상태', -- MASTER only
    `email_verified` BOOLEAN DEFAULT FALSE COMMENT '이메일 인증 여부',
    `last_login` TIMESTAMP NULL DEFAULT NULL COMMENT '마지막 로그인 시간',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_email` (`email`),
    KEY `idx_role` (`role`),
    KEY `idx_status` (`status`), -- V1 추가
    KEY `idx_is_active` (`is_active`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 정보';

-- =====================================================
-- 2. TABLE: categories (카테고리) - 자기 참조 테이블
-- Note: V1에는 없음, MASTER에만 존재
-- =====================================================

CREATE TABLE `categories` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `parent_id` INT DEFAULT NULL COMMENT '상위 카테고리 ID',
    `name` VARCHAR(100) NOT NULL COMMENT '카테고리명',
    `slug` VARCHAR(100) NOT NULL COMMENT 'URL 슬러그',
    `description` TEXT DEFAULT NULL COMMENT '설명',
    `icon` VARCHAR(100) DEFAULT NULL COMMENT '아이콘 클래스명',
    `display_order` INT DEFAULT 0 COMMENT '표시 순서',
    `is_active` BOOLEAN DEFAULT TRUE COMMENT '활성 상태',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_slug` (`slug`),
    KEY `idx_parent_id` (`parent_id`),
    KEY `idx_display_order` (`display_order`),
    CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='카테고리';

-- =====================================================
-- 3. TABLE: companies (기업 정보) - users 테이블 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `companies` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL COMMENT '사용자 ID', -- V1: nullable
    `company_name` VARCHAR(200) NOT NULL COMMENT '회사명', -- MASTER: company_name, V1: name
    `name` VARCHAR(200) GENERATED ALWAYS AS (`company_name`) VIRTUAL COMMENT '회사명 별칭', -- 호환성
    `business_number` VARCHAR(20) DEFAULT NULL COMMENT '사업자등록번호', -- MASTER only
    `ceo_name` VARCHAR(50) DEFAULT NULL COMMENT '대표자명', -- MASTER only
    `description` TEXT DEFAULT NULL COMMENT '회사 소개',
    `industry` VARCHAR(100) DEFAULT NULL COMMENT '업종',
    `company_size` ENUM('startup', 'small', 'medium', 'large', 'enterprise') DEFAULT NULL COMMENT '회사 규모', -- V1 추가
    `employee_count` VARCHAR(50) DEFAULT NULL COMMENT '직원수', -- MASTER only
    `founded_year` INT DEFAULT NULL COMMENT '설립연도',
    `website` VARCHAR(255) DEFAULT NULL COMMENT '웹사이트',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '회사 위치', -- V1 추가
    `address` VARCHAR(255) DEFAULT NULL COMMENT '주소',
    `logo_url` VARCHAR(500) DEFAULT NULL COMMENT '로고 URL', -- V1: 500자
    `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '커버 이미지 URL', -- V1 추가
    `is_verified` BOOLEAN DEFAULT FALSE COMMENT '인증 여부',
    `status` ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT '회사 상태', -- V1 추가
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_id` (`user_id`), -- MASTER only
    KEY `idx_company_name` (`company_name`),
    KEY `idx_industry` (`industry`), -- V1 추가
    KEY `idx_is_verified` (`is_verified`),
    FULLTEXT KEY `ft_search` (`company_name`, `description`), -- V1 추가
    CONSTRAINT `fk_company_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='기업 정보';

-- =====================================================
-- 4. TABLE: freelancers (프리랜서 정보) - users 테이블 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `freelancers` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL COMMENT '사용자 ID',
    `title` VARCHAR(200) NOT NULL COMMENT '전문 분야/직함',
    `description` TEXT DEFAULT NULL COMMENT '상세 소개', -- V1: NOT NULL
    `skills` JSON DEFAULT NULL COMMENT '보유 기술 (JSON 배열)',
    `experience_years` INT DEFAULT 0 COMMENT '경력 년수', -- V1 추가
    `experience_level` ENUM('junior', 'mid', 'senior', 'expert') NOT NULL DEFAULT 'junior' COMMENT '경력 수준',
    `hourly_rate` DECIMAL(10,2) DEFAULT NULL COMMENT '시급 (원)', -- V1: DECIMAL(10,2)
    `availability` ENUM('available', 'busy', 'not_available', 'unavailable') DEFAULT 'available' COMMENT '활동 상태', -- V1: unavailable 추가
    `work_preference` ENUM('remote', 'onsite', 'hybrid', 'all') DEFAULT 'remote' COMMENT '근무 선호도', -- V1: all 추가
    `preferred_work_type` VARCHAR(20) GENERATED ALWAYS AS (`work_preference`) VIRTUAL COMMENT '근무 선호도 별칭', -- 호환성
    `rating` DECIMAL(3,2) DEFAULT 0.00 COMMENT '평점',
    `total_reviews` INT DEFAULT 0 COMMENT '리뷰 수',
    `total_projects` INT DEFAULT 0 COMMENT '완료 프로젝트 수', -- MASTER: total_projects
    `completed_projects` INT GENERATED ALWAYS AS (`total_projects`) VIRTUAL COMMENT '완료 프로젝트 수 별칭', -- V1 호환
    `portfolio_url` VARCHAR(500) DEFAULT NULL COMMENT '포트폴리오 URL', -- V1: 500자
    `github_url` VARCHAR(255) DEFAULT NULL COMMENT 'GitHub URL',
    `linkedin_url` VARCHAR(255) DEFAULT NULL COMMENT 'LinkedIn URL', -- V1 추가
    `bio` TEXT DEFAULT NULL COMMENT '자기소개',
    `is_verified` BOOLEAN DEFAULT FALSE COMMENT '인증 여부',
    `verification_date` TIMESTAMP NULL DEFAULT NULL COMMENT '인증 날짜', -- V1 추가
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_id` (`user_id`),
    KEY `idx_title` (`title`),
    KEY `idx_experience_level` (`experience_level`),
    KEY `idx_hourly_rate` (`hourly_rate`),
    KEY `idx_availability` (`availability`),
    KEY `idx_rating` (`rating` DESC),
    KEY `idx_is_verified` (`is_verified`),
    FULLTEXT KEY `ft_skills` (`skills`),
    FULLTEXT KEY `ft_search` (`title`, `description`), -- V1 추가
    CONSTRAINT `fk_freelancer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프리랜서 정보';

-- =====================================================
-- 5. TABLE: projects (프로젝트/채용공고) - companies, categories 테이블 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `projects` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `company_id` INT DEFAULT NULL COMMENT '회사 ID', -- MASTER: NOT NULL, V1: nullable
    `client_id` INT DEFAULT NULL COMMENT '프로젝트 등록 사용자', -- V1: NOT NULL
    `category_id` INT DEFAULT NULL COMMENT '카테고리 ID', -- MASTER only
    `category` VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 카테고리', -- V1 only
    `title` VARCHAR(300) NOT NULL COMMENT '프로젝트명', -- V1: 300자
    `description` TEXT NOT NULL COMMENT '상세 설명',
    `project_type` ENUM('full_time', 'part_time', 'contract', 'freelance', 'internship') DEFAULT NULL COMMENT '프로젝트 유형',
    `budget_type` ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입', -- V1 추가
    `work_type` ENUM('remote', 'onsite', 'hybrid') DEFAULT 'onsite' COMMENT '근무 형태',
    `location` VARCHAR(255) DEFAULT NULL COMMENT '근무 지역',
    `budget_min` DECIMAL(12,2) DEFAULT NULL COMMENT '최소 예산/연봉', -- V1: DECIMAL(12,2)
    `budget_max` DECIMAL(12,2) DEFAULT NULL COMMENT '최대 예산/연봉',
    `duration` VARCHAR(100) DEFAULT NULL COMMENT '프로젝트 기간', -- MASTER only
    `start_date` DATE DEFAULT NULL COMMENT '시작 예정일', -- V1 추가
    `deadline` DATE DEFAULT NULL COMMENT '마감일',
    `required_skills` JSON DEFAULT NULL COMMENT '필수 기술 (JSON 배열)',
    `preferred_skills` JSON DEFAULT NULL COMMENT '우대 기술 (JSON 배열)', -- MASTER only
    `experience_years` INT DEFAULT 0 COMMENT '요구 경력 연수', -- MASTER only
    `experience_level` ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'mid' COMMENT '요구 경력', -- V1 추가
    `status` ENUM('draft', 'active', 'in_progress', 'closed', 'completed', 'cancelled') DEFAULT 'draft' COMMENT '상태',
    `views` INT DEFAULT 0 COMMENT '조회수',
    `applications` INT DEFAULT 0 COMMENT '지원자수', -- MASTER only
    `applications_count` INT GENERATED ALWAYS AS (`applications`) VIRTUAL COMMENT '지원자수 별칭', -- V1 호환
    `is_featured` BOOLEAN DEFAULT FALSE COMMENT '추천 여부',
    `is_urgent` BOOLEAN DEFAULT FALSE COMMENT '긴급 여부',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_company_id` (`company_id`),
    KEY `idx_client_id` (`client_id`), -- V1 추가
    KEY `idx_category_id` (`category_id`),
    KEY `idx_project_type` (`project_type`),
    KEY `idx_work_type` (`work_type`),
    KEY `idx_status` (`status`),
    KEY `idx_deadline` (`deadline`),
    KEY `idx_is_featured` (`is_featured`),
    KEY `idx_created_at` (`created_at`),
    FULLTEXT KEY `ft_title_description` (`title`, `description`),
    CONSTRAINT `fk_project_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_project_client` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE, -- V1 추가
    CONSTRAINT `fk_project_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트/채용공고';

-- =====================================================
-- 6. TABLE: job_postings (채용공고 - 레거시) - companies 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `job_postings` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `company_id` INT NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `requirements` TEXT,
    `location` VARCHAR(255),
    `salary_min` INT,
    `salary_max` INT,
    `employment_type` ENUM('full_time', 'part_time', 'contract', 'internship'),
    `is_active` BOOLEAN DEFAULT TRUE,
    `expires_at` DATE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_company_id` (`company_id`),
    KEY `idx_is_active` (`is_active`),
    KEY `idx_expires_at` (`expires_at`),
    CONSTRAINT `fk_job_company` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='채용공고';

-- =====================================================
-- 7. TABLE: project_applications (프로젝트 지원) - projects, users 테이블 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `project_applications` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL COMMENT '프로젝트 ID',
    `user_id` INT DEFAULT NULL COMMENT '지원자 ID', -- MASTER: user_id
    `freelancer_id` INT DEFAULT NULL COMMENT '지원한 프리랜서 ID', -- V1: freelancer_id
    `cover_letter` TEXT DEFAULT NULL COMMENT '자기소개서',
    `proposed_budget` DECIMAL(12,2) DEFAULT NULL COMMENT '제안 금액', -- V1 추가
    `expected_rate` INT DEFAULT NULL COMMENT '희망 시급/연봉', -- MASTER only
    `available_date` DATE DEFAULT NULL COMMENT '가능 시작일', -- MASTER only
    `portfolio_url` VARCHAR(255) DEFAULT NULL COMMENT '포트폴리오 URL', -- MASTER only
    `status` ENUM('pending', 'reviewing', 'accepted', 'rejected', 'withdrawn') DEFAULT 'pending' COMMENT '지원 상태',
    `notes` TEXT DEFAULT NULL COMMENT '메모', -- MASTER only
    `applied_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '지원 날짜', -- V1: applied_at
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- MASTER: created_at
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_project_user` (`project_id`, `user_id`), -- MASTER 방식
    UNIQUE KEY `uk_project_freelancer` (`project_id`, `freelancer_id`), -- V1 방식
    KEY `idx_user_id` (`user_id`),
    KEY `idx_freelancer_id` (`freelancer_id`), -- V1 추가
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_application_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_application_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_application_freelancer` FOREIGN KEY (`freelancer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE -- V1 추가
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 지원';

-- =====================================================
-- 8. TABLE: reviews (리뷰/평가) - users, projects 테이블 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `reviews` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `reviewer_id` INT NOT NULL COMMENT '리뷰 작성자 ID',
    `reviewee_id` INT NOT NULL COMMENT '리뷰 대상자 ID',
    `project_id` INT DEFAULT NULL COMMENT '관련 프로젝트 ID',
    `rating` DECIMAL(3,2) NOT NULL CHECK (`rating` BETWEEN 0 AND 5) COMMENT '평점 (0-5)', -- V1: 0.00-5.00
    `comment` TEXT DEFAULT NULL COMMENT '리뷰 내용', -- V1: content
    `content` TEXT GENERATED ALWAYS AS (`comment`) VIRTUAL COMMENT '리뷰 내용 별칭', -- 호환성
    `review_type` ENUM('freelancer_to_client', 'client_to_freelancer') DEFAULT NULL COMMENT '리뷰 타입', -- V1 추가
    `is_visible` BOOLEAN DEFAULT TRUE COMMENT '공개 여부', -- MASTER only
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- MASTER only
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_review` (`project_id`, `reviewer_id`, `reviewee_id`), -- V1 추가
    KEY `idx_reviewer_id` (`reviewer_id`),
    KEY `idx_reviewee_id` (`reviewee_id`),
    KEY `idx_project_id` (`project_id`),
    KEY `idx_rating` (`rating`),
    CONSTRAINT `fk_review_reviewer` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_reviewee` FOREIGN KEY (`reviewee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_review_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE -- V1: ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='리뷰/평가';

-- =====================================================
-- 9. TABLE: messages (메시지) - users, projects 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `messages` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `sender_id` INT NOT NULL COMMENT '발신자 ID',
    `receiver_id` INT NOT NULL COMMENT '수신자 ID',
    `project_id` INT DEFAULT NULL COMMENT '관련 프로젝트 ID',
    `subject` VARCHAR(255) DEFAULT NULL COMMENT '제목',
    `content` TEXT NOT NULL COMMENT '내용',
    `is_read` BOOLEAN DEFAULT FALSE COMMENT '읽음 여부',
    `read_at` TIMESTAMP NULL DEFAULT NULL COMMENT '읽은 시간',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_sender_id` (`sender_id`),
    KEY `idx_receiver_id` (`receiver_id`),
    KEY `idx_project_id` (`project_id`),
    KEY `idx_is_read` (`is_read`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_message_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_message_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_message_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='메시지';

-- =====================================================
-- 10. TABLE: notifications (알림) - users 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `notifications` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL COMMENT '수신자 ID',
    `type` VARCHAR(50) NOT NULL COMMENT '알림 유형',
    `title` VARCHAR(255) NOT NULL COMMENT '제목',
    `message` TEXT DEFAULT NULL COMMENT '내용',
    `link` VARCHAR(255) DEFAULT NULL COMMENT '관련 링크',
    `is_read` BOOLEAN DEFAULT FALSE COMMENT '읽음 여부',
    `read_at` TIMESTAMP NULL DEFAULT NULL COMMENT '읽은 시간',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_type` (`type`),
    KEY `idx_is_read` (`is_read`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='알림';

-- =====================================================
-- 11. TABLE: portfolios (포트폴리오) - users 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `portfolios` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL COMMENT '사용자 ID',
    `title` VARCHAR(255) NOT NULL COMMENT '제목',
    `description` TEXT DEFAULT NULL COMMENT '설명',
    `project_url` VARCHAR(255) DEFAULT NULL COMMENT '프로젝트 URL',
    `image_url` VARCHAR(255) DEFAULT NULL COMMENT '대표 이미지 URL',
    `tags` JSON DEFAULT NULL COMMENT '태그 (JSON 배열)',
    `is_featured` BOOLEAN DEFAULT FALSE COMMENT '대표작품 여부',
    `display_order` INT DEFAULT 0 COMMENT '표시 순서',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_is_featured` (`is_featured`),
    KEY `idx_display_order` (`display_order`),
    CONSTRAINT `fk_portfolio_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='포트폴리오';

-- =====================================================
-- 12. TABLE: blog_posts (블로그 게시글) - users, categories 테이블 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `blog_posts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT DEFAULT NULL COMMENT '작성자 ID', -- MASTER: user_id
    `author_id` INT DEFAULT NULL COMMENT '작성자 ID', -- V1: author_id
    `category_id` INT DEFAULT NULL COMMENT '카테고리 ID', -- MASTER only
    `category` VARCHAR(100) DEFAULT NULL COMMENT '카테고리', -- V1 only
    `title` VARCHAR(300) NOT NULL COMMENT '제목', -- V1: 300자
    `slug` VARCHAR(300) NOT NULL COMMENT 'URL 슬러그', -- V1: UNIQUE
    `content` LONGTEXT NOT NULL COMMENT '내용', -- V1: LONGTEXT
    `excerpt` TEXT DEFAULT NULL COMMENT '요약',
    `featured_image` VARCHAR(500) DEFAULT NULL COMMENT '대표 이미지', -- V1: 500자
    `tags` JSON DEFAULT NULL COMMENT '태그 (JSON 배열)', -- MASTER only
    `status` ENUM('draft', 'published', 'archived') DEFAULT 'draft' COMMENT '상태',
    `views` INT DEFAULT 0 COMMENT '조회수',
    `likes` INT DEFAULT 0 COMMENT '좋아요 수',
    `published_at` TIMESTAMP NULL DEFAULT NULL COMMENT '발행일',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_slug` (`slug`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_author_id` (`author_id`), -- V1 추가
    KEY `idx_category_id` (`category_id`),
    KEY `idx_status` (`status`),
    KEY `idx_status_published` (`status`, `published_at`), -- V1 추가
    KEY `idx_published_at` (`published_at`),
    FULLTEXT KEY `ft_title_content` (`title`, `content`),
    FULLTEXT KEY `ft_search` (`title`, `content`, `excerpt`), -- V1 추가
    CONSTRAINT `fk_blog_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_blog_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE, -- V1 추가
    CONSTRAINT `fk_blog_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='블로그 게시글';

-- =====================================================
-- 13. TABLE: community_posts (커뮤니티 게시글) - users, categories 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `community_posts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL COMMENT '작성자 ID',
    `category_id` INT DEFAULT NULL COMMENT '카테고리 ID',
    `title` VARCHAR(255) NOT NULL COMMENT '제목',
    `content` TEXT NOT NULL COMMENT '내용',
    `post_type` ENUM('question', 'discussion', 'share', 'notice') DEFAULT 'discussion' COMMENT '게시글 유형',
    `is_pinned` BOOLEAN DEFAULT FALSE COMMENT '고정 여부',
    `is_locked` BOOLEAN DEFAULT FALSE COMMENT '잠금 여부',
    `views` INT DEFAULT 0 COMMENT '조회수',
    `likes` INT DEFAULT 0 COMMENT '좋아요 수',
    `comments_count` INT DEFAULT 0 COMMENT '댓글 수',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_category_id` (`category_id`),
    KEY `idx_post_type` (`post_type`),
    KEY `idx_is_pinned` (`is_pinned`),
    KEY `idx_created_at` (`created_at`),
    FULLTEXT KEY `ft_title_content` (`title`, `content`),
    CONSTRAINT `fk_community_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_community_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='커뮤니티 게시글';

-- =====================================================
-- 14. TABLE: comments (댓글) - users 테이블 참조, 자기 참조
-- Note: 두 버전의 스키마 통합
-- =====================================================

CREATE TABLE `comments` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT DEFAULT NULL COMMENT '작성자 ID', -- MASTER: user_id
    `author_id` INT DEFAULT NULL COMMENT '작성자 ID', -- V1: author_id
    `commentable_type` VARCHAR(50) DEFAULT NULL COMMENT '댓글 대상 유형', -- MASTER only
    `commentable_id` INT DEFAULT NULL COMMENT '댓글 대상 ID', -- MASTER only
    `post_id` INT DEFAULT NULL COMMENT '게시물 ID', -- V1 only
    `post_type` ENUM('blog', 'project') DEFAULT NULL COMMENT '게시물 타입', -- V1 only
    `parent_id` INT DEFAULT NULL COMMENT '부모 댓글 ID',
    `content` TEXT NOT NULL COMMENT '내용',
    `likes` INT DEFAULT 0 COMMENT '좋아요 수', -- MASTER only
    `is_deleted` BOOLEAN DEFAULT FALSE COMMENT '삭제 여부', -- MASTER only
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_author_id` (`author_id`), -- V1 추가
    KEY `idx_commentable` (`commentable_type`, `commentable_id`), -- MASTER only
    KEY `idx_post` (`post_id`, `post_type`), -- V1 추가
    KEY `idx_parent_id` (`parent_id`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_comment_author` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE CASCADE, -- V1 추가
    CONSTRAINT `fk_comment_parent` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='댓글';

-- =====================================================
-- 15. TABLE: user_sessions (사용자 세션) - users 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `user_sessions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `session_token` VARCHAR(255) NOT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `user_agent` TEXT DEFAULT NULL,
    `expires_at` TIMESTAMP NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_session_token` (`session_token`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_expires_at` (`expires_at`),
    CONSTRAINT `fk_session_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 세션';

-- =====================================================
-- 16. TABLE: file_uploads (파일 업로드) - users 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `file_uploads` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `file_path` VARCHAR(500) NOT NULL,
    `file_type` VARCHAR(100) DEFAULT NULL,
    `file_size` INT DEFAULT NULL,
    `entity_type` VARCHAR(50) DEFAULT NULL,
    `entity_id` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_entity` (`entity_type`, `entity_id`),
    CONSTRAINT `fk_upload_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='파일 업로드';

-- =====================================================
-- 17. TABLE: tags (태그) - 독립 테이블
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `tags` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `slug` VARCHAR(50) NOT NULL,
    `usage_count` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`),
    UNIQUE KEY `uk_slug` (`slug`),
    KEY `idx_usage_count` (`usage_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='태그';

-- =====================================================
-- 18. TABLE: system_settings (시스템 설정) - 독립 테이블
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `system_settings` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `setting_key` VARCHAR(100) NOT NULL,
    `setting_value` TEXT DEFAULT NULL,
    `setting_type` VARCHAR(50) DEFAULT 'string',
    `description` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='시스템 설정';

-- =====================================================
-- 19. TABLE: search_logs (검색 로그) - users 테이블 참조
-- Note: MASTER에만 존재
-- =====================================================

CREATE TABLE `search_logs` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT DEFAULT NULL,
    `search_query` VARCHAR(255) NOT NULL,
    `search_type` VARCHAR(50) DEFAULT NULL,
    `results_count` INT DEFAULT 0,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_search_query` (`search_query`),
    KEY `idx_created_at` (`created_at`),
    CONSTRAINT `fk_search_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='검색 로그';

-- =====================================================
-- ADDITIONAL TABLES FOR PROJECTS (projects 테이블 의존)
-- Note: MASTER에만 존재
-- =====================================================

-- 20. TABLE: project_skills (프로젝트 필요 기술) - projects 테이블 참조
CREATE TABLE `project_skills` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `skill_name` VARCHAR(100) NOT NULL,
    `skill_level` ENUM('beginner', 'intermediate', 'advanced', 'expert') DEFAULT 'intermediate',
    `is_required` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (`id`),
    KEY `idx_project_id` (`project_id`),
    KEY `idx_skill_name` (`skill_name`),
    CONSTRAINT `fk_project_skill` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 필요 기술';

-- 21. TABLE: project_benefits (프로젝트 혜택) - projects 테이블 참조
CREATE TABLE `project_benefits` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `benefit` VARCHAR(255) NOT NULL,
    `display_order` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_project_id` (`project_id`),
    CONSTRAINT `fk_project_benefit` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 혜택';

-- 22. TABLE: project_requirements (프로젝트 요구사항) - projects 테이블 참조
CREATE TABLE `project_requirements` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `requirement` TEXT NOT NULL,
    `display_order` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_project_id` (`project_id`),
    CONSTRAINT `fk_project_requirement` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 요구사항';

-- 23. TABLE: project_responsibilities (프로젝트 책임사항) - projects 테이블 참조
CREATE TABLE `project_responsibilities` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `responsibility` TEXT NOT NULL,
    `display_order` INT DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_project_id` (`project_id`),
    CONSTRAINT `fk_project_responsibility` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 책임사항';

-- 24. TABLE: project_views (프로젝트 조회 기록) - projects, users 테이블 참조
CREATE TABLE `project_views` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `user_id` INT DEFAULT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `viewed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_project_id` (`project_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_viewed_at` (`viewed_at`),
    CONSTRAINT `fk_view_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_view_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 조회 기록';

-- 25. TABLE: project_bookmarks (프로젝트 북마크) - projects, users 테이블 참조
CREATE TABLE `project_bookmarks` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT NOT NULL,
    `user_id` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_project_user` (`project_id`, `user_id`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_bookmark_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_bookmark_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='프로젝트 북마크';

-- =====================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =====================================================

-- Composite indexes for common queries
CREATE INDEX `idx_users_composite` ON `users` (`role`, `is_active`, `created_at`);
CREATE INDEX `idx_freelancers_composite` ON `freelancers` (`availability`, `rating` DESC);
CREATE INDEX `idx_projects_composite` ON `projects` (`status`, `project_type`, `created_at` DESC);

-- =====================================================
-- UNIFIED DDL SCHEMA COMPLETE
-- =====================================================
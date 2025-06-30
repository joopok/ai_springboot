-- ===================================================================
-- JobKorea Billboard - Complete Database Schema (DDL)
-- MariaDB/MySQL Compatible
-- Created: 2024
-- ===================================================================

-- Create database with proper charset
CREATE DATABASE IF NOT EXISTS jobtracker 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE jobtracker;

-- ===================================================================
-- 1. USERS TABLE - 사용자 기본 정보
-- ===================================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL COMMENT '사용자명 (로그인용)',
    email VARCHAR(255) UNIQUE NOT NULL COMMENT '이메일 주소',
    password_hash VARCHAR(255) NOT NULL COMMENT '암호화된 비밀번호',
    full_name VARCHAR(100) NOT NULL COMMENT '실명',
    phone VARCHAR(20) COMMENT '연락처',
    profile_image VARCHAR(500) COMMENT '프로필 이미지 URL',
    
    -- 사용자 역할 및 상태
    role ENUM('freelancer', 'client', 'admin') DEFAULT 'freelancer' COMMENT '사용자 역할',
    status ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active' COMMENT '계정 상태',
    email_verified BOOLEAN DEFAULT FALSE COMMENT '이메일 인증 여부',
    
    -- 추가 정보
    bio TEXT COMMENT '자기소개',
    location VARCHAR(100) COMMENT '지역',
    website VARCHAR(255) COMMENT '개인 웹사이트',
    
    -- 시스템 정보
    last_login TIMESTAMP NULL COMMENT '마지막 로그인',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    
    -- 인덱스
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role_status (role, status),
    INDEX idx_created_at (created_at),
    FULLTEXT idx_search (full_name, bio)
) COMMENT='사용자 기본 정보';

-- ===================================================================
-- 2. FREELANCERS TABLE - 프리랜서 전문 정보
-- ===================================================================
CREATE TABLE freelancers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL COMMENT '사용자 ID',
    
    -- 전문 정보
    title VARCHAR(200) NOT NULL COMMENT '전문 분야 제목',
    description TEXT NOT NULL COMMENT '상세 소개',
    skills JSON NOT NULL COMMENT '보유 기술 스택',
    experience_years INT DEFAULT 0 COMMENT '경력 년수',
    experience_level ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'junior' COMMENT '경력 수준',
    
    -- 업무 정보
    hourly_rate DECIMAL(10,2) COMMENT '시간당 요율 (원)',
    availability ENUM('available', 'busy', 'unavailable') DEFAULT 'available' COMMENT '업무 가능 여부',
    preferred_work_type ENUM('remote', 'onsite', 'hybrid', 'all') DEFAULT 'all' COMMENT '선호 근무 형태',
    
    -- 포트폴리오 및 링크
    portfolio_url VARCHAR(500) COMMENT '포트폴리오 웹사이트',
    github_url VARCHAR(255) COMMENT 'GitHub URL',
    linkedin_url VARCHAR(255) COMMENT 'LinkedIn URL',
    
    -- 평가 정보
    rating DECIMAL(3,2) DEFAULT 0.00 COMMENT '평균 평점',
    total_reviews INT DEFAULT 0 COMMENT '총 리뷰 수',
    completed_projects INT DEFAULT 0 COMMENT '완료한 프로젝트 수',
    
    -- 인증 정보
    is_verified BOOLEAN DEFAULT FALSE COMMENT '인증된 프리랜서 여부',
    verification_date TIMESTAMP NULL COMMENT '인증 날짜',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_experience_level (experience_level),
    INDEX idx_availability (availability),
    INDEX idx_rating (rating DESC),
    INDEX idx_hourly_rate (hourly_rate),
    INDEX idx_verified (is_verified),
    FULLTEXT idx_search (title, description)
) COMMENT='프리랜서 전문 정보';

-- ===================================================================
-- 3. COMPANIES TABLE - 회사 정보
-- ===================================================================
CREATE TABLE companies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT COMMENT '대표 사용자 ID',
    
    -- 회사 기본 정보
    name VARCHAR(200) NOT NULL COMMENT '회사명',
    description TEXT COMMENT '회사 소개',
    industry VARCHAR(100) COMMENT '업종',
    company_size ENUM('startup', 'small', 'medium', 'large', 'enterprise') COMMENT '회사 규모',
    founded_year INT COMMENT '설립연도',
    
    -- 연락 정보
    website VARCHAR(255) COMMENT '회사 웹사이트',
    location VARCHAR(200) COMMENT '회사 위치',
    address TEXT COMMENT '상세 주소',
    
    -- 미디어
    logo_url VARCHAR(500) COMMENT '회사 로고 URL',
    cover_image VARCHAR(500) COMMENT '커버 이미지 URL',
    
    -- 인증 및 상태
    is_verified BOOLEAN DEFAULT FALSE COMMENT '인증된 회사 여부',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active' COMMENT '회사 상태',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_industry (industry),
    INDEX idx_company_size (company_size),
    INDEX idx_location (location),
    INDEX idx_verified (is_verified),
    FULLTEXT idx_search (name, description)
) COMMENT='회사 정보';

-- ===================================================================
-- 4. PROJECTS TABLE - 프리랜서 프로젝트
-- ===================================================================
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 기본 정보
    title VARCHAR(300) NOT NULL COMMENT '프로젝트 제목',
    description TEXT NOT NULL COMMENT '프로젝트 상세 설명',
    category VARCHAR(100) NOT NULL COMMENT '프로젝트 카테고리',
    subcategory VARCHAR(100) COMMENT '세부 카테고리',
    
    -- 예산 정보
    budget_type ENUM('fixed', 'hourly', 'negotiable') DEFAULT 'fixed' COMMENT '예산 타입',
    budget_min DECIMAL(12,2) COMMENT '최소 예산',
    budget_max DECIMAL(12,2) COMMENT '최대 예산',
    currency VARCHAR(3) DEFAULT 'KRW' COMMENT '통화',
    
    -- 기간 정보
    duration_type ENUM('hours', 'days', 'weeks', 'months') DEFAULT 'weeks' COMMENT '기간 단위',
    duration_value INT COMMENT '기간 값',
    start_date DATE COMMENT '시작 예정일',
    deadline DATE COMMENT '마감일',
    
    -- 업무 조건
    work_type ENUM('remote', 'onsite', 'hybrid') DEFAULT 'remote' COMMENT '근무 형태',
    experience_level ENUM('junior', 'mid', 'senior', 'expert') DEFAULT 'mid' COMMENT '요구 경력',
    required_skills JSON NOT NULL COMMENT '필요 기술 스택',
    optional_skills JSON COMMENT '우대 기술 스택',
    
    -- 클라이언트 정보
    client_id INT NOT NULL COMMENT '프로젝트 등록 사용자',
    company_id INT COMMENT '회사 ID (선택사항)',
    
    -- 상태 관리
    status ENUM('draft', 'active', 'in_progress', 'completed', 'cancelled', 'paused') DEFAULT 'draft' COMMENT '프로젝트 상태',
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' COMMENT '우선순위',
    
    -- 통계
    views INT DEFAULT 0 COMMENT '조회수',
    applications_count INT DEFAULT 0 COMMENT '지원자 수',
    
    -- 기능
    is_featured BOOLEAN DEFAULT FALSE COMMENT '추천 프로젝트 여부',
    is_urgent BOOLEAN DEFAULT FALSE COMMENT '급구 여부',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE SET NULL,
    INDEX idx_category (category),
    INDEX idx_work_type (work_type),
    INDEX idx_experience_level (experience_level),
    INDEX idx_status (status),
    INDEX idx_client_id (client_id),
    INDEX idx_budget (budget_min, budget_max),
    INDEX idx_deadline (deadline),
    INDEX idx_featured (is_featured),
    INDEX idx_created_at (created_at DESC),
    FULLTEXT idx_search (title, description)
) COMMENT='프리랜서 프로젝트';

-- ===================================================================
-- 5. PROJECT_APPLICATIONS TABLE - 프로젝트 지원
-- ===================================================================
CREATE TABLE project_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL COMMENT '프로젝트 ID',
    freelancer_id INT NOT NULL COMMENT '지원한 프리랜서 ID',
    
    -- 지원 내용
    cover_letter TEXT COMMENT '지원 메시지',
    proposed_budget DECIMAL(12,2) COMMENT '제안 금액',
    proposed_timeline VARCHAR(200) COMMENT '제안 일정',
    portfolio_items JSON COMMENT '관련 포트폴리오 아이템',
    
    -- 상태 관리
    status ENUM('pending', 'accepted', 'rejected', 'withdrawn', 'shortlisted') DEFAULT 'pending' COMMENT '지원 상태',
    
    -- 클라이언트 피드백
    client_notes TEXT COMMENT '클라이언트 메모',
    
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '지원 날짜',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (project_id, freelancer_id),
    INDEX idx_project_id (project_id),
    INDEX idx_freelancer_id (freelancer_id),
    INDEX idx_status (status),
    INDEX idx_applied_at (applied_at DESC)
) COMMENT='프로젝트 지원';

-- ===================================================================
-- 6. JOB_POSTINGS TABLE - 채용 공고
-- ===================================================================
CREATE TABLE job_postings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 기본 정보
    title VARCHAR(300) NOT NULL COMMENT '채용 제목',
    description TEXT NOT NULL COMMENT '채용 상세 설명',
    department VARCHAR(100) COMMENT '부서',
    position_level ENUM('intern', 'junior', 'mid', 'senior', 'lead', 'manager', 'director') COMMENT '직급',
    
    -- 고용 조건
    employment_type ENUM('full_time', 'part_time', 'contract', 'internship', 'temporary') NOT NULL COMMENT '고용 형태',
    work_type ENUM('remote', 'onsite', 'hybrid') DEFAULT 'onsite' COMMENT '근무 형태',
    
    -- 급여 정보
    salary_type ENUM('annual', 'monthly', 'hourly') DEFAULT 'annual' COMMENT '급여 타입',
    salary_min DECIMAL(12,2) COMMENT '최소 급여',
    salary_max DECIMAL(12,2) COMMENT '최대 급여',
    currency VARCHAR(3) DEFAULT 'KRW' COMMENT '통화',
    salary_negotiable BOOLEAN DEFAULT FALSE COMMENT '급여 협의 가능',
    
    -- 위치 정보
    location VARCHAR(200) COMMENT '근무 지역',
    address TEXT COMMENT '상세 주소',
    
    -- 요구사항
    required_skills JSON COMMENT '필수 기술',
    preferred_skills JSON COMMENT '우대 기술',
    education_level ENUM('high_school', 'associate', 'bachelor', 'master', 'phd', 'none') COMMENT '학력 요구사항',
    experience_years_min INT DEFAULT 0 COMMENT '최소 경력',
    experience_years_max INT COMMENT '최대 경력',
    
    -- 복리후생
    benefits JSON COMMENT '복리후생',
    
    -- 회사 정보
    company_id INT NOT NULL COMMENT '회사 ID',
    recruiter_id INT NOT NULL COMMENT '채용 담당자',
    
    -- 채용 일정
    application_deadline DATE COMMENT '지원 마감일',
    start_date DATE COMMENT '입사 예정일',
    
    -- 상태 관리
    status ENUM('draft', 'active', 'closed', 'cancelled') DEFAULT 'draft' COMMENT '채용 상태',
    views INT DEFAULT 0 COMMENT '조회수',
    applications_count INT DEFAULT 0 COMMENT '지원자 수',
    
    is_featured BOOLEAN DEFAULT FALSE COMMENT '추천 채용 여부',
    is_urgent BOOLEAN DEFAULT FALSE COMMENT '급구 여부',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE,
    FOREIGN KEY (recruiter_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_employment_type (employment_type),
    INDEX idx_work_type (work_type),
    INDEX idx_position_level (position_level),
    INDEX idx_company_id (company_id),
    INDEX idx_location (location),
    INDEX idx_salary (salary_min, salary_max),
    INDEX idx_deadline (application_deadline),
    INDEX idx_status (status),
    INDEX idx_featured (is_featured),
    FULLTEXT idx_search (title, description)
) COMMENT='채용 공고';

-- ===================================================================
-- 7. BLOG_POSTS TABLE - 블로그 게시물
-- ===================================================================
CREATE TABLE blog_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 기본 정보
    title VARCHAR(300) NOT NULL COMMENT '제목',
    slug VARCHAR(300) UNIQUE NOT NULL COMMENT 'URL 슬러그',
    content LONGTEXT NOT NULL COMMENT '본문 내용',
    excerpt TEXT COMMENT '요약',
    
    -- 카테고리 및 태그
    category VARCHAR(100) NOT NULL COMMENT '카테고리',
    subcategory VARCHAR(100) COMMENT '세부 카테고리',
    tags JSON COMMENT '태그 배열',
    
    -- 작성자 정보
    author_id INT NOT NULL COMMENT '작성자 ID',
    
    -- 미디어
    featured_image VARCHAR(500) COMMENT '대표 이미지 URL',
    images JSON COMMENT '본문 이미지 배열',
    
    -- 상태 관리
    status ENUM('draft', 'published', 'archived', 'deleted') DEFAULT 'draft' COMMENT '게시 상태',
    
    -- 통계
    views INT DEFAULT 0 COMMENT '조회수',
    likes INT DEFAULT 0 COMMENT '좋아요 수',
    comments_count INT DEFAULT 0 COMMENT '댓글 수',
    shares INT DEFAULT 0 COMMENT '공유 수',
    
    -- SEO
    meta_title VARCHAR(200) COMMENT 'SEO 제목',
    meta_description TEXT COMMENT 'SEO 설명',
    meta_keywords VARCHAR(500) COMMENT 'SEO 키워드',
    
    -- 기능
    is_featured BOOLEAN DEFAULT FALSE COMMENT '추천 글 여부',
    allow_comments BOOLEAN DEFAULT TRUE COMMENT '댓글 허용 여부',
    
    -- 일정
    published_at TIMESTAMP NULL COMMENT '발행 날짜',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_category (category),
    INDEX idx_status_published (status, published_at),
    INDEX idx_author_id (author_id),
    INDEX idx_published_at (published_at DESC),
    INDEX idx_views (views DESC),
    INDEX idx_likes (likes DESC),
    INDEX idx_featured (is_featured),
    FULLTEXT idx_search (title, content, excerpt, meta_title, meta_description)
) COMMENT='블로그 게시물';

-- ===================================================================
-- 8. COMMUNITY_POSTS TABLE - 커뮤니티 게시물
-- ===================================================================
CREATE TABLE community_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 기본 정보
    title VARCHAR(300) NOT NULL COMMENT '제목',
    content TEXT NOT NULL COMMENT '내용',
    
    -- 카테고리
    category ENUM('free', 'qna', 'study', 'project_review', 'share', 'gallery', 'notice') NOT NULL COMMENT '게시판 카테고리',
    
    -- 작성자
    author_id INT NOT NULL COMMENT '작성자 ID',
    
    -- 첨부파일
    attachments JSON COMMENT '첨부파일 정보',
    images JSON COMMENT '이미지 배열',
    
    -- 상태 관리
    status ENUM('published', 'draft', 'deleted', 'blocked') DEFAULT 'published' COMMENT '게시 상태',
    
    -- 통계
    views INT DEFAULT 0 COMMENT '조회수',
    likes INT DEFAULT 0 COMMENT '좋아요 수',
    dislikes INT DEFAULT 0 COMMENT '싫어요 수',
    comments_count INT DEFAULT 0 COMMENT '댓글 수',
    
    -- 기능
    is_pinned BOOLEAN DEFAULT FALSE COMMENT '상단 고정 여부',
    is_locked BOOLEAN DEFAULT FALSE COMMENT '댓글 잠금 여부',
    is_anonymous BOOLEAN DEFAULT FALSE COMMENT '익명 게시 여부',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_category (category),
    INDEX idx_author_id (author_id),
    INDEX idx_status (status),
    INDEX idx_pinned_created (is_pinned DESC, created_at DESC),
    INDEX idx_views (views DESC),
    INDEX idx_likes (likes DESC),
    FULLTEXT idx_search (title, content)
) COMMENT='커뮤니티 게시물';

-- ===================================================================
-- 9. COMMENTS TABLE - 댓글
-- ===================================================================
CREATE TABLE comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 댓글 내용
    content TEXT NOT NULL COMMENT '댓글 내용',
    
    -- 연관 정보
    post_id INT NOT NULL COMMENT '게시물 ID',
    post_type ENUM('blog', 'community', 'project', 'job') NOT NULL COMMENT '게시물 타입',
    author_id INT NOT NULL COMMENT '작성자 ID',
    
    -- 대댓글 구조
    parent_id INT NULL COMMENT '부모 댓글 ID',
    depth INT DEFAULT 0 COMMENT '댓글 깊이',
    
    -- 상태 관리
    status ENUM('published', 'pending', 'deleted', 'blocked') DEFAULT 'published' COMMENT '댓글 상태',
    
    -- 통계
    likes INT DEFAULT 0 COMMENT '좋아요 수',
    dislikes INT DEFAULT 0 COMMENT '싫어요 수',
    
    -- 기능
    is_anonymous BOOLEAN DEFAULT FALSE COMMENT '익명 댓글 여부',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES comments(id) ON DELETE CASCADE,
    INDEX idx_post (post_id, post_type),
    INDEX idx_author_id (author_id),
    INDEX idx_parent_id (parent_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    FULLTEXT idx_search (content)
) COMMENT='댓글';

-- ===================================================================
-- 10. REVIEWS TABLE - 리뷰 및 평가
-- ===================================================================
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 리뷰 대상
    project_id INT COMMENT '프로젝트 ID',
    reviewer_id INT NOT NULL COMMENT '리뷰 작성자',
    reviewee_id INT NOT NULL COMMENT '리뷰 대상자',
    
    -- 리뷰 내용
    title VARCHAR(200) COMMENT '리뷰 제목',
    content TEXT COMMENT '리뷰 내용',
    
    -- 평가
    overall_rating DECIMAL(3,2) NOT NULL CHECK (overall_rating >= 0.00 AND overall_rating <= 5.00) COMMENT '전체 평점',
    communication_rating DECIMAL(3,2) CHECK (communication_rating >= 0.00 AND communication_rating <= 5.00) COMMENT '소통 평점',
    quality_rating DECIMAL(3,2) CHECK (quality_rating >= 0.00 AND quality_rating <= 5.00) COMMENT '품질 평점',
    timeline_rating DECIMAL(3,2) CHECK (timeline_rating >= 0.00 AND timeline_rating <= 5.00) COMMENT '일정 준수 평점',
    
    -- 리뷰 타입
    review_type ENUM('freelancer_to_client', 'client_to_freelancer') NOT NULL COMMENT '리뷰 타입',
    
    -- 상태 관리
    status ENUM('published', 'pending', 'deleted') DEFAULT 'published' COMMENT '리뷰 상태',
    is_public BOOLEAN DEFAULT TRUE COMMENT '공개 여부',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_review (project_id, reviewer_id, reviewee_id),
    INDEX idx_reviewee_public (reviewee_id, is_public),
    INDEX idx_overall_rating (overall_rating DESC),
    INDEX idx_created_at (created_at DESC)
) COMMENT='리뷰 및 평가';

-- ===================================================================
-- 11. PORTFOLIOS TABLE - 포트폴리오
-- ===================================================================
CREATE TABLE portfolios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT '포트폴리오 소유자',
    
    -- 기본 정보
    title VARCHAR(300) NOT NULL COMMENT '프로젝트 제목',
    description TEXT NOT NULL COMMENT '프로젝트 설명',
    category VARCHAR(100) COMMENT '프로젝트 카테고리',
    
    -- 기술 정보
    technologies JSON COMMENT '사용 기술',
    role VARCHAR(200) COMMENT '담당 역할',
    
    -- 링크 및 미디어
    project_url VARCHAR(500) COMMENT '프로젝트 URL',
    github_url VARCHAR(500) COMMENT 'GitHub URL',
    demo_url VARCHAR(500) COMMENT '데모 URL',
    images JSON COMMENT '프로젝트 이미지들',
    video_url VARCHAR(500) COMMENT '프로젝트 영상',
    
    -- 프로젝트 정보
    client_name VARCHAR(200) COMMENT '클라이언트명',
    project_duration VARCHAR(100) COMMENT '프로젝트 기간',
    team_size INT COMMENT '팀 규모',
    
    -- 성과
    achievements JSON COMMENT '주요 성과',
    metrics JSON COMMENT '성과 지표',
    
    -- 상태 관리
    status ENUM('published', 'draft', 'archived') DEFAULT 'draft' COMMENT '공개 상태',
    is_featured BOOLEAN DEFAULT FALSE COMMENT '대표 작품 여부',
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    
    -- 일정
    completion_date DATE COMMENT '완료 날짜',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_status (user_id, status),
    INDEX idx_category (category),
    INDEX idx_featured (is_featured),
    INDEX idx_display_order (display_order),
    FULLTEXT idx_search (title, description)
) COMMENT='포트폴리오';

-- ===================================================================
-- 12. MESSAGES TABLE - 메시지 시스템
-- ===================================================================
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 메시지 참여자
    sender_id INT NOT NULL COMMENT '발신자 ID',
    receiver_id INT NOT NULL COMMENT '수신자 ID',
    
    -- 메시지 내용
    subject VARCHAR(300) COMMENT '제목',
    content TEXT NOT NULL COMMENT '메시지 내용',
    
    -- 연관 정보
    project_id INT COMMENT '관련 프로젝트 ID',
    job_id INT COMMENT '관련 채용공고 ID',
    
    -- 메시지 타입
    message_type ENUM('direct', 'project_inquiry', 'application', 'system', 'notification') DEFAULT 'direct' COMMENT '메시지 타입',
    
    -- 대화 스레드
    thread_id VARCHAR(100) COMMENT '대화 스레드 ID',
    parent_id INT COMMENT '답장 대상 메시지',
    
    -- 상태 관리
    status ENUM('sent', 'delivered', 'read', 'deleted') DEFAULT 'sent' COMMENT '메시지 상태',
    is_read BOOLEAN DEFAULT FALSE COMMENT '읽음 여부',
    read_at TIMESTAMP NULL COMMENT '읽은 시간',
    
    -- 첨부파일
    attachments JSON COMMENT '첨부파일 정보',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES job_postings(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES messages(id) ON DELETE CASCADE,
    INDEX idx_receiver_read (receiver_id, is_read),
    INDEX idx_sender_id (sender_id),
    INDEX idx_thread_id (thread_id),
    INDEX idx_project_id (project_id),
    INDEX idx_created_at (created_at DESC)
) COMMENT='메시지 시스템';

-- ===================================================================
-- 13. NOTIFICATIONS TABLE - 알림
-- ===================================================================
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT '알림 대상 사용자',
    
    -- 알림 내용
    title VARCHAR(300) NOT NULL COMMENT '알림 제목',
    message TEXT NOT NULL COMMENT '알림 내용',
    
    -- 알림 타입
    type ENUM('project_application', 'project_update', 'message', 'review', 'payment', 'system', 'marketing') NOT NULL COMMENT '알림 타입',
    priority ENUM('low', 'normal', 'high', 'urgent') DEFAULT 'normal' COMMENT '우선순위',
    
    -- 연관 정보
    reference_type VARCHAR(50) COMMENT '참조 타입',
    reference_id INT COMMENT '참조 ID',
    action_url VARCHAR(500) COMMENT '액션 URL',
    
    -- 상태 관리
    is_read BOOLEAN DEFAULT FALSE COMMENT '읽음 여부',
    read_at TIMESTAMP NULL COMMENT '읽은 시간',
    
    -- 발송 설정
    send_email BOOLEAN DEFAULT TRUE COMMENT '이메일 발송 여부',
    send_push BOOLEAN DEFAULT TRUE COMMENT '푸시 알림 여부',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_unread (user_id, is_read),
    INDEX idx_type (type),
    INDEX idx_priority (priority),
    INDEX idx_created_at (created_at DESC)
) COMMENT='알림';

-- ===================================================================
-- 14. USER_SESSIONS TABLE - 사용자 세션
-- ===================================================================
CREATE TABLE user_sessions (
    id VARCHAR(255) PRIMARY KEY COMMENT '세션 ID',
    user_id INT NOT NULL COMMENT '사용자 ID',
    
    -- 세션 정보
    ip_address VARCHAR(45) COMMENT 'IP 주소',
    user_agent TEXT COMMENT '사용자 에이전트',
    device_type ENUM('desktop', 'mobile', 'tablet', 'unknown') DEFAULT 'unknown' COMMENT '기기 타입',
    browser VARCHAR(100) COMMENT '브라우저',
    os VARCHAR(100) COMMENT '운영체제',
    
    -- 위치 정보
    country VARCHAR(100) COMMENT '국가',
    city VARCHAR(100) COMMENT '도시',
    
    -- 세션 상태
    is_active BOOLEAN DEFAULT TRUE COMMENT '활성 세션 여부',
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '마지막 활동',
    expires_at TIMESTAMP NOT NULL COMMENT '만료 시간',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_active (user_id, is_active),
    INDEX idx_expires_at (expires_at),
    INDEX idx_last_activity (last_activity)
) COMMENT='사용자 세션';

-- ===================================================================
-- 15. FILE_UPLOADS TABLE - 파일 업로드
-- ===================================================================
CREATE TABLE file_uploads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    
    -- 파일 정보
    filename VARCHAR(255) NOT NULL COMMENT '저장된 파일명',
    original_name VARCHAR(255) NOT NULL COMMENT '원본 파일명',
    file_path VARCHAR(500) NOT NULL COMMENT '파일 경로',
    file_size BIGINT NOT NULL COMMENT '파일 크기 (bytes)',
    mime_type VARCHAR(100) NOT NULL COMMENT 'MIME 타입',
    file_extension VARCHAR(10) COMMENT '파일 확장자',
    
    -- 업로더 정보
    uploader_id INT NOT NULL COMMENT '업로드한 사용자',
    
    -- 연관 정보
    entity_type ENUM('user', 'project', 'job', 'blog', 'community', 'portfolio', 'company') NOT NULL COMMENT '연관 엔티티 타입',
    entity_id INT NOT NULL COMMENT '연관 엔티티 ID',
    
    -- 파일 타입
    file_category ENUM('profile_image', 'cover_image', 'attachment', 'portfolio_image', 'blog_image', 'logo') COMMENT '파일 카테고리',
    
    -- 이미지 정보 (이미지인 경우)
    width INT COMMENT '이미지 너비',
    height INT COMMENT '이미지 높이',
    
    -- 상태 관리
    status ENUM('active', 'deleted') DEFAULT 'active' COMMENT '파일 상태',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_uploader_id (uploader_id),
    INDEX idx_entity (entity_type, entity_id),
    INDEX idx_file_category (file_category),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) COMMENT='파일 업로드';

-- ===================================================================
-- 16. TAGS TABLE - 태그 관리
-- ===================================================================
CREATE TABLE tags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL COMMENT '태그명',
    slug VARCHAR(100) UNIQUE NOT NULL COMMENT 'URL 슬러그',
    description TEXT COMMENT '태그 설명',
    color VARCHAR(7) COMMENT '태그 색상 (HEX)',
    
    -- 통계
    usage_count INT DEFAULT 0 COMMENT '사용 횟수',
    
    -- 카테고리별 분류
    category ENUM('technology', 'skill', 'industry', 'location', 'general') DEFAULT 'general' COMMENT '태그 카테고리',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_category (category),
    INDEX idx_usage_count (usage_count DESC),
    FULLTEXT idx_search (name, description)
) COMMENT='태그 관리';

-- ===================================================================
-- 17. SEARCH_LOGS TABLE - 검색 로그
-- ===================================================================
CREATE TABLE search_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT COMMENT '검색한 사용자 (비로그인 시 NULL)',
    
    -- 검색 정보
    search_query VARCHAR(500) NOT NULL COMMENT '검색어',
    search_type ENUM('projects', 'jobs', 'freelancers', 'blog', 'community') NOT NULL COMMENT '검색 타입',
    filters JSON COMMENT '적용된 필터',
    
    -- 결과 정보
    results_count INT DEFAULT 0 COMMENT '검색 결과 수',
    clicked_result_id INT COMMENT '클릭한 결과 ID',
    click_position INT COMMENT '클릭한 결과 위치',
    
    -- 시스템 정보
    ip_address VARCHAR(45) COMMENT 'IP 주소',
    user_agent TEXT COMMENT '사용자 에이전트',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_search_type (search_type),
    INDEX idx_created_at (created_at),
    FULLTEXT idx_search_query (search_query)
) COMMENT='검색 로그';

-- ===================================================================
-- 18. SYSTEM_SETTINGS TABLE - 시스템 설정
-- ===================================================================
CREATE TABLE system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL COMMENT '설정 키',
    setting_value TEXT COMMENT '설정 값',
    setting_type ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string' COMMENT '설정 타입',
    description TEXT COMMENT '설정 설명',
    category VARCHAR(50) DEFAULT 'general' COMMENT '설정 카테고리',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_category (category)
) COMMENT='시스템 설정';

-- ===================================================================
-- DDL 완료 메시지
-- ===================================================================
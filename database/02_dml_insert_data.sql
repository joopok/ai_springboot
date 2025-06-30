-- ===================================================================
-- JobKorea Billboard - Sample Data (DML)
-- 더미 데이터 삽입 스크립트
-- ===================================================================

USE jobtracker;

-- ===================================================================
-- 1. USERS 테이블 더미 데이터
-- ===================================================================
INSERT INTO users (username, email, password_hash, full_name, phone, profile_image, role, status, email_verified, bio, location, website, last_login) VALUES
-- 관리자
('admin', 'admin@jobkorea.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '시스템 관리자', '02-1234-5678', '/images/profiles/admin.jpg', 'admin', 'active', TRUE, '시스템 관리자입니다.', '서울', NULL, NOW()),

-- 프리랜서들
('john_dev', 'john@example.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '김철수', '010-1111-2222', '/images/profiles/john.jpg', 'freelancer', 'active', TRUE, '5년 경력의 풀스택 개발자입니다. React, Node.js, Python을 주로 사용합니다.', '서울 강남구', 'https://johndev.portfolio.com', '2024-06-28 10:30:00'),
('sarah_designer', 'sarah@example.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '박영희', '010-2222-3333', '/images/profiles/sarah.jpg', 'freelancer', 'active', TRUE, 'UI/UX 디자이너로 3년간 다양한 프로젝트를 진행했습니다.', '서울 서초구', 'https://sarahdesign.com', '2024-06-28 09:15:00'),
('mike_backend', 'mike@example.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '이민호', '010-3333-4444', '/images/profiles/mike.jpg', 'freelancer', 'active', TRUE, '백엔드 전문 개발자입니다. Java, Spring, AWS 전문가입니다.', '부산 해운대구', 'https://mikedev.github.io', '2024-06-27 16:45:00'),
('jenny_mobile', 'jenny@example.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '최지은', '010-4444-5555', '/images/profiles/jenny.jpg', 'freelancer', 'active', TRUE, '모바일 앱 개발자입니다. React Native, Flutter 전문입니다.', '대구 수성구', NULL, '2024-06-28 14:20:00'),
('alex_data', 'alex@example.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '정우진', '010-5555-6666', '/images/profiles/alex.jpg', 'freelancer', 'active', TRUE, '데이터 사이언티스트입니다. Python, ML, AI 전문분야입니다.', '서울 마포구', 'https://alexdata.ai', '2024-06-28 11:10:00'),

-- 클라이언트들
('tech_company', 'hr@techcompany.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '테크컴퍼니 인사팀', '02-2222-3333', '/images/profiles/tech_company.jpg', 'client', 'active', TRUE, '혁신적인 기술 솔루션을 제공하는 회사입니다.', '서울 강남구', 'https://techcompany.co.kr', '2024-06-28 08:00:00'),
('startup_ceo', 'ceo@startup.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '스타트업 대표', '02-3333-4444', '/images/profiles/startup_ceo.jpg', 'client', 'active', TRUE, '빠르게 성장하는 핀테크 스타트업입니다.', '서울 성수동', 'https://ourfintech.com', '2024-06-27 18:30:00'),
('ecommerce_pm', 'pm@ecommerce.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '이커머스 PM', '02-4444-5555', '/images/profiles/ecommerce_pm.jpg', 'client', 'active', TRUE, '대형 이커머스 플랫폼을 운영하고 있습니다.', '서울 중구', NULL, '2024-06-28 13:45:00'),
('agency_director', 'director@agency.com', '$2b$10$rQJ5qDQHQQHQQHQQHQQHQOGKj7.8vQ9QQHQQHQQHQQHQQHQQHQQHQe', '에이전시 디렉터', '02-5555-6666', '/images/profiles/agency_director.jpg', 'client', 'active', TRUE, '디지털 마케팅 에이전시를 운영하고 있습니다.', '서울 홍대', 'https://digitalagency.kr', '2024-06-28 07:20:00');

-- ===================================================================
-- 2. COMPANIES 테이블 더미 데이터
-- ===================================================================
INSERT INTO companies (user_id, name, description, industry, company_size, founded_year, website, location, address, logo_url, cover_image, is_verified, status) VALUES
(7, '테크컴퍼니', '인공지능과 빅데이터 솔루션을 제공하는 선도적인 기술 기업입니다. 다양한 산업 분야에서 디지털 혁신을 이끌어가고 있습니다.', 'Technology', 'medium', 2018, 'https://techcompany.co.kr', '서울특별시 강남구', '서울특별시 강남구 테헤란로 123', '/images/companies/techcompany_logo.png', '/images/companies/techcompany_cover.jpg', TRUE, 'active'),
(8, '핀테크 스타트업', '금융과 기술의 융합을 통해 혁신적인 서비스를 제공하는 핀테크 기업입니다.', 'Financial Technology', 'startup', 2021, 'https://ourfintech.com', '서울특별시 성동구', '서울특별시 성동구 성수일로 456', '/images/companies/fintech_logo.png', '/images/companies/fintech_cover.jpg', TRUE, 'active'),
(9, '글로벌 이커머스', '아시아 최대 규모의 온라인 쇼핑 플랫폼을 운영하는 이커머스 기업입니다.', 'E-commerce', 'large', 2015, 'https://globalecommerce.com', '서울특별시 중구', '서울특별시 중구 명동길 789', '/images/companies/ecommerce_logo.png', '/images/companies/ecommerce_cover.jpg', TRUE, 'active'),
(10, '디지털 마케팅 에이전시', '브랜드의 디지털 전환을 도와주는 전문 마케팅 에이전시입니다.', 'Marketing', 'small', 2019, 'https://digitalagency.kr', '서울특별시 마포구', '서울특별시 마포구 홍대로 321', '/images/companies/agency_logo.png', '/images/companies/agency_cover.jpg', FALSE, 'active');

-- ===================================================================
-- 3. FREELANCERS 테이블 더미 데이터
-- ===================================================================
INSERT INTO freelancers (user_id, title, description, skills, experience_years, experience_level, hourly_rate, availability, preferred_work_type, portfolio_url, github_url, linkedin_url, rating, total_reviews, completed_projects, is_verified, verification_date) VALUES
(2, 'Full-Stack 개발자', 'React, Node.js, Python을 활용한 웹 애플리케이션 개발 전문가입니다. 스타트업부터 대기업까지 다양한 규모의 프로젝트 경험이 있습니다.', '["React", "Node.js", "Python", "TypeScript", "MongoDB", "PostgreSQL", "AWS", "Docker"]', 5, 'senior', 60000.00, 'available', 'remote', 'https://johndev.portfolio.com', 'https://github.com/johndev', 'https://linkedin.com/in/johndev', 4.8, 25, 18, TRUE, '2024-01-15 10:00:00'),

(3, 'UI/UX 디자이너', '사용자 중심의 디자인으로 비즈니스 가치를 창출합니다. 모바일부터 웹까지 다양한 플랫폼의 디자인 경험이 있습니다.', '["Figma", "Sketch", "Adobe XD", "Photoshop", "Illustrator", "Prototyping", "User Research", "Design System"]', 3, 'mid', 45000.00, 'available', 'hybrid', 'https://sarahdesign.com', NULL, 'https://linkedin.com/in/sarahdesigner', 4.9, 18, 22, TRUE, '2024-02-20 14:30:00'),

(4, '백엔드 개발자', 'Java, Spring Framework를 기반으로 한 대용량 서버 개발 전문가입니다. MSA 아키텍처 설계 경험이 풍부합니다.', '["Java", "Spring Boot", "Spring Security", "MySQL", "Redis", "Kafka", "AWS", "Kubernetes"]', 6, 'senior', 70000.00, 'busy', 'onsite', 'https://mikedev.github.io', 'https://github.com/mikebackend', 'https://linkedin.com/in/mikebackend', 4.7, 32, 15, TRUE, '2023-11-10 09:20:00'),

(5, '모바일 앱 개발자', 'React Native와 Flutter를 활용한 크로스플랫폼 모바일 앱 개발자입니다. 앱스토어 출시 경험 다수 보유하고 있습니다.', '["React Native", "Flutter", "iOS", "Android", "Firebase", "Redux", "GraphQL", "Jest"]', 4, 'mid', 55000.00, 'available', 'remote', NULL, 'https://github.com/jennymobile', 'https://linkedin.com/in/jennymobile', 4.6, 20, 12, FALSE, NULL),

(6, '데이터 사이언티스트', 'Python과 머신러닝을 활용한 데이터 분석 및 AI 모델 개발 전문가입니다. 비즈니스 인사이트 도출에 특화되어 있습니다.', '["Python", "TensorFlow", "PyTorch", "Scikit-learn", "Pandas", "NumPy", "SQL", "Tableau", "Power BI"]', 4, 'mid', 65000.00, 'available', 'remote', 'https://alexdata.ai', 'https://github.com/alexdata', 'https://linkedin.com/in/alexdata', 4.5, 15, 8, TRUE, '2024-03-05 16:45:00');

-- ===================================================================
-- 4. PROJECTS 테이블 더미 데이터
-- ===================================================================
INSERT INTO projects (title, description, category, subcategory, budget_type, budget_min, budget_max, currency, duration_type, duration_value, start_date, deadline, work_type, experience_level, required_skills, optional_skills, client_id, company_id, status, priority, views, applications_count, is_featured, is_urgent) VALUES

('React 기반 E-commerce 플랫폼 개발', '모던 React와 TypeScript를 활용한 대용량 이커머스 플랫폼 개발 프로젝트입니다. 결제 시스템, 재고 관리, 사용자 관리 등 전체적인 시스템 구축이 필요합니다.', 'Web Development', 'E-commerce', 'fixed', 8000000, 12000000, 'KRW', 'months', 3, '2024-07-15', '2024-10-15', 'remote', 'senior', '["React", "TypeScript", "Node.js", "MongoDB", "Payment API"]', '["Next.js", "GraphQL", "AWS"]', 9, 3, 'active', 'high', 156, 8, TRUE, FALSE),

('모바일 헬스케어 앱 UI/UX 디자인', '건강 관리를 위한 모바일 애플리케이션의 UI/UX 디자인 프로젝트입니다. 사용자 친화적이면서도 의료진이 사용하기 편한 인터페이스 설계가 필요합니다.', 'Design', 'Mobile UI/UX', 'fixed', 3000000, 5000000, 'KRW', 'weeks', 8, '2024-07-01', '2024-08-30', 'hybrid', 'mid', '["Figma", "UI/UX Design", "Mobile Design", "Prototyping"]', '["User Research", "Design System"]', 7, 1, 'active', 'normal', 89, 12, FALSE, FALSE),

('MSA 기반 백엔드 시스템 구축', '마이크로서비스 아키텍처를 기반으로 한 확장 가능한 백엔드 시스템 개발 프로젝트입니다. 대용량 트래픽 처리와 고가용성이 핵심 요구사항입니다.', 'Backend Development', 'Microservices', 'hourly', NULL, NULL, 'KRW', 'months', 4, '2024-08-01', '2024-11-30', 'onsite', 'expert', '["Java", "Spring Boot", "Kubernetes", "Docker", "AWS"]', '["Kafka", "Redis", "Elasticsearch"]', 8, 2, 'active', 'urgent', 234, 5, TRUE, TRUE),

('AI 기반 추천 시스템 개발', '머신러닝 알고리즘을 활용한 개인화 추천 시스템 개발 프로젝트입니다. 사용자 행동 패턴 분석과 실시간 추천 기능 구현이 필요합니다.', 'Data Science', 'Machine Learning', 'fixed', 15000000, 20000000, 'KRW', 'months', 5, '2024-09-01', '2025-01-31', 'remote', 'expert', '["Python", "TensorFlow", "MLOps", "Big Data"]', '["Spark", "Airflow", "Kubernetes"]', 9, 3, 'active', 'high', 178, 3, TRUE, FALSE),

('크로스플랫폼 소셜미디어 앱 개발', 'React Native를 활용한 소셜미디어 모바일 애플리케이션 개발 프로젝트입니다. 실시간 채팅, 피드, 스토리 기능 등이 포함됩니다.', 'Mobile Development', 'Social Media', 'fixed', 6000000, 8000000, 'KRW', 'months', 3, '2024-07-20', '2024-10-20', 'remote', 'mid', '["React Native", "Firebase", "Redux", "Socket.io"]', '["TypeScript", "GraphQL"]', 10, 4, 'active', 'normal', 145, 15, FALSE, FALSE),

('기업용 대시보드 웹 애플리케이션', '데이터 시각화를 중심으로 한 기업용 대시보드 웹 애플리케이션 개발 프로젝트입니다. 복잡한 데이터를 직관적으로 표현하는 것이 핵심입니다.', 'Web Development', 'Dashboard', 'fixed', 4000000, 6000000, 'KRW', 'weeks', 10, '2024-07-10', '2024-09-15', 'hybrid', 'mid', '["Vue.js", "D3.js", "REST API", "Chart.js"]', '["TypeScript", "Nuxt.js"]', 7, 1, 'active', 'normal', 67, 9, FALSE, FALSE),

('블록체인 기반 NFT 마켓플레이스', '이더리움 기반의 NFT 거래 플랫폼 개발 프로젝트입니다. 스마트 컨트랙트 개발과 웹3 통합이 필요합니다.', 'Blockchain', 'NFT', 'fixed', 12000000, 18000000, 'KRW', 'months', 4, '2024-08-15', '2024-12-15', 'remote', 'expert', '["Solidity", "Web3.js", "React", "IPFS"]', '["Hardhat", "OpenZeppelin"]', 8, 2, 'in_progress', 'high', 289, 6, TRUE, FALSE);

-- ===================================================================
-- 5. PROJECT_APPLICATIONS 테이블 더미 데이터
-- ===================================================================
INSERT INTO project_applications (project_id, freelancer_id, cover_letter, proposed_budget, proposed_timeline, portfolio_items, status, client_notes, applied_at) VALUES

(1, 2, 'React와 TypeScript를 활용한 5년간의 풀스택 개발 경험을 바탕으로 고품질의 이커머스 플랫폼을 구축해드리겠습니다. 특히 결제 시스템과 사용자 경험 최적화에 자신 있습니다.', 10000000, '3개월', '["https://portfolio.com/project1", "https://portfolio.com/project2"]', 'pending', NULL, '2024-06-25 09:30:00'),

(1, 4, '6년간의 백엔드 개발 경험과 대용량 트래픽 처리 노하우를 통해 안정적이고 확장 가능한 이커머스 시스템을 구축하겠습니다.', 11000000, '2.5개월', '["https://github.com/project-ecommerce"]', 'shortlisted', '기술적 역량이 뛰어남. 면접 진행 예정', '2024-06-26 14:15:00'),

(2, 3, 'UI/UX 디자이너로서 헬스케어 앱 디자인 경험이 있습니다. 사용자 리서치부터 프로토타입까지 전 과정을 담당하겠습니다.', 4000000, '8주', '["https://behance.net/healthcare-app"]', 'accepted', '디자인 포트폴리오가 인상적. 선정됨', '2024-06-23 16:45:00'),

(3, 4, 'MSA 아키텍처 설계와 구현에 6년간의 전문 경험을 보유하고 있습니다. Kubernetes와 AWS를 활용한 클라우드 네이티브 솔루션을 제공하겠습니다.', 80000, '4개월', '["https://github.com/msa-project"]', 'pending', NULL, '2024-06-27 10:20:00'),

(4, 6, '머신러닝과 추천 시스템 개발에 4년간의 전문 경험을 가지고 있습니다. TensorFlow와 실시간 처리 시스템을 활용하여 고성능 추천 엔진을 구축하겠습니다.', 18000000, '5개월', '["https://github.com/recommendation-system"]', 'pending', NULL, '2024-06-28 11:10:00'),

(5, 5, 'React Native를 활용한 소셜미디어 앱 개발 경험이 풍부합니다. 실시간 기능과 사용자 경험 최적화에 특화되어 있습니다.', 7000000, '3개월', '["https://github.com/social-app"]', 'pending', NULL, '2024-06-28 13:25:00');

-- ===================================================================
-- 6. JOB_POSTINGS 테이블 더미 데이터
-- ===================================================================
INSERT INTO job_postings (title, description, department, position_level, employment_type, work_type, salary_type, salary_min, salary_max, currency, salary_negotiable, location, address, required_skills, preferred_skills, education_level, experience_years_min, experience_years_max, benefits, company_id, recruiter_id, application_deadline, start_date, status, views, applications_count, is_featured, is_urgent) VALUES

('시니어 프론트엔드 개발자', 'React와 TypeScript를 활용한 웹 애플리케이션 개발을 담당할 시니어 프론트엔드 개발자를 모집합니다. 최신 기술 스택을 활용하여 사용자 경험을 혁신할 인재를 찾습니다.', '개발팀', 'senior', 'full_time', 'hybrid', 'annual', 60000000, 80000000, 'KRW', TRUE, '서울 강남구', '서울특별시 강남구 테헤란로 123', '["React", "TypeScript", "JavaScript", "HTML/CSS"]', '["Next.js", "GraphQL", "Testing"]', 'bachelor', 3, 7, '["4대보험", "퇴직연금", "유연근무", "교육지원", "건강검진"]', 1, 7, '2024-07-30', '2024-08-15', 'active', 245, 18, TRUE, FALSE),

('UX/UI 디자이너', '사용자 중심의 디자인으로 제품의 가치를 높일 UX/UI 디자이너를 모집합니다. 디자인 시스템 구축과 사용자 리서치 경험이 있는 분을 우대합니다.', '디자인팀', 'mid', 'full_time', 'hybrid', 'annual', 45000000, 60000000, 'KRW', TRUE, '서울 성수동', '서울특별시 성동구 성수일로 456', '["Figma", "Sketch", "Prototyping", "User Research"]', '["Design System", "Framer", "After Effects"]', 'bachelor', 2, 5, '["스톡옵션", "유연근무", "점심제공", "간식제공", "도서구입비"]', 2, 8, '2024-07-25', '2024-08-10', 'active', 189, 24, FALSE, FALSE),

('백엔드 개발자 (Java/Spring)', 'Java와 Spring Framework를 활용한 서버 개발을 담당할 백엔드 개발자를 모집합니다. MSA 아키텍처 경험이 있는 분을 우대합니다.', '개발팀', 'mid', 'full_time', 'onsite', 'annual', 55000000, 75000000, 'KRW', FALSE, '서울 중구', '서울특별시 중구 명동길 789', '["Java", "Spring Boot", "MySQL", "REST API"]', '["Kubernetes", "AWS", "Redis"]', 'bachelor', 2, 6, '["4대보험", "퇴직연금", "성과급", "교육지원", "워크샵"]', 3, 9, '2024-08-05', '2024-08-20', 'active', 167, 12, FALSE, FALSE),

('데이터 엔지니어', '빅데이터 처리와 분석 인프라 구축을 담당할 데이터 엔지니어를 모집합니다. Python과 클라우드 플랫폼 경험이 필수입니다.', '데이터팀', 'mid', 'full_time', 'remote', 'annual', 65000000, 85000000, 'KRW', TRUE, '서울 마포구', '서울특별시 마포구 홍대로 321', '["Python", "SQL", "Apache Spark", "AWS"]', '["Airflow", "Kafka", "Docker"]', 'bachelor', 3, 7, '["재택근무", "4대보험", "퇴직연금", "IT기기지원", "교육비지원"]', 4, 10, '2024-07-28', '2024-08-12', 'active', 134, 8, FALSE, TRUE),

('DevOps 엔지니어', 'CI/CD 파이프라인 구축과 인프라 자동화를 담당할 DevOps 엔지니어를 모집합니다. 클라우드 네이티브 환경에서의 경험이 필요합니다.', '인프라팀', 'senior', 'full_time', 'hybrid', 'annual', 70000000, 90000000, 'KRW', TRUE, '서울 강남구', '서울특별시 강남구 테헤란로 123', '["AWS", "Kubernetes", "Docker", "Jenkins"]', '["Terraform", "Prometheus", "Grafana"]', 'bachelor', 4, 8, '["4대보험", "퇴직연금", "유연근무", "컨퍼런스 참가비", "도서구입비"]', 1, 7, '2024-08-10', '2024-08-25', 'active', 98, 6, TRUE, FALSE);

-- ===================================================================
-- 7. BLOG_POSTS 테이블 더미 데이터
-- ===================================================================
INSERT INTO blog_posts (title, slug, content, excerpt, category, subcategory, tags, author_id, featured_image, status, views, likes, comments_count, shares, meta_title, meta_description, is_featured, allow_comments, published_at) VALUES

('React 18의 새로운 기능들과 성능 개선 사항', 'react-18-new-features-performance', 'React 18에서 도입된 Concurrent Features, Automatic Batching, Suspense 개선사항 등에 대해 자세히 알아보겠습니다...', 'React 18의 주요 새기능들과 성능 개선 사항들을 실제 예제와 함께 살펴봅니다.', 'dev-tech', 'Frontend', '["React", "JavaScript", "Frontend", "Performance"]', 2, '/images/blog/react-18-features.jpg', 'published', 1567, 89, 23, 45, 'React 18 새기능 완벽 가이드', 'React 18의 Concurrent Features와 성능 개선사항을 실제 예제로 배워보세요', TRUE, TRUE, '2024-06-20 10:00:00'),

('TypeScript 5.0 업데이트 총정리', 'typescript-5-0-complete-guide', 'TypeScript 5.0에서 추가된 새로운 기능들과 변경사항들을 예제와 함께 정리했습니다...', 'TypeScript 5.0의 주요 업데이트 사항들을 개발자 관점에서 분석합니다.', 'dev-tech', 'Programming Language', '["TypeScript", "JavaScript", "Programming"]', 4, '/images/blog/typescript-5.jpg', 'published', 1234, 67, 18, 32, 'TypeScript 5.0 완벽 가이드', 'TypeScript 5.0의 새로운 기능들을 실무 예제와 함께 알아보세요', FALSE, TRUE, '2024-06-22 14:30:00'),

('2024년 UI/UX 디자인 트렌드 전망', 'ux-ui-design-trends-2024', '2024년 주목해야 할 UI/UX 디자인 트렌드들을 분석하고 실제 적용 방법을 제시합니다...', '올해 디자인 업계를 이끌어갈 주요 트렌드들과 적용 전략을 살펴봅니다.', 'design-tech', 'UI/UX', '["UI/UX", "Design", "Trends", "2024"]', 3, '/images/blog/design-trends-2024.jpg', 'published', 2156, 134, 41, 78, '2024 UI/UX 디자인 트렌드', '2024년 주목받는 UI/UX 디자인 트렌드와 실무 적용 방법을 알아보세요', TRUE, TRUE, '2024-06-18 09:15:00'),

('AI 시대의 프로그래밍: ChatGPT와 함께하는 개발', 'ai-programming-with-chatgpt', 'ChatGPT와 같은 AI 도구들이 프로그래밍 업계에 미치는 영향과 효과적인 활용 방법을 다룹니다...', 'AI 도구를 활용한 효율적인 개발 방법론과 미래 전망을 제시합니다.', 'silicon-valley-ai', 'AI Development', '["AI", "ChatGPT", "Programming", "Future"]', 6, '/images/blog/ai-programming.jpg', 'published', 3245, 189, 67, 123, 'AI 시대의 프로그래밍 가이드', 'ChatGPT와 AI 도구를 활용한 효율적인 개발 방법을 배워보세요', TRUE, TRUE, '2024-06-15 16:45:00'),

('프리랜서를 위한 시간 관리와 생산성 향상 팁', 'freelancer-time-management-productivity', '프리랜서로 성공하기 위한 효과적인 시간 관리 방법과 생산성 향상 전략을 소개합니다...', '프리랜서의 업무 효율성을 극대화하는 실용적인 팁들을 정리했습니다.', 'balance-up', 'Productivity', '["Freelancer", "Time Management", "Productivity", "Work Life Balance"]', 2, '/images/blog/freelancer-productivity.jpg', 'published', 1876, 112, 35, 56, '프리랜서 시간 관리 완벽 가이드', '프리랜서를 위한 시간 관리와 생산성 향상 방법을 알아보세요', FALSE, TRUE, '2024-06-25 11:20:00'),

('Next.js 14 App Router 마이그레이션 가이드', 'nextjs-14-app-router-migration', 'Next.js 13/14의 App Router로 기존 Pages Router 프로젝트를 마이그레이션하는 방법을 단계별로 설명합니다...', 'Next.js App Router 마이그레이션 과정에서 주의할 점들과 Best Practice를 소개합니다.', 'dev-tech', 'Framework', '["Next.js", "React", "Migration", "App Router"]', 2, '/images/blog/nextjs-migration.jpg', 'published', 2134, 145, 52, 67, 'Next.js 14 App Router 마이그레이션', 'Next.js App Router로 안전하게 마이그레이션하는 방법을 알아보세요', FALSE, TRUE, '2024-06-28 13:10:00'),

('실리콘밸리 스타트업의 개발 문화와 협업 방식', 'silicon-valley-startup-dev-culture', '실리콘밸리 주요 스타트업들의 개발 문화와 협업 방식을 분석하고 한국 기업에 적용할 수 있는 인사이트를 제공합니다...', '글로벌 스타트업의 개발 문화에서 배울 수 있는 협업과 혁신의 노하우를 소개합니다.', 'silicon-valley-ai', 'Startup Culture', '["Silicon Valley", "Startup", "Dev Culture", "Collaboration"]', 6, '/images/blog/silicon-valley-culture.jpg', 'published', 1654, 98, 29, 41, '실리콘밸리 개발 문화 분석', '실리콘밸리 스타트업의 개발 문화와 협업 방식을 분석합니다', FALSE, TRUE, '2024-06-12 08:30:00');

-- ===================================================================
-- 8. COMMUNITY_POSTS 테이블 더미 데이터
-- ===================================================================
INSERT INTO community_posts (title, content, category, author_id, attachments, images, status, views, likes, dislikes, comments_count, is_pinned, is_locked, is_anonymous) VALUES

('Next.js 14 App Router 관련 질문입니다', 'Next.js 14에서 App Router를 사용할 때 페이지 간 상태 관리는 어떻게 하는 것이 좋을까요? Zustand나 Redux 중 어느 것을 추천하시나요?', 'qna', 5, NULL, NULL, 'published', 234, 12, 1, 8, FALSE, FALSE, FALSE),

('React 고급 패턴 스터디 모집합니다', 'React의 고급 패턴들(Compound Components, Render Props, Higher-Order Components 등)을 함께 공부할 스터디원을 모집합니다. 주 1회, 온라인으로 진행예정입니다.', 'study', 3, NULL, NULL, 'published', 187, 24, 0, 15, FALSE, FALSE, FALSE),

('포트폴리오 사이트 피드백 부탁드립니다', '프론트엔드 개발자 포트폴리오 사이트를 새로 만들었습니다. 디자인이나 사용성 측면에서 피드백 부탁드립니다!', 'share', 2, '["https://myportfolio.dev"]', '["portfolio-screenshot1.jpg", "portfolio-screenshot2.jpg"]', 'published', 345, 31, 2, 22, FALSE, FALSE, FALSE),

('2024년 상반기 프리랜서 시장 동향', '올해 상반기 IT 프리랜서 시장의 동향과 주요 변화사항들을 정리해봤습니다. 특히 AI 관련 프로젝트의 급증이 눈에 띕니다.', 'free', 6, NULL, NULL, 'published', 567, 45, 3, 31, TRUE, FALSE, FALSE),

('사이드 프로젝트 팀원 모집', 'AI 기반 개인 투자 포트폴리오 관리 서비스를 개발할 팀원을 모집합니다. 백엔드 개발자 1명, 프론트엔드 개발자 1명이 필요합니다.', 'project_review', 4, NULL, NULL, 'published', 298, 18, 1, 12, FALSE, FALSE, FALSE),

('모바일 앱 디자인 갤러리', '최근 작업한 헬스케어 모바일 앱 디자인입니다. 사용자 경험을 중심으로 설계했습니다.', 'gallery', 3, NULL, '["healthcare-app-1.jpg", "healthcare-app-2.jpg", "healthcare-app-3.jpg"]', 'published', 423, 67, 2, 19, FALSE, FALSE, FALSE),

('유용한 개발 도구들 공유', '개발 생산성을 높여주는 유용한 도구들을 공유합니다. VS Code 확장프로그램, CLI 도구, 디자인 리소스 등을 정리했습니다.', 'share', 2, '["useful-dev-tools.md"]', NULL, 'published', 612, 89, 1, 27, FALSE, FALSE, FALSE),

('[공지] 커뮤니티 이용 규칙 안내', '커뮤니티를 건전하게 이용하기 위한 기본 규칙들을 안내드립니다. 모든 회원분들께서는 반드시 숙지해 주시기 바랍니다.', 'notice', 1, NULL, NULL, 'published', 1234, 56, 0, 8, TRUE, TRUE, FALSE);

-- ===================================================================
-- 9. COMMENTS 테이블 더미 데이터
-- ===================================================================
INSERT INTO comments (content, post_id, post_type, author_id, parent_id, depth, status, likes, dislikes, is_anonymous) VALUES

('Next.js에서 상태 관리는 프로젝트 규모에 따라 달라집니다. 작은 프로젝트라면 React의 Context API만으로도 충분하고, 복잡한 상태가 많다면 Zustand를 추천합니다.', 1, 'community', 2, NULL, 0, 'published', 8, 0, FALSE),
('Zustand가 Redux보다 보일러플레이트가 적어서 좋은 것 같습니다. 특히 TypeScript와의 호환성도 뛰어나고요.', 1, 'community', 4, 1, 1, 'published', 5, 0, FALSE),
('저도 Zustand 한 표! 러닝 커브가 낮아서 팀 프로젝트에 도입하기 좋았습니다.', 1, 'community', 3, 1, 1, 'published', 3, 0, FALSE),

('React 고급 패턴 스터디 참여하고 싶습니다! 언제부터 시작하나요?', 2, 'community', 5, NULL, 0, 'published', 4, 0, FALSE),
('저도 관심 있습니다. 혹시 초급자도 참여 가능한가요?', 2, 'community', 2, NULL, 0, 'published', 2, 0, FALSE),
('다음 주 월요일부터 시작할 예정입니다. 초급자도 환영합니다!', 2, 'community', 3, 4, 1, 'published', 6, 0, FALSE),

('포트폴리오 디자인이 정말 깔끔하네요! 특히 애니메이션 효과가 인상적입니다.', 3, 'community', 6, NULL, 0, 'published', 12, 0, FALSE),
('모바일 반응형도 잘 되어 있고, 로딩 속도도 빠르네요. 좋은 작업물 같습니다.', 3, 'community', 4, NULL, 0, 'published', 8, 0, FALSE),

('React 18 기능 정리 잘 해주셨네요. Concurrent Features 부분이 특히 도움이 되었습니다.', 1, 'blog', 3, NULL, 0, 'published', 15, 0, FALSE),
('Automatic Batching 덕분에 성능이 많이 개선된 것 같습니다. 실제 프로젝트에 적용해봐야겠어요.', 1, 'blog', 5, NULL, 0, 'published', 9, 0, FALSE),

('TypeScript 5.0 업데이트 정보 감사합니다. const assertions 개선사항이 인상적이네요.', 2, 'blog', 2, NULL, 0, 'published', 11, 0, FALSE),
('Decorators 지원이 정식으로 포함된 게 가장 큰 변화인 것 같습니다.', 2, 'blog', 6, NULL, 0, 'published', 7, 0, FALSE);

-- ===================================================================
-- 10. REVIEWS 테이블 더미 데이터
-- ===================================================================
INSERT INTO reviews (project_id, reviewer_id, reviewee_id, title, content, overall_rating, communication_rating, quality_rating, timeline_rating, review_type, status, is_public) VALUES

(2, 7, 3, '훌륭한 UI/UX 디자인 작업', '요구사항을 정확히 파악하고 사용자 중심의 디자인을 제공해주셨습니다. 소통도 원활했고 일정도 준수해주셨습니다.', 4.8, 5.0, 4.8, 4.5, 'client_to_freelancer', 'published', TRUE),

(2, 3, 7, '명확한 요구사항과 신속한 피드백', '프로젝트 요구사항이 명확했고, 피드백도 빠르게 주셔서 작업하기 좋았습니다. 전문적인 클라이언트였습니다.', 4.7, 4.8, 4.5, 4.8, 'freelancer_to_client', 'published', TRUE),

(7, 8, 4, '전문적인 백엔드 개발', 'MSA 아키텍처 구현이 정말 전문적이었습니다. 코드 품질도 높고 문서화도 잘 되어 있었습니다.', 4.9, 4.7, 5.0, 4.8, 'client_to_freelancer', 'published', TRUE),

(7, 4, 8, '도전적인 프로젝트와 좋은 협업', '기술적으로 도전적인 프로젝트였지만 클라이언트의 이해도가 높아서 원활하게 진행할 수 있었습니다.', 4.6, 4.8, 4.5, 4.7, 'freelancer_to_client', 'published', TRUE),

(NULL, 9, 2, '신뢰할 수 있는 개발자', '여러 프로젝트를 함께 진행했는데 항상 높은 품질의 결과물을 제공해주십니다. 커뮤니케이션도 원활합니다.', 4.8, 4.9, 4.8, 4.7, 'client_to_freelancer', 'published', TRUE),

(NULL, 10, 5, '모바일 개발 전문가', 'React Native 앱 개발 실력이 뛰어납니다. 사용자 경험을 고려한 세심한 개발을 해주셨습니다.', 4.7, 4.6, 4.8, 4.5, 'client_to_freelancer', 'published', TRUE);

-- ===================================================================
-- 11. PORTFOLIOS 테이블 더미 데이터
-- ===================================================================
INSERT INTO portfolios (user_id, title, description, category, technologies, role, project_url, github_url, demo_url, images, video_url, client_name, project_duration, team_size, achievements, metrics, status, is_featured, display_order, completion_date) VALUES

(2, 'E-commerce 플랫폼 풀스택 개발', 'React와 Node.js를 활용한 대규모 이커머스 플랫폼 개발 프로젝트입니다. 결제 시스템, 재고 관리, 관리자 대시보드 등을 구현했습니다.', 'Web Development', '["React", "Node.js", "MongoDB", "Stripe API", "AWS"]', 'Full-Stack Developer', 'https://demo-ecommerce.com', 'https://github.com/johndev/ecommerce-platform', 'https://demo-ecommerce.com', '["ecommerce-1.jpg", "ecommerce-2.jpg", "ecommerce-3.jpg"]', 'https://youtube.com/watch?v=demo1', '글로벌 이커머스', '3개월', 1, '["50% 성능 향상", "99.9% 안정성 확보", "모바일 접근성 개선"]', '{"daily_users": 10000, "conversion_rate": "3.2%", "page_load_time": "1.2s"}', 'published', TRUE, 1, '2024-05-15'),

(3, '헬스케어 모바일 앱 UI/UX 디자인', '의료진과 환자를 위한 헬스케어 모바일 애플리케이션의 전체적인 UI/UX 디자인을 담당했습니다. 사용자 리서치부터 프로토타입까지 전 과정을 진행했습니다.', 'UI/UX Design', '["Figma", "Sketch", "Prototyping", "User Research"]', 'UI/UX Designer', NULL, NULL, 'https://figma.com/proto/healthcare-app', '["healthcare-ui-1.jpg", "healthcare-ui-2.jpg", "healthcare-ui-3.jpg"]', NULL, '메디케어 솔루션', '2개월', 3, '["사용자 만족도 95%", "의료진 업무 효율성 30% 향상", "앱스토어 4.8점 평점"]', '{"user_satisfaction": "95%", "task_completion_rate": "92%", "user_retention": "78%"}', 'published', TRUE, 1, '2024-04-20'),

(4, '마이크로서비스 아키텍처 백엔드 시스템', 'Spring Boot와 Kubernetes를 활용한 대용량 트래픽 처리 백엔드 시스템입니다. MSA 패턴을 적용하여 확장성과 안정성을 확보했습니다.', 'Backend Development', '["Java", "Spring Boot", "Kubernetes", "Docker", "Redis", "PostgreSQL"]', 'Backend Developer', NULL, 'https://github.com/mikebackend/msa-system', NULL, '["msa-architecture.jpg", "monitoring-dashboard.jpg"]', NULL, '핀테크 스타트업', '4개월', 2, '["1000만 TPS 처리", "99.99% 가용성", "50% 인프라 비용 절감"]', '{"tps": 10000000, "uptime": "99.99%", "cost_reduction": "50%"}', 'published', TRUE, 1, '2024-03-10'),

(5, '크로스플랫폼 소셜 미디어 앱', 'React Native를 활용한 소셜 미디어 모바일 애플리케이션입니다. 실시간 채팅, 피드, 스토리 기능을 구현했습니다.', 'Mobile Development', '["React Native", "Firebase", "Redux", "Socket.io", "TypeScript"]', 'Mobile Developer', 'https://social-app-demo.com', 'https://github.com/jennymobile/social-app', 'https://social-app-demo.com', '["social-app-1.jpg", "social-app-2.jpg", "social-app-3.jpg"]', 'https://youtube.com/watch?v=social-demo', '스타트업 A', '3개월', 1, '["50만 다운로드 달성", "평균 세션 시간 25분", "일일 활성 사용자 10만명"]', '{"downloads": 500000, "dau": 100000, "session_time": "25min"}', 'published', TRUE, 1, '2024-02-28'),

(6, 'AI 기반 추천 시스템', 'Python과 TensorFlow를 활용한 개인화 추천 시스템입니다. 협업 필터링과 콘텐츠 기반 필터링을 결합하여 높은 정확도를 달성했습니다.', 'Data Science', '["Python", "TensorFlow", "Scikit-learn", "Apache Spark", "AWS"]', 'Data Scientist', NULL, 'https://github.com/alexdata/recommendation-system', NULL, '["recommendation-model.jpg", "performance-metrics.jpg"]', NULL, '이커머스 플랫폼', '5개월', 3, '["클릭률 35% 향상", "구매 전환율 22% 증가", "사용자 만족도 90%"]', '{"ctr_improvement": "35%", "conversion_increase": "22%", "accuracy": "87%"}', 'published', TRUE, 1, '2024-01-15'),

(2, '실시간 채팅 웹 애플리케이션', 'Socket.io와 React를 활용한 실시간 채팅 애플리케이션입니다. 파일 공유, 이모지, 그룹 채팅 기능을 포함합니다.', 'Web Development', '["React", "Node.js", "Socket.io", "MongoDB", "Redux"]', 'Full-Stack Developer', 'https://chat-app-demo.com', 'https://github.com/johndev/realtime-chat', 'https://chat-app-demo.com', '["chat-app-1.jpg", "chat-app-2.jpg"]', NULL, '중소기업 B', '2개월', 1, '["동시 접속자 1000명", "메시지 전송 속도 100ms", "99.5% 메시지 전달률"]', '{"concurrent_users": 1000, "message_speed": "100ms", "delivery_rate": "99.5%"}', 'published', FALSE, 2, '2024-06-10');

-- ===================================================================
-- 12. MESSAGES 테이블 더미 데이터
-- ===================================================================
INSERT INTO messages (sender_id, receiver_id, subject, content, project_id, job_id, message_type, thread_id, parent_id, status, is_read, read_at, attachments) VALUES

(7, 2, 'React 프로젝트 관련 문의', '안녕하세요. 귀하의 포트폴리오를 보고 연락드립니다. 저희가 진행하는 React 프로젝트에 대해 상담하고 싶습니다.', 1, NULL, 'project_inquiry', 'thread_001', NULL, 'read', TRUE, '2024-06-25 10:30:00', NULL),

(2, 7, 'RE: React 프로젝트 관련 문의', '안녕하세요. 연락 주셔서 감사합니다. 프로젝트에 대한 자세한 내용을 알려주시면 검토 후 답변드리겠습니다.', 1, NULL, 'project_inquiry', 'thread_001', 1, 'read', TRUE, '2024-06-25 11:15:00', NULL),

(9, 3, '헬스케어 앱 디자인 프로젝트 선정 안내', '축하드립니다! 헬스케어 앱 UI/UX 디자인 프로젝트에 선정되셨습니다. 계약서와 관련 자료를 첨부합니다.', 2, NULL, 'project_inquiry', 'thread_002', NULL, 'read', TRUE, '2024-06-23 17:00:00', '["contract.pdf", "project_brief.pdf"]'),

(3, 9, 'RE: 헬스케어 앱 디자인 프로젝트 선정 안내', '감사합니다! 계약서 검토 후 서명하여 보내드리겠습니다. 프로젝트 시작일정은 언제인가요?', 2, NULL, 'project_inquiry', 'thread_002', 3, 'read', TRUE, '2024-06-23 18:30:00', NULL),

(8, 4, '백엔드 개발자 채용 공고 관련', '안녕하세요. 저희 회사 백엔드 개발자 포지션에 관심 있으시다면 면접 일정을 조율하고 싶습니다.', NULL, 3, 'application', 'thread_003', NULL, 'read', TRUE, '2024-06-27 09:00:00', NULL),

(4, 8, 'RE: 백엔드 개발자 채용 공고 관련', '안녕하세요. 관심 있습니다. 면접 가능한 시간을 알려드리겠습니다.', NULL, 3, 'application', 'thread_003', 5, 'sent', FALSE, NULL, '["resume.pdf"]'),

(1, 2, '시스템 점검 안내', '시스템 정기 점검으로 인해 2024년 7월 1일 02:00~04:00 서비스가 일시 중단됩니다.', NULL, NULL, 'system', 'system_001', NULL, 'delivered', FALSE, NULL, NULL),

(1, 3, '시스템 점검 안내', '시스템 정기 점검으로 인해 2024년 7월 1일 02:00~04:00 서비스가 일시 중단됩니다.', NULL, NULL, 'system', 'system_001', NULL, 'delivered', FALSE, NULL, NULL);

-- ===================================================================
-- 13. NOTIFICATIONS 테이블 더미 데이터
-- ===================================================================
INSERT INTO notifications (user_id, title, message, type, priority, reference_type, reference_id, action_url, is_read, read_at, send_email, send_push) VALUES

(2, '새로운 프로젝트 지원자', 'React 프로젝트에 새로운 지원자가 있습니다.', 'project_application', 'normal', 'project_application', 1, '/projects/1/applications', FALSE, NULL, TRUE, TRUE),

(3, '프로젝트 선정 축하', '헬스케어 앱 디자인 프로젝트에 선정되셨습니다!', 'project_update', 'high', 'project', 2, '/projects/2', TRUE, '2024-06-23 17:05:00', TRUE, TRUE),

(4, '새로운 메시지', '백엔드 개발자 채용 건으로 새로운 메시지가 도착했습니다.', 'message', 'normal', 'message', 5, '/messages/5', FALSE, NULL, TRUE, TRUE),

(2, '리뷰 등록 완료', '클라이언트가 프로젝트 리뷰를 남겼습니다.', 'review', 'normal', 'review', 1, '/reviews/1', TRUE, '2024-06-26 10:15:00', TRUE, FALSE),

(5, '관심 프로젝트 업데이트', '관심 등록한 모바일 개발 프로젝트가 업데이트되었습니다.', 'project_update', 'low', 'project', 5, '/projects/5', FALSE, NULL, FALSE, TRUE),

(6, '스터디 모집 마감 임박', '참여 신청한 React 스터디 모집이 곧 마감됩니다.', 'system', 'normal', 'community_post', 2, '/community/study/2', FALSE, NULL, TRUE, TRUE),

(7, '프로젝트 완료 축하', 'UI/UX 디자인 프로젝트가 성공적으로 완료되었습니다.', 'project_update', 'high', 'project', 2, '/projects/2', TRUE, '2024-06-25 16:00:00', TRUE, TRUE),

(3, '포트폴리오 조회수 증가', '포트폴리오 조회수가 1000회를 돌파했습니다!', 'system', 'low', 'portfolio', 2, '/portfolio', FALSE, NULL, FALSE, TRUE);

-- ===================================================================
-- 14. USER_SESSIONS 테이블 더미 데이터
-- ===================================================================
INSERT INTO user_sessions (id, user_id, ip_address, user_agent, device_type, browser, os, country, city, is_active, last_activity, expires_at) VALUES

('sess_001_john_chrome', 2, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', 'desktop', 'Chrome', 'Windows 10', 'South Korea', 'Seoul', TRUE, '2024-06-28 15:30:00', '2024-07-28 15:30:00'),

('sess_002_sarah_safari', 3, '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Version/16.0 Safari/537.36', 'desktop', 'Safari', 'macOS', 'South Korea', 'Seoul', TRUE, '2024-06-28 14:20:00', '2024-07-28 14:20:00'),

('sess_003_mike_mobile', 4, '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1', 'mobile', 'Safari', 'iOS', 'South Korea', 'Busan', TRUE, '2024-06-28 13:45:00', '2024-07-28 13:45:00'),

('sess_004_jenny_chrome', 5, '192.168.1.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', 'desktop', 'Chrome', 'Windows 10', 'South Korea', 'Daegu', TRUE, '2024-06-28 12:10:00', '2024-07-28 12:10:00'),

('sess_005_alex_firefox', 6, '192.168.1.104', 'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0', 'desktop', 'Firefox', 'Linux', 'South Korea', 'Seoul', FALSE, '2024-06-27 18:30:00', '2024-07-27 18:30:00');

-- ===================================================================
-- 15. FILE_UPLOADS 테이블 더미 데이터
-- ===================================================================
INSERT INTO file_uploads (filename, original_name, file_path, file_size, mime_type, file_extension, uploader_id, entity_type, entity_id, file_category, width, height, status) VALUES

('john_profile_20240625.jpg', 'john_profile.jpg', '/uploads/profiles/john_profile_20240625.jpg', 245760, 'image/jpeg', 'jpg', 2, 'user', 2, 'profile_image', 400, 400, 'active'),

('sarah_profile_20240620.jpg', 'sarah_designer.jpg', '/uploads/profiles/sarah_profile_20240620.jpg', 189440, 'image/jpeg', 'jpg', 3, 'user', 3, 'profile_image', 400, 400, 'active'),

('ecommerce_screenshot1.jpg', 'ecommerce_home.jpg', '/uploads/portfolios/ecommerce_screenshot1.jpg', 567890, 'image/jpeg', 'jpg', 2, 'portfolio', 1, 'portfolio_image', 1920, 1080, 'active'),

('healthcare_design1.jpg', 'healthcare_ui_design.jpg', '/uploads/portfolios/healthcare_design1.jpg', 445670, 'image/jpeg', 'jpg', 3, 'portfolio', 2, 'portfolio_image', 1200, 800, 'active'),

('react18_blog_image.jpg', 'react18_features.jpg', '/uploads/blog/react18_blog_image.jpg', 334560, 'image/jpeg', 'jpg', 2, 'blog', 1, 'blog_image', 1200, 630, 'active'),

('design_trends_cover.jpg', 'ux_trends_2024.jpg', '/uploads/blog/design_trends_cover.jpg', 456780, 'image/jpeg', 'jpg', 3, 'blog', 3, 'blog_image', 1200, 630, 'active'),

('techcompany_logo.png', 'company_logo.png', '/uploads/companies/techcompany_logo.png', 123450, 'image/png', 'png', 7, 'company', 1, 'logo', 300, 300, 'active'),

('project_attachment.pdf', 'project_requirements.pdf', '/uploads/projects/project_attachment.pdf', 2456780, 'application/pdf', 'pdf', 7, 'project', 1, 'attachment', NULL, NULL, 'active');

-- ===================================================================
-- 16. TAGS 테이블 더미 데이터
-- ===================================================================
INSERT INTO tags (name, slug, description, color, usage_count, category) VALUES

('React', 'react', 'React JavaScript 라이브러리', '#61DAFB', 156, 'technology'),
('TypeScript', 'typescript', 'TypeScript 프로그래밍 언어', '#3178C6', 134, 'technology'),
('Node.js', 'nodejs', 'Node.js 런타임 환경', '#339933', 98, 'technology'),
('Python', 'python', 'Python 프로그래밍 언어', '#3776AB', 87, 'technology'),
('UI/UX', 'ui-ux', '사용자 인터페이스 및 사용자 경험 디자인', '#FF6B6B', 76, 'skill'),
('JavaScript', 'javascript', 'JavaScript 프로그래밍 언어', '#F7DF1E', 145, 'technology'),
('AWS', 'aws', 'Amazon Web Services 클라우드 플랫폼', '#FF9900', 65, 'technology'),
('Docker', 'docker', 'Docker 컨테이너 플랫폼', '#2496ED', 54, 'technology'),
('Spring Boot', 'spring-boot', 'Spring Boot 프레임워크', '#6DB33F', 43, 'technology'),
('Figma', 'figma', 'Figma 디자인 도구', '#F24E1E', 67, 'technology'),
('Machine Learning', 'machine-learning', '머신러닝 및 AI', '#FF6F00', 38, 'skill'),
('Mobile Development', 'mobile-development', '모바일 앱 개발', '#4CAF50', 45, 'skill'),
('Frontend', 'frontend', '프론트엔드 개발', '#42A5F5', 123, 'skill'),
('Backend', 'backend', '백엔드 개발', '#F44336', 89, 'skill'),
('Full Stack', 'full-stack', '풀스택 개발', '#9C27B0', 67, 'skill'),
('Seoul', 'seoul', '서울 지역', '#2196F3', 234, 'location'),
('Remote', 'remote', '원격 근무', '#4CAF50', 167, 'general'),
('Startup', 'startup', '스타트업', '#FF5722', 89, 'industry'),
('Enterprise', 'enterprise', '대기업', '#607D8B', 45, 'industry'),
('Design System', 'design-system', '디자인 시스템', '#E91E63', 32, 'skill');

-- ===================================================================
-- 17. SEARCH_LOGS 테이블 더미 데이터
-- ===================================================================
INSERT INTO search_logs (user_id, search_query, search_type, filters, results_count, clicked_result_id, click_position, ip_address, user_agent) VALUES

(2, 'React 개발자', 'freelancers', '{"location": "서울", "experience": "mid"}', 23, 3, 2, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(3, 'UI UX 디자인', 'projects', '{"budget_min": 3000000, "work_type": "remote"}', 15, 2, 1, '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'),
(4, '백엔드 개발', 'jobs', '{"salary_min": 50000000, "location": "서울"}', 8, 3, 3, '192.168.1.102', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15'),
(5, 'React 18 새기능', 'blog', '{"category": "dev-tech"}', 12, 1, 1, '192.168.1.103', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(6, '머신러닝 프로젝트', 'projects', '{"category": "Data Science"}', 5, 4, 2, '192.168.1.104', 'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0'),
(NULL, 'TypeScript 개발자', 'freelancers', '{}', 34, NULL, NULL, '203.241.185.123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(7, '모바일 앱 개발', 'projects', '{"work_type": "remote", "budget_max": 10000000}', 18, 5, 4, '192.168.1.105', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36');

-- ===================================================================
-- 18. SYSTEM_SETTINGS 테이블 더미 데이터
-- ===================================================================
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, category) VALUES

('site_name', 'JobKorea Billboard', 'string', '사이트 이름', 'general'),
('site_description', 'IT 프리랜서와 기업을 연결하는 플랫폼', 'string', '사이트 설명', 'general'),
('max_file_upload_size', '10485760', 'number', '최대 파일 업로드 크기 (bytes)', 'upload'),
('allowed_file_types', '["jpg", "jpeg", "png", "gif", "pdf", "doc", "docx"]', 'json', '허용 파일 타입', 'upload'),
('email_verification_required', 'true', 'boolean', '이메일 인증 필수 여부', 'auth'),
('session_timeout', '86400', 'number', '세션 타임아웃 (초)', 'auth'),
('commission_rate', '0.05', 'number', '수수료율', 'payment'),
('featured_project_price', '50000', 'number', '프로젝트 추천 등록 비용', 'payment'),
('min_project_budget', '100000', 'number', '최소 프로젝트 예산', 'project'),
('max_project_duration', '12', 'number', '최대 프로젝트 기간 (개월)', 'project'),
('notification_email_from', 'noreply@jobkorea.com', 'string', '알림 메일 발신자', 'notification'),
('support_email', 'support@jobkorea.com', 'string', '고객지원 이메일', 'general'),
('maintenance_mode', 'false', 'boolean', '점검 모드 여부', 'system'),
('api_rate_limit', '1000', 'number', 'API 요청 제한 (시간당)', 'system'),
('search_results_per_page', '20', 'number', '검색 결과 페이지당 항목 수', 'search');

-- ===================================================================
-- DML 완료 메시지
-- ===================================================================
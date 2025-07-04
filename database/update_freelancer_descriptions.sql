-- 프리랜서 description 컬럼을 랜덤하게 업데이트하는 SQL
-- 다양한 프리랜서 유형별 설명 텍스트를 활용

-- 1. 웹 개발자 타입 (skills에 'React', 'Vue', 'Angular' 등이 포함된 경우)
UPDATE freelancers 
SET description = CASE 
    WHEN RAND() < 0.2 THEN '풀스택 웹 개발자로 10년 이상의 경력을 보유하고 있습니다. React, Vue.js를 활용한 SPA 개발과 Node.js 기반 백엔드 구축에 전문성을 가지고 있으며, 대규모 이커머스 플랫폼 구축 경험이 있습니다. 클린 코드와 테스트 주도 개발을 추구하며, 애자일 환경에서의 협업에 능숙합니다.'
    WHEN RAND() < 0.4 THEN '프론트엔드 전문 개발자입니다. 사용자 경험을 최우선으로 생각하며, 반응형 웹 디자인과 웹 접근성을 고려한 개발을 지향합니다. React와 TypeScript를 주력으로 사용하며, 최신 웹 표준과 성능 최적화에 깊은 관심을 가지고 있습니다. 스타트업부터 대기업까지 다양한 규모의 프로젝트를 성공적으로 수행했습니다.'
    WHEN RAND() < 0.6 THEN '백엔드 개발에 특화된 웹 개발자입니다. RESTful API 설계와 마이크로서비스 아키텍처 구축 경험이 풍부하며, AWS를 활용한 클라우드 인프라 구성에도 능숙합니다. 대용량 트래픽 처리와 데이터베이스 최적화에 전문성을 보유하고 있으며, DevOps 문화 확산에도 기여하고 있습니다.'
    WHEN RAND() < 0.8 THEN '창의적인 웹 개발자로서 UI/UX 디자인에도 깊은 이해를 가지고 있습니다. 최신 JavaScript 프레임워크를 활용한 인터랙티브한 웹 애플리케이션 개발이 전문이며, 웹 애니메이션과 3D 그래픽스 구현 경험도 있습니다. 사용자 중심의 제품 개발을 추구하며, A/B 테스트를 통한 지속적인 개선을 중요시합니다.'
    ELSE '경험 많은 웹 개발자로서 다양한 산업 분야의 프로젝트를 수행했습니다. 프론트엔드와 백엔드 모두에 능숙하며, 프로젝트 요구사항에 맞는 최적의 기술 스택을 선택하고 구현할 수 있습니다. 팀 리더십 경험이 있으며, 주니어 개발자 멘토링에도 적극적입니다.'
END
WHERE JSON_SEARCH(skills, 'one', 'React') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Vue') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Angular') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'JavaScript') IS NOT NULL;

-- 2. 모바일 개발자 타입 (skills에 'iOS', 'Android', 'Flutter' 등이 포함된 경우)
UPDATE freelancers 
SET description = CASE 
    WHEN RAND() < 0.25 THEN 'iOS 네이티브 앱 개발 전문가입니다. Swift와 SwiftUI를 활용한 최신 iOS 앱 개발에 능숙하며, 앱스토어 출시 경험이 50개 이상입니다. 사용자 경험을 최우선으로 생각하며, 성능 최적화와 메모리 관리에 깊은 이해를 가지고 있습니다. Core Data, CloudKit 등 iOS 생태계 전반에 대한 전문성을 보유하고 있습니다.'
    WHEN RAND() < 0.5 THEN 'Android 앱 개발 전문가로 Kotlin과 Java를 활용한 네이티브 앱 개발에 10년 이상의 경력을 보유하고 있습니다. Material Design 가이드라인을 준수한 UI/UX 구현과 다양한 디바이스 대응에 능숙합니다. Google Play 스토어 최적화와 Firebase를 활용한 앱 분석에도 전문성이 있습니다.'
    WHEN RAND() < 0.75 THEN 'Flutter를 활용한 크로스 플랫폼 모바일 앱 개발 전문가입니다. 하나의 코드베이스로 iOS와 Android 앱을 동시에 개발하여 개발 효율성을 극대화합니다. 네이티브 수준의 성능과 사용자 경험을 구현하며, 다양한 써드파티 라이브러리 통합 경험이 풍부합니다.'
    ELSE '모바일 풀스택 개발자로서 앱 개발뿐만 아니라 백엔드 API 개발까지 가능합니다. React Native와 네이티브 개발 모두에 능숙하며, 프로젝트 요구사항에 따라 최적의 기술을 선택합니다. 푸시 알림, 결제 시스템, 소셜 로그인 등 다양한 기능 구현 경험이 있습니다.'
END
WHERE JSON_SEARCH(skills, 'one', 'iOS') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Android') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Flutter') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'React Native') IS NOT NULL;

-- 3. 백엔드/서버 개발자 타입 (skills에 'Java', 'Spring', 'Node.js', 'Python' 등이 포함된 경우)
UPDATE freelancers 
SET description = CASE 
    WHEN RAND() < 0.25 THEN 'Java/Spring 기반 엔터프라이즈 애플리케이션 개발 전문가입니다. MSA(마이크로서비스 아키텍처) 설계와 구현, Spring Cloud를 활용한 분산 시스템 구축 경험이 풍부합니다. JPA/Hibernate를 활용한 ORM 설계와 성능 튜닝에 능숙하며, 대용량 트랜잭션 처리 시스템 구축 경험이 있습니다.'
    WHEN RAND() < 0.5 THEN 'Python 백엔드 개발자로 Django, FastAPI를 활용한 웹 서비스 개발에 전문성을 가지고 있습니다. 데이터 분석과 머신러닝 모델 서빙 경험이 있으며, 비동기 프로그래밍과 성능 최적화에 능숙합니다. Docker와 Kubernetes를 활용한 컨테이너 기반 배포에도 경험이 풍부합니다.'
    WHEN RAND() < 0.75 THEN 'Node.js 전문 백엔드 개발자입니다. Express.js, NestJS를 활용한 RESTful API 및 GraphQL 서버 구축에 능숙하며, 실시간 통신을 위한 WebSocket 구현 경험도 풍부합니다. MongoDB, PostgreSQL 등 다양한 데이터베이스를 다룰 수 있으며, 서버리스 아키텍처 구축에도 전문성이 있습니다.'
    ELSE '다년간의 백엔드 개발 경험을 보유한 시니어 개발자입니다. 확장 가능하고 유지보수가 용이한 시스템 설계를 추구하며, CI/CD 파이프라인 구축과 모니터링 시스템 구성에도 능숙합니다. 보안에 대한 깊은 이해를 바탕으로 안전한 서비스 구축을 최우선으로 합니다.'
END
WHERE JSON_SEARCH(skills, 'one', 'Java') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Spring') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Node.js') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'Python') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'Django') IS NOT NULL;

-- 4. 데이터 분야 (skills에 'SQL', 'Python', 'R', 'Tableau' 등이 포함된 경우)
UPDATE freelancers 
SET description = CASE 
    WHEN RAND() < 0.25 THEN '데이터 분석가로서 비즈니스 인사이트 도출에 전문성을 가지고 있습니다. SQL과 Python을 활용한 데이터 추출 및 전처리, 통계 분석과 시각화까지 End-to-End 분석이 가능합니다. Tableau와 Power BI를 활용한 대시보드 구축으로 경영진 의사결정을 지원한 경험이 풍부합니다.'
    WHEN RAND() < 0.5 THEN '빅데이터 엔지니어로 대용량 데이터 처리 파이프라인 구축에 전문성이 있습니다. Hadoop, Spark를 활용한 분산 처리 시스템 구축과 실시간 스트리밍 데이터 처리 경험이 풍부합니다. 데이터 웨어하우스 설계와 ETL 프로세스 최적화에도 능숙합니다.'
    WHEN RAND() < 0.75 THEN '데이터 사이언티스트로서 머신러닝과 딥러닝 모델 개발에 전문성을 가지고 있습니다. 예측 모델링, 추천 시스템, 자연어 처리 등 다양한 AI 프로젝트를 수행했으며, 모델의 비즈니스 적용과 성과 측정까지 전 과정을 담당할 수 있습니다.'
    ELSE '데이터 전문가로서 데이터 거버넌스와 품질 관리에 깊은 이해를 가지고 있습니다. 데이터 수집부터 분석, 시각화까지 전체 데이터 라이프사이클을 관리할 수 있으며, 비즈니스 요구사항을 데이터 기반 솔루션으로 구현하는데 능숙합니다.'
END
WHERE JSON_SEARCH(skills, 'one', 'SQL') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Python') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'R') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'Tableau') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'Data Analysis') IS NOT NULL;

-- 5. 디자인 분야 (skills에 'UI/UX', 'Figma', 'Sketch', 'Adobe' 등이 포함된 경우)
UPDATE freelancers 
SET description = CASE 
    WHEN RAND() < 0.25 THEN 'UI/UX 디자이너로서 사용자 중심의 디자인을 추구합니다. 사용자 리서치부터 와이어프레임, 프로토타이핑, 최종 디자인까지 전체 디자인 프로세스를 수행할 수 있습니다. Figma와 Sketch를 능숙하게 다루며, 디자인 시스템 구축 경험도 풍부합니다.'
    WHEN RAND() < 0.5 THEN '비주얼 디자이너로서 브랜드 아이덴티티와 마케팅 디자인에 전문성을 가지고 있습니다. Adobe Creative Suite를 마스터했으며, 인쇄물부터 디지털 콘텐츠까지 다양한 매체의 디자인이 가능합니다. 트렌디하면서도 목적에 부합하는 디자인을 추구합니다.'
    WHEN RAND() < 0.75 THEN '프로덕트 디자이너로서 비즈니스 목표와 사용자 니즈의 균형을 맞춘 디자인을 추구합니다. 데이터 기반 디자인 의사결정과 A/B 테스트를 통한 지속적인 개선에 능숙하며, 개발팀과의 원활한 협업을 통해 디자인의 완성도를 높입니다.'
    ELSE '경험 많은 디자이너로서 다양한 산업 분야의 디자인 프로젝트를 수행했습니다. 사용자 경험 설계부터 비주얼 디자인까지 폭넓은 역량을 보유하고 있으며, 클라이언트의 요구사항을 정확히 파악하고 창의적인 솔루션을 제공합니다.'
END
WHERE JSON_SEARCH(skills, 'one', 'UI/UX') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Figma') IS NOT NULL 
   OR JSON_SEARCH(skills, 'one', 'Sketch') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'Adobe') IS NOT NULL
   OR JSON_SEARCH(skills, 'one', 'Design') IS NOT NULL;

-- 6. 나머지 프리랜서들을 위한 일반적인 설명
UPDATE freelancers 
SET description = CASE 
    WHEN RAND() < 0.2 THEN '다년간의 프리랜서 경험을 통해 다양한 프로젝트를 성공적으로 수행해왔습니다. 클라이언트와의 원활한 소통을 중요시하며, 프로젝트 요구사항을 정확히 파악하고 기한 내에 고품질의 결과물을 제공합니다. 새로운 도전을 두려워하지 않으며, 지속적인 학습을 통해 전문성을 높이고 있습니다.'
    WHEN RAND() < 0.4 THEN '전문성과 책임감을 바탕으로 프리랜서 활동을 하고 있습니다. 프로젝트의 목표를 명확히 이해하고, 효율적인 방법으로 해결책을 제시합니다. 팀워크를 중요시하며, 원격 근무 환경에서도 원활한 협업이 가능합니다. 품질과 납기를 동시에 만족시키는 것을 목표로 합니다.'
    WHEN RAND() < 0.6 THEN '창의적이고 혁신적인 솔루션을 제공하는 프리랜서입니다. 문제 해결 능력이 뛰어나며, 복잡한 요구사항도 체계적으로 분석하여 최적의 방안을 도출합니다. 고객 만족을 최우선으로 생각하며, 프로젝트 성공을 위해 최선을 다합니다.'
    WHEN RAND() < 0.8 THEN '열정적이고 성실한 프리랜서로서 맡은 일에 대한 책임감이 강합니다. 디테일에 신경쓰며, 완성도 높은 결과물을 만들어냅니다. 피드백을 적극적으로 수용하고, 지속적인 개선을 통해 더 나은 서비스를 제공하고자 노력합니다.'
    ELSE '신뢰할 수 있는 프리랜서로서 안정적인 프로젝트 수행 능력을 보유하고 있습니다. 체계적인 일정 관리와 진행 상황 공유를 통해 투명한 프로젝트 진행을 보장합니다. 다양한 산업 분야의 경험을 바탕으로 폭넓은 시각에서 문제를 바라보고 해결합니다.'
END
WHERE description IS NULL OR description = '';

-- 실행 결과 확인
SELECT 
    COUNT(*) as total_updated,
    COUNT(CASE WHEN description IS NOT NULL AND description != '' THEN 1 END) as with_description
FROM freelancers;
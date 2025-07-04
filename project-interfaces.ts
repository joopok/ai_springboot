/**
 * Project 관련 TypeScript 인터페이스 정의
 * Spring Boot 엔티티와 DTO를 기반으로 생성됨
 */

/**
 * Project 엔티티 인터페이스
 * @interface Project
 */
export interface Project {
  // 기본 정보
  id: number;
  companyId: number;
  clientId: number;
  categoryId: number;
  category: string;
  title: string;
  description: string;
  
  // 프로젝트 타입 정보
  projectType: 'full_time' | 'part_time' | 'contract' | 'freelance' | 'internship';
  budgetType: 'fixed' | 'hourly' | 'negotiable';
  workType: 'remote' | 'onsite' | 'hybrid';
  location: string;
  
  // 예산 정보
  budgetMin: number;
  budgetMax: number;
  
  // 일정 정보
  duration: string;
  startDate: string; // ISO 8601 format (YYYY-MM-DD)
  deadline: string; // ISO 8601 format (YYYY-MM-DD)
  
  // 스킬 및 경험 요구사항
  requiredSkills: string; // JSON string
  preferredSkills: string; // JSON string
  experienceYears: number;
  experienceLevel: 'junior' | 'mid' | 'senior' | 'expert';
  
  // 상태 정보
  status: 'draft' | 'active' | 'in_progress' | 'closed' | 'completed' | 'cancelled';
  views: number;
  applications: number;
  applicationsCount: number;
  isFeatured: boolean;
  isUrgent: boolean;
  
  // 시간 정보
  createdAt: string; // ISO 8601 format (YYYY-MM-DDTHH:mm:ss)
  updatedAt: string; // ISO 8601 format (YYYY-MM-DDTHH:mm:ss)
  
  // Join된 정보
  companyName: string;
  companyLogo: string;
  clientName: string;
  categoryName: string;
  
  // 추가 정보
  isBookmarked: boolean;
  hasApplied: boolean;
  bookmarkCount: number;
}

/**
 * Project 생성/수정용 DTO 인터페이스
 * @interface ProjectDto
 */
export interface ProjectDto {
  companyId?: number;
  clientId?: number;
  categoryId?: number;
  category?: string;
  title: string;
  description: string;
  projectType?: 'full_time' | 'part_time' | 'contract' | 'freelance' | 'internship';
  budgetType?: 'fixed' | 'hourly' | 'negotiable';
  workType?: 'remote' | 'onsite' | 'hybrid';
  location?: string;
  budgetMin?: number;
  budgetMax?: number;
  duration?: string;
  startDate?: string;
  deadline?: string;
  requiredSkills?: string;
  preferredSkills?: string;
  experienceYears?: number;
  experienceLevel?: 'junior' | 'mid' | 'senior' | 'expert';
  status?: 'draft' | 'active' | 'in_progress' | 'closed' | 'completed' | 'cancelled';
  isFeatured?: boolean;
  isUrgent?: boolean;
}

/**
 * 프로젝트 지원 요청 DTO
 * @interface ProjectApplicationRequest
 */
export interface ProjectApplicationRequest {
  projectId: number; // @NotNull - 필수
  coverLetter?: string; // @Size(max = 5000) - 최대 5000자
  proposedBudget?: number;
}

/**
 * 스킬 배열 타입 (requiredSkills, preferredSkills JSON 파싱 후 사용)
 */
export type SkillArray = string[];

/**
 * 프로젝트 타입 enum
 */
export enum ProjectType {
  FULL_TIME = 'full_time',
  PART_TIME = 'part_time',
  CONTRACT = 'contract',
  FREELANCE = 'freelance',
  INTERNSHIP = 'internship'
}

/**
 * 예산 타입 enum
 */
export enum BudgetType {
  FIXED = 'fixed',
  HOURLY = 'hourly',
  NEGOTIABLE = 'negotiable'
}

/**
 * 근무 형태 enum
 */
export enum WorkType {
  REMOTE = 'remote',
  ONSITE = 'onsite',
  HYBRID = 'hybrid'
}

/**
 * 경험 레벨 enum
 */
export enum ExperienceLevel {
  JUNIOR = 'junior',
  MID = 'mid',
  SENIOR = 'senior',
  EXPERT = 'expert'
}

/**
 * 프로젝트 상태 enum
 */
export enum ProjectStatus {
  DRAFT = 'draft',
  ACTIVE = 'active',
  IN_PROGRESS = 'in_progress',
  CLOSED = 'closed',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled'
}

/**
 * 유틸리티 타입: 부분 업데이트용
 */
export type PartialProject = Partial<Project>;

/**
 * 유틸리티 타입: 프로젝트 목록 조회 응답
 */
export interface ProjectListResponse {
  content: Project[];
  totalElements: number;
  totalPages: number;
  page: number;
  size: number;
  first: boolean;
  last: boolean;
}

/**
 * 유틸리티 타입: 프로젝트 필터
 */
export interface ProjectFilter {
  categoryId?: number;
  projectType?: ProjectType;
  budgetType?: BudgetType;
  workType?: WorkType;
  experienceLevel?: ExperienceLevel;
  status?: ProjectStatus;
  budgetMin?: number;
  budgetMax?: number;
  keyword?: string;
  companyId?: number;
  clientId?: number;
}

/**
 * 스킬 파싱 헬퍼 함수
 */
export const parseSkills = (skillsJson: string): string[] => {
  try {
    return JSON.parse(skillsJson) as string[];
  } catch {
    return [];
  }
};

/**
 * 날짜 포맷 헬퍼 함수
 */
export const formatDate = (dateString: string): Date => {
  return new Date(dateString);
};
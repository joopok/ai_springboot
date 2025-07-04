package com.fid.job.dto;

import lombok.Data;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.math.BigDecimal;

@Data
public class ProjectApplicationRequest {
    
    @NotNull(message = "프로젝트 ID는 필수입니다")
    private Long projectId;
    
    @Size(max = 5000, message = "자기소개서는 5000자를 초과할 수 없습니다")
    private String coverLetter;
    
    private BigDecimal proposedBudget;
}
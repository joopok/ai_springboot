package com.example.pm7.aop;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.slf4j.MDC;
import java.util.UUID;
import java.util.Arrays;
import org.springframework.security.authentication.BadCredentialsException;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    // Controller 패키지 포인트컷
    @Pointcut("execution(* com.example.pm7.controller..*.*(..))")
    private void controllerPointcut() {}

    // Service 패키지 포인트컷
    @Pointcut("execution(* com.example.pm7.service..*.*(..))")
    private void servicePointcut() {}

    // Controller 메소드 로깅
    @Around("controllerPointcut()")
    public Object logController(ProceedingJoinPoint joinPoint) throws Throwable {
        MDC.put("requestId", UUID.randomUUID().toString());
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        
        log.info("==> Starting {} in {}", methodName, className);
        
        // 메소드 파라미터 로깅
        Object[] args = joinPoint.getArgs();
        if (args != null && args.length > 0) {
            log.debug("Method arguments: {}", Arrays.toString(args));
        }
        
        long start = System.currentTimeMillis();
        try {
            Object result = joinPoint.proceed();
            long executionTime = System.currentTimeMillis() - start;
            
            log.info("<== Finished {} in {}ms", methodName, executionTime);
            MDC.clear();
            return result;
        } catch (BadCredentialsException e) {
            // 인증 실패는 WARNING 레벨로 로깅
            log.warn("Authentication failed in {}.{}: {}", className, methodName, e.getMessage());
            throw e;
        } catch (Exception e) {
            // 그 외 예외는 ERROR 레벨로 로깅
            log.error("Exception in {}.{}: {}", className, methodName, e.getMessage());
            throw e;
        }
    }

    // Service 메소드 로깅
    @Around("servicePointcut()")
    public Object logService(ProceedingJoinPoint joinPoint) throws Throwable {
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        
        log.debug("→ Service - {}.{} - Start", className, methodName);
        Object result = joinPoint.proceed();
        log.debug("← Service - {}.{} - End", className, methodName);
        
        return result;
    }
} 
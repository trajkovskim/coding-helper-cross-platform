package mk.com.codehelp.core.aspect;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import com.fasterxml.jackson.databind.ObjectMapper;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class RequestLoggerAspect {

  private final ObjectMapper objectMapper;

  @Pointcut("execution(* mk.com.codehelp.core.rest.api*.*(..)) || execution(* mk.com.codehelp.core.rest.admin.api.*.*(..))")
  public void controllerPointcut() {
  }

  @Around("controllerPointcut()")
  public Object executedMethodsLogger(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {

    log.info(
        "Executed method {}, arguments {}",
        proceedingJoinPoint.toString(),
        objectMapper.writeValueAsString(proceedingJoinPoint.getArgs()));

    return proceedingJoinPoint.proceed();
  }
}

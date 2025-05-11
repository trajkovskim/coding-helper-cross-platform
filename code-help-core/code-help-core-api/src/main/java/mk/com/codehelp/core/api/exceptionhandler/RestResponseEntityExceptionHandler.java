package mk.com.codehelp.core.api.exceptionhandler;

import mk.com.codehelp.core.api.mappers.DateTimeMapper;
import mk.com.codehelp.core.rest.model.ErrorResponse;
import mk.com.codehelp.core.service.exceptions.ProblemNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;

import lombok.RequiredArgsConstructor;

@ControllerAdvice
@RequiredArgsConstructor
public class RestResponseEntityExceptionHandler extends ResponseEntityExceptionHandler {

  @ExceptionHandler(value = RuntimeException.class)
  ResponseEntity<Object> handleUnknownException(RuntimeException ex) {
    ErrorResponse errorResponse = new ErrorResponse()
        .message(ex.getMessage() != null ? ex.getMessage() : ex.getCause().getMessage())
        .status(HttpStatus.BAD_REQUEST.value())
        .code(HttpStatus.BAD_REQUEST.getReasonPhrase())
        .timestamp(OffsetDateTime.now());
    return buildResponseEntity(errorResponse);
  }

  @ExceptionHandler(value = IOException.class)
  ResponseEntity<Object> handleIOException(RuntimeException ex) {
    ErrorResponse errorResponse = new ErrorResponse()
        .message(ex.getMessage())
        .status(HttpStatus.BAD_REQUEST.value())
        .timestamp(OffsetDateTime.now());
    return buildResponseEntity(errorResponse);
  }

  @ExceptionHandler(value = ProblemNotFoundException.class)
  ResponseEntity<Object> handleProblemNotFoundException(ProblemNotFoundException ex) {
    ErrorResponse errorResponse = new ErrorResponse()
        .message(ex.getMessage())
        .status(HttpStatus.NOT_FOUND.value())
        .timestamp(OffsetDateTime.now());
    return buildResponseEntity(errorResponse);
  }

  ResponseEntity<Object> buildResponseEntity(ErrorResponse errorResponse) {
    return new ResponseEntity<>(errorResponse, HttpStatus.valueOf(errorResponse.getStatus()));
  }
}

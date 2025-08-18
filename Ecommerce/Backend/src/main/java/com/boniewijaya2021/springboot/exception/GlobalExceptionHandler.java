package com.boniewijaya2021.springboot.exception;

import com.boniewijaya2021.springboot.utility.MessageModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;

import jakarta.validation.ConstraintViolationException;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<MessageModel> handleValidationExceptions(MethodArgumentNotValidException ex) {
        MessageModel response = new MessageModel();
        Map<String, String> errors = new HashMap<>();
        
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        
        response.setStatus(false);
        response.setMessage("Validation failed");
        response.setData(errors);
        
        logger.warn("Validation error: {}", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<MessageModel> handleConstraintViolationException(ConstraintViolationException ex) {
        MessageModel response = new MessageModel();
        Map<String, String> errors = new HashMap<>();
        
        ex.getConstraintViolations().forEach(violation -> {
            String fieldName = violation.getPropertyPath().toString();
            String errorMessage = violation.getMessage();
            errors.put(fieldName, errorMessage);
        });
        
        response.setStatus(false);
        response.setMessage("Constraint violation");
        response.setData(errors);
        
        logger.warn("Constraint violation: {}", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<MessageModel> handleDataIntegrityViolationException(DataIntegrityViolationException ex) {
        MessageModel response = new MessageModel();
        response.setStatus(false);
        response.setMessage("Data integrity violation. Please check your input.");
        
        logger.error("Data integrity violation", ex);
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<MessageModel> handleAccessDeniedException(AccessDeniedException ex) {
        MessageModel response = new MessageModel();
        response.setStatus(false);
        response.setMessage("Access denied. You don't have permission to perform this action.");
        
        logger.warn("Access denied: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<MessageModel> handleGenericException(Exception ex) {
        MessageModel response = new MessageModel();
        response.setStatus(false);
        response.setMessage("An unexpected error occurred. Please try again later.");
        
        logger.error("Unexpected error", ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
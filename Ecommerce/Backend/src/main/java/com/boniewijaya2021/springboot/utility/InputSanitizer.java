package com.boniewijaya2021.springboot.utility;

import org.springframework.stereotype.Component;
import java.util.regex.Pattern;

@Component
public class InputSanitizer {

    private static final Pattern HTML_PATTERN = Pattern.compile("<[^>]+>");
    private static final Pattern SCRIPT_PATTERN = Pattern.compile("(?i)<script[^>]*>.*?</script>");
    private static final Pattern SQL_INJECTION_PATTERN = Pattern.compile("(?i)(union|select|insert|update|delete|drop|create|alter|exec|execute|script|javascript|vbscript|onload|onerror|onclick)");

    public String sanitizeHtml(String input) {
        if (input == null) return null;
        
        // Remove script tags first
        String sanitized = SCRIPT_PATTERN.matcher(input).replaceAll("");
        
        // Remove all HTML tags
        sanitized = HTML_PATTERN.matcher(sanitized).replaceAll("");
        
        // Escape special characters
        sanitized = sanitized.replaceAll("&", "&amp;")
                            .replaceAll("<", "&lt;")
                            .replaceAll(">", "&gt;")
                            .replaceAll("\"", "&quot;")
                            .replaceAll("'", "&#x27;")
                            .replaceAll("/", "&#x2F;");
        
        return sanitized.trim();
    }

    public String sanitizeForDatabase(String input) {
        if (input == null) return null;
        
        // Remove potential SQL injection patterns
        String sanitized = SQL_INJECTION_PATTERN.matcher(input).replaceAll("");
        
        // Escape single quotes for SQL
        sanitized = sanitized.replaceAll("'", "''");
        
        return sanitized.trim();
    }

    public String sanitizeFileName(String fileName) {
        if (fileName == null) return null;
        
        // Remove path traversal attempts
        String sanitized = fileName.replaceAll("\\.\\./", "")
                                  .replaceAll("\\.\\.\\\\", "")
                                  .replaceAll("[^a-zA-Z0-9._-]", "_");
        
        return sanitized;
    }

    public boolean isValidEmail(String email) {
        if (email == null) return false;
        
        Pattern emailPattern = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        );
        
        return emailPattern.matcher(email).matches() && email.length() <= 254;
    }

    public boolean containsSqlInjection(String input) {
        if (input == null) return false;
        return SQL_INJECTION_PATTERN.matcher(input).find();
    }

    public boolean containsXss(String input) {
        if (input == null) return false;
        return SCRIPT_PATTERN.matcher(input).find() || 
               input.toLowerCase().contains("javascript:") ||
               input.toLowerCase().contains("vbscript:") ||
               input.toLowerCase().contains("onload=") ||
               input.toLowerCase().contains("onerror=");
    }
}
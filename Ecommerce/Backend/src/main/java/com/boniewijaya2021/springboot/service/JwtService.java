package com.boniewijaya2021.springboot.service;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Locale;

@Service
public class JwtService {

    private static final Logger logger = LoggerFactory.getLogger(JwtService.class);
    
    @Value("${jwt.secret:mySecretKey123456789012345678901234567890}")
    private String secretKey;
    
    @Value("${jwt.expiration:86400000}")
    private long jwtExpiration;

    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
    }

    public String generateToken(Long userId, String email) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("email", email);
        
        return Jwts.builder()
                .claims(claims)
                .subject(email)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(getSigningKey())
                .compact();
    }

    public Long extractUserId(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return null;
            }
            
            // Remove Bearer prefix if present
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            
            Claims claims = Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
                    
            Object userIdObj = claims.get("userId");
            if (userIdObj instanceof Integer) {
                return ((Integer) userIdObj).longValue();
            } else if (userIdObj instanceof Long) {
                return (Long) userIdObj;
            }
            
            return null;
        } catch (JwtException e) {
            logger.warn("Invalid JWT token", e);
            return null;
        } catch (Exception e) {
            logger.error("Error extracting user ID from token", e);
            return null;
        }
    }

    public String extractEmail(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return null;
            }
            
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            
            Claims claims = Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
                    
            return claims.getSubject();
        } catch (JwtException e) {
            logger.warn("Invalid JWT token", e);
            return null;
        } catch (Exception e) {
            logger.error("Error extracting email from token", e);
            return null;
        }
    }

    public boolean isTokenValid(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return false;
            }
            
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            
            Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token);
                    
            return true;
        } catch (JwtException e) {
            logger.warn("Invalid JWT token", e);
            return false;
        } catch (Exception e) {
            logger.error("Error validating token", e);
            return false;
        }
    }

    public boolean isTokenExpired(String token) {
        try {
            if (token == null || token.trim().isEmpty()) {
                return true;
            }
            
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            
            Claims claims = Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
                    
            return claims.getExpiration().before(new Date());
        } catch (JwtException e) {
            return true;
        } catch (Exception e) {
            logger.error("Error checking token expiration", e);
            return true;
        }
    }
}
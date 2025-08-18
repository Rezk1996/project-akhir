package com.boniewijaya2021.springboot.repository;

import com.boniewijaya2021.springboot.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    
    @Modifying
    @Transactional
    @Query(value = "INSERT INTO users (name, email, password, role, created_at, updated_at) VALUES (:name, :email, :password, :role::user_role_type, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)", nativeQuery = true)
    void insertUser(@Param("name") String name, @Param("email") String email, @Param("password") String password, @Param("role") String role);
}

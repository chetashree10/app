-- Initialize database for Spring Boot application

CREATE DATABASE IF NOT EXISTS appdb;

USE appdb;

-- Sample table (optional, JPA can manage schema)
CREATE TABLE IF NOT EXISTS sample_entity (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SQLite
-- Create the users table with additional fields
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    hashed_password TEXT NOT NULL,
    age INTEGER NOT NULL,
    promo_type TEXT CHECK(promo_type IN ('A', 'B', 'C', 'D')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert test users with bcrypt hashed passwords
-- Note: All test users have password "testpass123"
INSERT INTO users (username, email, full_name, hashed_password, age, promo_type) 
VALUES 
    ('john_doe', 'john@example.com', 'John Doe', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     28, 'A'),
    ('jane_smith', 'jane@example.com', 'Jane Smith', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     34, 'B'),
    ('mike_wilson', 'mike@example.com', 'Mike Wilson', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     45, 'C'),
    ('sarah_jones', 'sarah@example.com', 'Sarah Jones', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     29, 'A'),
    ('bob_brown', 'bob@example.com', 'Bob Brown', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     52, 'D'),
    ('lisa_garcia', 'lisa@example.com', 'Lisa Garcia', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     31, 'B'),
    ('david_miller', 'david@example.com', 'David Miller', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     38, 'C'),
    ('emma_davis', 'emma@example.com', 'Emma Davis', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     27, 'A'),
    ('james_wilson', 'james@example.com', 'James Wilson', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     41, 'D'),
    ('maria_rodriguez', 'maria@example.com', 'Maria Rodriguez', 
     '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewenkzpfbpTQYh6.', 
     33, 'B');

-- Create an index on username and email for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Create a view for user statistics (optional but useful for testing)
CREATE VIEW IF NOT EXISTS user_statistics AS
SELECT 
    promo_type,
    COUNT(*) as user_count,
    AVG(age) as average_age,
    MIN(age) as min_age,
    MAX(age) as max_age
FROM users
GROUP BY promo_type;
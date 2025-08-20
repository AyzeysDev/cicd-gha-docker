-- Initialize nursing home database
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create basic tables for demo
CREATE TABLE IF NOT EXISTS residents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    admission_date DATE NOT NULL DEFAULT CURRENT_DATE,
    room_number VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO residents (first_name, last_name, date_of_birth, room_number) 
VALUES 
    ('John', 'Doe', '1940-05-15', '101A'),
    ('Jane', 'Smith', '1935-12-22', '102B'),
    ('Robert', 'Johnson', '1942-08-30', '103A')
ON CONFLICT DO NOTHING;
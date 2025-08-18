-- Enhanced Employee Management System Schema

-- 1. Update tenaga_kerja table with complete employee data
ALTER TABLE tenaga_kerja 
ADD COLUMN IF NOT EXISTS user_id BIGINT REFERENCES users(id),
ADD COLUMN IF NOT EXISTS employee_id VARCHAR(20) UNIQUE,
ADD COLUMN IF NOT EXISTS position VARCHAR(100),
ADD COLUMN IF NOT EXISTS department VARCHAR(100),
ADD COLUMN IF NOT EXISTS hire_date DATE,
ADD COLUMN IF NOT EXISTS salary DECIMAL(15,2),
ADD COLUMN IF NOT EXISTS phone VARCHAR(20),
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS emergency_contact VARCHAR(100),
ADD COLUMN IF NOT EXISTS emergency_phone VARCHAR(20),
ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active',
ADD COLUMN IF NOT EXISTS photo VARCHAR(255),
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- 2. Create attendance table
CREATE TABLE IF NOT EXISTS attendance (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES tenaga_kerja(id),
    date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    check_in_photo VARCHAR(255),
    check_out_photo VARCHAR(255),
    check_in_location VARCHAR(255),
    check_out_location VARCHAR(255),
    work_hours DECIMAL(4,2),
    status VARCHAR(20) DEFAULT 'present', -- present, absent, late, half_day
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(employee_id, date)
);

-- 3. Create payroll table
CREATE TABLE IF NOT EXISTS payroll (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES tenaga_kerja(id),
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    basic_salary DECIMAL(15,2),
    overtime_hours DECIMAL(4,2) DEFAULT 0,
    overtime_rate DECIMAL(10,2) DEFAULT 0,
    bonus DECIMAL(15,2) DEFAULT 0,
    deductions DECIMAL(15,2) DEFAULT 0,
    total_salary DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'pending', -- pending, paid, cancelled
    paid_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(employee_id, month, year)
);

-- 4. Create leave_requests table
CREATE TABLE IF NOT EXISTS leave_requests (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES tenaga_kerja(id),
    leave_type VARCHAR(50) NOT NULL, -- sick, annual, emergency, maternity
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested INTEGER NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- pending, approved, rejected
    approved_by INTEGER REFERENCES users(id),
    approved_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 5. Update shift_kerja table
ALTER TABLE shift_kerja 
ADD COLUMN IF NOT EXISTS description TEXT,
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT NOW();

-- 6. Insert sample shift data
INSERT INTO shift_kerja (nama_shift, jam_mulai, jam_selesai, description) VALUES
('Pagi', '08:00:00', '16:00:00', 'Shift pagi 8 jam kerja'),
('Siang', '12:00:00', '20:00:00', 'Shift siang 8 jam kerja'),
('Malam', '20:00:00', '04:00:00', 'Shift malam 8 jam kerja')
ON CONFLICT DO NOTHING;

-- 7. Create admin user for employee management
INSERT INTO users (name, email, password, role, created_at, active) VALUES
('Admin HR', 'admin@rmart.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', NOW(), true)
ON CONFLICT (email) DO UPDATE SET 
    role = 'admin',
    active = true,
    updated_at = NOW();

-- 8. Insert sample employee data
INSERT INTO tenaga_kerja (nama, employee_id, position, department, hire_date, salary, phone, shift_id, status) VALUES
('Budi Santoso', 'EMP001', 'Kasir', 'Operations', '2024-01-15', 4500000, '081234567890', 1, 'active'),
('Siti Nurhaliza', 'EMP002', 'Admin', 'Administration', '2024-02-01', 5000000, '081234567891', 1, 'active'),
('Ahmad Wijaya', 'EMP003', 'Security', 'Security', '2024-01-20', 4000000, '081234567892', 2, 'active')
ON CONFLICT (employee_id) DO NOTHING;

-- 9. Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_attendance_employee_date ON attendance(employee_id, date);
CREATE INDEX IF NOT EXISTS idx_payroll_employee_period ON payroll(employee_id, year, month);
CREATE INDEX IF NOT EXISTS idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_tenaga_kerja_employee_id ON tenaga_kerja(employee_id);

-- 10. Create views for reporting
CREATE OR REPLACE VIEW employee_summary AS
SELECT 
    tk.id,
    tk.employee_id,
    tk.nama,
    tk.position,
    tk.department,
    tk.hire_date,
    tk.salary,
    tk.status,
    sk.nama_shift,
    u.email,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, tk.hire_date)) as years_of_service
FROM tenaga_kerja tk
LEFT JOIN shift_kerja sk ON tk.shift_id = sk.id
LEFT JOIN users u ON tk.user_id = u.id;

CREATE OR REPLACE VIEW monthly_attendance_summary AS
SELECT 
    tk.employee_id,
    tk.nama,
    EXTRACT(YEAR FROM a.date) as year,
    EXTRACT(MONTH FROM a.date) as month,
    COUNT(*) as total_days,
    COUNT(CASE WHEN a.status = 'present' THEN 1 END) as present_days,
    COUNT(CASE WHEN a.status = 'late' THEN 1 END) as late_days,
    COUNT(CASE WHEN a.status = 'absent' THEN 1 END) as absent_days,
    AVG(a.work_hours) as avg_work_hours
FROM tenaga_kerja tk
LEFT JOIN attendance a ON tk.id = a.employee_id
GROUP BY tk.employee_id, tk.nama, EXTRACT(YEAR FROM a.date), EXTRACT(MONTH FROM a.date);
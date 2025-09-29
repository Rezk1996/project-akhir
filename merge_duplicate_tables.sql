-- Merge Duplicate Tables - R-Mart Database Cleanup
-- Mengatasi konflik tabel dengan fungsi duplikat

BEGIN;

-- 1. MERGE user_profiles INTO users
UPDATE users 
SET 
    phone = COALESCE(up.phone_number, users.phone),
    address = COALESCE(up.address, users.address),
    birth_date = CASE WHEN up.date_of_birth ~ '^\d{4}-\d{2}-\d{2}$' THEN up.date_of_birth::DATE ELSE users.birth_date END,
    gender = COALESCE(up.gender, users.gender),
    updated_at = CURRENT_TIMESTAMP
FROM user_profiles up 
WHERE users.id = up.user_id AND EXISTS (SELECT 1 FROM user_profiles);

DROP TABLE IF EXISTS user_profiles CASCADE;

-- 2. MERGE tenaga_kerja INTO employees
INSERT INTO employees (employee_id, nama, email, phone, position, department, salary, hire_date, status, shift_id, created_at)
SELECT DISTINCT
    COALESCE(tk.employee_id, 'EMP' || tk.id),
    tk.nama,
    tk.email,
    tk.phone,
    tk.position,
    tk.department,
    tk.salary,
    tk.hire_date,
    COALESCE(tk.status, 'active'),
    tk.shift_id,
    COALESCE(tk.created_at, CURRENT_TIMESTAMP)
FROM tenaga_kerja tk
WHERE EXISTS (SELECT 1 FROM tenaga_kerja)
AND NOT EXISTS (SELECT 1 FROM employees e WHERE e.employee_id = COALESCE(tk.employee_id, 'EMP' || tk.id))
ON CONFLICT (employee_id) DO NOTHING;

DROP TABLE IF EXISTS tenaga_kerja CASCADE;

-- 3. MERGE shift_kerja INTO shifts
INSERT INTO shifts (nama_shift, jam_mulai, jam_selesai, description)
SELECT DISTINCT
    sk.nama_shift,
    sk.jam_mulai,
    sk.jam_selesai,
    sk.description
FROM shift_kerja sk
WHERE EXISTS (SELECT 1 FROM shift_kerja)
AND NOT EXISTS (SELECT 1 FROM shifts s WHERE s.nama_shift = sk.nama_shift);

DROP TABLE IF EXISTS shift_kerja CASCADE;

-- 4. DROP redundant sales table
DROP TABLE IF EXISTS tbl_penjualan CASCADE;

-- 5. DROP other conflicting tables
DROP TABLE IF EXISTS payroll CASCADE;
DROP TABLE IF EXISTS leave_requests CASCADE;

-- 6. Verify cleanup
SELECT 'Cleanup completed. Remaining tables:' as status;
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;

COMMIT;
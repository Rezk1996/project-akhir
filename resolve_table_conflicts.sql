-- Resolve Table Function Conflicts in R-Mart Database
-- Script untuk mengatasi tabel dengan fungsi yang bentrok

-- ========================================
-- 1. MERGE USER PROFILES INTO USERS TABLE
-- ========================================

-- Backup existing user_profiles data to users table
UPDATE users 
SET 
    phone = COALESCE(up.phone_number, users.phone),
    address = COALESCE(up.address, users.address),
    birth_date = CASE 
        WHEN up.date_of_birth IS NOT NULL 
        THEN up.date_of_birth::DATE 
        ELSE users.birth_date 
    END,
    gender = COALESCE(up.gender, users.gender),
    updated_at = CURRENT_TIMESTAMP
FROM user_profiles up 
WHERE users.id = up.user_id;

-- Drop redundant user_profiles table
DROP TABLE IF EXISTS user_profiles CASCADE;

-- ========================================
-- 2. CONSOLIDATE EMPLOYEE MANAGEMENT
-- ========================================

-- Migrate data from tenaga_kerja to employees if exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tenaga_kerja') THEN
        -- Insert unique employees from tenaga_kerja to employees
        INSERT INTO employees (employee_id, nama, phone, position, department, salary, status, shift_id)
        SELECT DISTINCT
            tk.employee_id,
            tk.nama,
            tk.phone,
            tk.position,
            tk.department,
            tk.salary,
            COALESCE(tk.status, 'active'),
            tk.shift_id
        FROM tenaga_kerja tk
        WHERE NOT EXISTS (
            SELECT 1 FROM employees e WHERE e.employee_id = tk.employee_id
        );
        
        -- Drop redundant tenaga_kerja table
        DROP TABLE tenaga_kerja CASCADE;
    END IF;
END $$;

-- ========================================
-- 3. CONSOLIDATE SHIFT MANAGEMENT  
-- ========================================

-- Migrate data from shift_kerja to shifts if exists
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'shift_kerja') THEN
        -- Insert unique shifts from shift_kerja to shifts
        INSERT INTO shifts (nama_shift, jam_mulai, jam_selesai, description)
        SELECT DISTINCT
            sk.nama_shift,
            sk.jam_mulai,
            sk.jam_selesai,
            sk.description
        FROM shift_kerja sk
        WHERE NOT EXISTS (
            SELECT 1 FROM shifts s WHERE s.nama_shift = sk.nama_shift
        );
        
        -- Drop redundant shift_kerja table
        DROP TABLE shift_kerja CASCADE;
    END IF;
END $$;

-- ========================================
-- 4. HANDLE SALES SYSTEM CONFLICT
-- ========================================

-- Keep orders/order_items as main transaction system
-- Drop tbl_penjualan if it exists (legacy sales table)
DROP TABLE IF EXISTS tbl_penjualan CASCADE;

-- ========================================
-- 5. CLEAN UP REDUNDANT TABLES
-- ========================================

-- Drop other potentially conflicting tables
DROP TABLE IF EXISTS payroll CASCADE;
DROP TABLE IF EXISTS leave_requests CASCADE;

-- ========================================
-- 6. VERIFY FINAL TABLE STRUCTURE
-- ========================================

-- Show final table list
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- Show table relationships
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;
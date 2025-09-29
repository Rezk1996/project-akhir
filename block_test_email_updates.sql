-- Block any updates to test@example.com at database level
-- Create trigger to prevent updates to test@example.com

CREATE OR REPLACE FUNCTION prevent_test_email_updates()
RETURNS TRIGGER AS $$
BEGIN
    -- Block any update that tries to set email to test@example.com
    IF NEW.email = 'test@example.com' AND OLD.email != 'test@example.com' THEN
        RAISE EXCEPTION 'Updates to test@example.com are blocked';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS block_test_email_trigger ON users;

-- Create trigger
CREATE TRIGGER block_test_email_trigger
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION prevent_test_email_updates();
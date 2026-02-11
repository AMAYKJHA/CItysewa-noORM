

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN 
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION set_updated_at() IS 
'Automatically updates the updated_at timestamp column to current time on row updates';



CREATE OR REPLACE PROCEDURE create_updated_at_triggers()
LANGUAGE plpgsql
AS $$
DECLARE
    table_record RECORD;
    trigger_name TEXT;
BEGIN

    FOR table_record IN 
        SELECT table_name
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND column_name = 'updated_at'
          AND table_name IN (
              SELECT table_name 
              FROM information_schema.tables 
              WHERE table_schema = 'public' 
                AND table_type = 'BASE TABLE'
          )
    LOOP

        trigger_name := 'trg_' || table_record.table_name || '_updated_at';
        

        EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I', 
                      trigger_name, 
                      table_record.table_name);
        

        EXECUTE format('CREATE TRIGGER %I
                       BEFORE UPDATE ON %I
                       FOR EACH ROW
                       EXECUTE FUNCTION set_updated_at()',
                      trigger_name,
                      table_record.table_name);
        
        RAISE NOTICE 'Created trigger % on table %', trigger_name, table_record.table_name;
    END LOOP;
END;
$$;

COMMENT ON PROCEDURE create_updated_at_triggers() IS 
'Automatically creates updated_at triggers on all tables that have an updated_at column';



CALL create_updated_at_triggers();



SELECT 
    event_object_table AS table_name,
    trigger_name,
    event_manipulation AS trigger_event,
    action_timing AS trigger_timing
FROM information_schema.triggers
WHERE trigger_schema = 'public'
    AND action_statement LIKE '%set_updated_at%'
ORDER BY event_object_table;

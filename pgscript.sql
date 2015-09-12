DROP DATABASE IF EXISTS lighterclock;
CREATE DATABASE lighterclock;
\connect lighterclock;

\connect timesheet;

DROP TABLE IF EXISTS time_sheet;
DROP TABLE IF EXISTS users;

CREATE TABLE time_sheet (
    id          SERIAL,
    time        TIMESTAMPTZ,
    name        VARCHAR(100) NOT NULL,
    username    VARCHAR(100) NOT NULL,
    type        VARCHAR(3),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users (
    id              SERIAL,
    username        VARCHAR(100) NOT NULL UNIQUE,
    password        VARCHAR(100) NOT NULL,
    creation_time   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

CREATE OR REPLACE FUNCTION punch_restrictions()
RETURNS event_trigger
AS
$$
DECLARE
    last_type varchar(3);
BEGIN
    SELECT type INTO last_type FROM time_sheet ORDER BY id DESC LIMIT 1;
    IF last_type = 'in' AND NEW.type = 'in'  THEN
        RAISE EXCEPTION 'Still waiting on an out punch before accepting punch in.';
    END IF;
END
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE EVENT TRIGGER punch_event ON ddl_command_start
WHEN TAG IN ('INSERT')
EXECUTE PROCEDURE punch_restrictions()

DROP DATABASE IF EXISTS lighterclock;
CREATE DATABASE lighterclock;
\connect lighterclock;

DROP TABLE IF EXISTS time_sheet;
DROP TABLE IF EXISTS users;

CREATE TYPE in_out_type AS ENUM ('in', 'out');

CREATE TABLE time_sheet (
    id          SERIAL,
    time        TIMESTAMPTZ,
    username    VARCHAR(100) NOT NULL,
    type        in_out_type,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users (
    id              SERIAL,
    username        VARCHAR(100) NOT NULL UNIQUE,
    password        VARCHAR(100) NOT NULL,
    creation_time   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (id)
);

DROP TRIGGER IF EXISTS punch_restrictions ON time_sheet;
DROP FUNCTION IF EXISTS punch_restrictions();

/*
CREATE OR REPLACE FUNCTION punch_restrictions()
RETURNS trigger
AS
$$
    DECLARE
        last_type in_out_type;
    BEGIN
        SELECT type INTO last_type FROM time_sheet ORDER BY id DESC LIMIT 1;
        IF last_type = 'in' AND NEW.type = 'in' THEN
            RAISE EXCEPTION 'Still waiting on an out punch before accepting punch in.';
            RETURN NULL;
        ELSE
            RETURN NEW;
        END IF;
    END
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER punch_restrictions
    AFTER INSERT ON time_sheet
    EXECUTE PROCEDURE punch_restrictions()
*/

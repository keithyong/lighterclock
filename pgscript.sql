DROP DATABASE IF EXISTS lighterclock;
CREATE DATABASE lighterclock;
\connect lighterclock;

DROP TABLE IF EXISTS time_sheet;
DROP TABLE IF EXISTS users;

CREATE TYPE in_out_type AS ENUM ('in', 'out');

CREATE TABLE IF NOT EXISTS users (
    id              serial,
    username        varchar(100) NOT NULL UNIQUE,
    password        varchar(100) NOT NULL,
    creation_time   timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (id)
);

CREATE TABLE time_sheet (
    id          serial,
    time        timestamptz,
    username    varchar(100) references users(username) NOT NULL,
    type        in_out_type,
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

INSERT INTO users VALUES (default, 'keithy', 'a', timestamp '2015-9-12 07:00');
INSERT INTO users VALUES (default, 'john', 'a', timestamp '2015-9-12 07:00');

INSERT INTO time_sheet VALUES (default, timestamp '2015-9-12 08:00', 'keithy', 'in');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-12 16:00', 'keithy', 'out');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-13 08:00', 'keithy', 'in');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-13 14:00', 'keithy', 'out');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-12 9:30', 'john', 'out');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-12 15:00', 'john', 'out');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-14 9:30', 'john', 'out');
INSERT INTO time_sheet VALUES (default, timestamp '2015-9-14 15:12', 'john', 'out');

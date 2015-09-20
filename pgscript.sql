DROP DATABASE IF EXISTS lighterclock;
CREATE DATABASE lighterclock;
\connect lighterclock;

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS time_sheet CASCADE;
DROP TABLE IF EXISTS punch CASCADE;
DROP TYPE IF EXISTS in_out_type;
DROP TRIGGER IF EXISTS punch_restrictions ON punch;
DROP FUNCTION IF EXISTS punch_restrictions();

CREATE TYPE in_out_type AS ENUM ('in', 'out');

CREATE TABLE IF NOT EXISTS users (
    id              serial,
    username        varchar(100) NOT NULL UNIQUE,
    password        varchar(100) NOT NULL,
    creation_time   timestamptz NOT NULL DEFAULT now(),
    primary key (id, username)
);

CREATE TABLE time_sheet (
    id              serial,
    title           varchar(100),
    username        varchar(100) references users(username) NOT NULL,
    primary key (id)
);

CREATE TABLE punch (
    id              serial,
    time_sheet_id   serial references time_sheet,
    time            timestamptz,
    type            in_out_type,
    primary key (id)
);

INSERT INTO users VALUES (default, 'keithy', 'a', timestamp '2015-9-12 07:00');
INSERT INTO users VALUES (default, 'john', 'a', timestamp '2015-9-12 07:00');

INSERT INTO time_sheet VALUES (default, 'Lofoten Painting', 'keithy');
INSERT INTO time_sheet VALUES (default, 'lighterclock', 'keithy');
INSERT INTO time_sheet VALUES (default, 'John Work', 'john');

/* Insert punches into Lofoten Painting */
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-12 08:00', 'in');
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-12 16:00', 'out');
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-13 08:00', 'in');
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-13 14:00', 'out');

/* Insert punches into lighterclock */
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-20 7:05', 'in');
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-20 13:15', 'out');
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-21 7:00', 'in');
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-21 12:21', 'out');

/* Insert punches into John Work */
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-12 9:30', 'in');
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-12 15:00', 'out');
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-14 9:30', 'in');
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-14 15:12', 'out');

/*
CREATE OR REPLACE FUNCTION punch_restrictions()
RETURNS trigger
AS
$$
    DECLARE
        last_type in_out_type;
    BEGIN
        SELECT type INTO last_type FROM punch ORDER BY id DESC LIMIT 1;
        IF last_type = 'in' AND NEW.type = 'in' THEN
            RAISE EXCEPTION 'Still waiting on an out punch before accepting punch in.';
            RETURN NULL;
        ELSE
            RETURN NEW;
        END IF;
    END
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER punch_restrictions
    AFTER INSERT ON punch
    EXECUTE PROCEDURE punch_restrictions()
*/

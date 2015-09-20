DROP DATABASE IF EXISTS lighterclock;
CREATE DATABASE lighterclock;
\connect lighterclock;

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS time_sheet CASCADE;
DROP TABLE IF EXISTS punch CASCADE;
DROP TYPE IF EXISTS in_out_type;
DROP TRIGGER IF EXISTS update_total ON punch;
DROP FUNCTION IF EXISTS update_total();

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
    total_time      interval DEFAULT interval '0',
    primary key (id)
);

CREATE TABLE punch (
    id              serial,
    time_sheet_id   serial references time_sheet,
    time            timestamptz,
    type            in_out_type,
    primary key (id)
);


-- Update the total work time of a time_sheet each time a punch is inserted --
-- UNFINISHED --
CREATE OR REPLACE FUNCTION update_total() RETURNS trigger AS
$$
    DECLARE
        curr_total_time interval;
        last_timestamp timestamptz;
        worked_time interval;
        new_total_time interval;
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            IF NEW.type = 'out' THEN
                -- Grab the current total time --
                SELECT total_time INTO curr_total_time FROM time_sheet WHERE time_sheet.id=NEW.time_sheet_id;

                -- Grab the last punch timestamp --
                SELECT time INTO last_timestamp FROM punch WHERE time_sheet_id=NEW.time_sheet_id ORDER BY id DESC LIMIT 1;

                -- Calculate worked_time --
                SELECT NEW.time - last_timestamp INTO worked_time;
                RAISE NOTICE 'NEW.time is %', NEW.time;
                RAISE NOTICE 'last_timestamp is %', last_timestamp;

                -- Calculate new_total_time --
                SELECT worked_time + curr_total_time INTO new_total_time;
                RAISE NOTICE 'new_total_time is %', new_total_time;

                -- Update time_sheet with new_total_time --
                UPDATE time_sheet SET total_time=new_total_time WHERE id=NEW.time_sheet_id;

                RETURN NEW;
            ELSE
                RETURN NEW;
            END IF;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER punch_insert
    BEFORE INSERT ON punch
    FOR EACH ROW
    EXECUTE PROCEDURE update_total();

-- Sample data --
INSERT INTO users VALUES (default, 'keithy', 'a', timestamp '2015-9-12 07:00');
INSERT INTO users VALUES (default, 'john', 'a', timestamp '2015-9-12 07:00');

INSERT INTO time_sheet VALUES (default, 'Lofoten Painting', 'keithy', default);
INSERT INTO time_sheet VALUES (default, 'lighterclock', 'keithy', default);
INSERT INTO time_sheet VALUES (default, 'John Work', 'john', default);

-- Insert punches into Lofoten Painting --
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-12 08:00', 'in');
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-12 16:00', 'out');
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-13 08:00', 'in');
INSERT INTO punch VALUES (default, 1, timestamp '2015-9-13 14:00', 'out');

-- Insert punches into lighterclock --
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-20 7:05', 'in');
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-20 13:15', 'out');
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-21 7:00', 'in');
INSERT INTO punch VALUES (default, 2, timestamp '2015-9-21 12:21', 'out');

-- Insert punches into John Work --
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-12 9:30', 'in');
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-12 15:00', 'out');
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-14 9:30', 'in');
INSERT INTO punch VALUES (default, 3, timestamp '2015-9-14 15:12', 'out');

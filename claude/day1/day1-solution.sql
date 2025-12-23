-- Advent of Code Day 1: Secret Entrance
-- The dial starts at 50 and rotates on a 0-99 circular dial
-- We need to count how many times it lands on 0 after any rotation

WITH RECURSIVE rotations AS (
    -- Parse the input data
    SELECT
        ROW_NUMBER() OVER (ORDER BY line_num) as step,
        SUBSTR(rotation, 1, 1) as direction,
        CAST(SUBSTR(rotation, 2) AS INTEGER) as distance,
        rotation as instruction
    FROM (
        VALUES
            (1, 'R11'), (2, 'R8'), (3, 'L47'), (4, 'L20'), (5, 'L25'),
            (6, 'L40'), (7, 'R50'), (8, 'L44'), (9, 'L38'), (10, 'L32'),
            (11, 'L39'), (12, 'R46'), (13, 'R40'), (14, 'L13'), (15, 'R48'),
            (16, 'R20'), (17, 'L21'), (18, 'L46'), (19, 'L43'), (20, 'R7'),
            (21, 'R4'), (22, 'L38'), (23, 'R30'), (24, 'R22'), (25, 'L39'),
            (26, 'R44'), (27, 'L11'), (28, 'R18'), (29, 'L22'), (30, 'R25'),
            (31, 'L14'), (32, 'L12'), (33, 'R42'), (34, 'L37'), (35, 'R40'),
            (36, 'L31'), (37, 'L40'), (38, 'R2'), (39, 'R22'), (40, 'L10'),
            (41, 'R42'), (42, 'L37'), (43, 'L2'), (44, 'R19'), (45, 'L50'),
            (46, 'R39'), (47, 'R20'), (48, 'L23'), (49, 'L41'), (50, 'L34')
            -- This is just first 50 for demo - you would need all 4035 values
    ) AS input_data(line_num, rotation)
),
dial_positions AS (
    -- Start at position 50
    SELECT
        0 as step,
        50 as position,
        '' as instruction

    UNION ALL

    -- Calculate next position for each rotation
    SELECT
        r.step,
        CASE
            WHEN r.direction = 'L' THEN
                (d.position - r.distance + 10000) % 100  -- Add 10000 to ensure positive before modulo
            WHEN r.direction = 'R' THEN
                (d.position + r.distance) % 100
        END as position,
        r.instruction
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
    WHERE d.step < (SELECT MAX(step) FROM rotations)
)
SELECT
    COUNT(*) as password,
    'Times the dial points at 0' as description
FROM dial_positions
WHERE position = 0 AND step > 0;

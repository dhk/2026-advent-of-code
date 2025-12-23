-- ============================================================
-- Advent of Code Day 1: Secret Entrance - SQL Solution
-- ============================================================
-- Problem: A dial with numbers 0-99 starts at position 50
-- Given rotation instructions (L/R + distance), count how many
-- times the dial lands on position 0 after any rotation
-- ============================================================

-- Step 1: Create table for input data (run this first)
CREATE TABLE IF NOT EXISTS input_rotations (
    line_num INTEGER,
    rotation TEXT
);

-- Step 2: Load data from file or insert manually
-- (In the Python script, we load from day1-input.txt)

-- Step 3: Main query - Uses recursive CTE to simulate dial rotations
WITH RECURSIVE rotations AS (
    -- Parse each rotation instruction into direction and distance
    SELECT
        ROW_NUMBER() OVER (ORDER BY line_num) as step,
        SUBSTR(rotation, 1, 1) as direction,  -- Extract 'L' or 'R'
        CAST(SUBSTR(rotation, 2) AS INTEGER) as distance,  -- Extract number
        rotation as instruction
    FROM input_rotations
),
dial_positions AS (
    -- Base case: dial starts at position 50
    SELECT
        0 as step,
        50 as position,
        '' as instruction

    UNION ALL

    -- Recursive case: calculate next position based on rotation
    SELECT
        r.step,
        CASE
            WHEN r.direction = 'L' THEN
                -- Left rotation: subtract and wrap around (add 10000 to ensure positive)
                (d.position - r.distance + 10000) % 100
            WHEN r.direction = 'R' THEN
                -- Right rotation: add and wrap around
                (d.position + r.distance) % 100
        END as position,
        r.instruction
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
    WHERE d.step < (SELECT MAX(step) FROM rotations)
)
-- Count positions where dial points at 0 (excluding initial position)
SELECT
    COUNT(*) as password_answer
FROM dial_positions
WHERE position = 0 AND step > 0;

-- Optional: View all positions (for debugging)
-- SELECT position, step, instruction
-- FROM dial_positions
-- ORDER BY step;

-- Optional: View only positions where dial points at 0
-- SELECT position, step, instruction
-- FROM dial_positions
-- WHERE position = 0 AND step > 0
-- ORDER BY step;

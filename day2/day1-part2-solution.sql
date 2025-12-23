-- Day 1 Part 2: Secret Entrance Part Two Solution
-- Using DuckDB to count all times dial points at 0 during rotations
-- This includes intermediate positions during each rotation, not just final positions

-- Step 1: Load the input data and parse it
WITH input_data AS (
    SELECT
        row_number() OVER () AS step,
        instruction
    -- Using same input as Part One
    FROM read_csv('../day1/day1-input.txt',
                  header=false,
                  columns={'instruction': 'VARCHAR'})
    WHERE instruction != ''
),

-- Step 2: Parse direction and distance from each instruction
parsed_instructions AS (
    SELECT
        step,
        instruction,
        substr(instruction, 1, 1) AS direction,  -- L or R
        CAST(substr(instruction, 2) AS INTEGER) AS distance
    FROM input_data
),

-- Step 3: Convert to numeric change
rotations AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        CASE
            WHEN direction = 'R' THEN distance
            WHEN direction = 'L' THEN -distance
        END AS change
    FROM parsed_instructions
),

-- Step 4: Calculate cumulative positions
cumulative_positions AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        change,
        -- Calculate cumulative sum starting from 50
        50 + SUM(change) OVER (ORDER BY step ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_position
    FROM rotations
),

-- Step 5: Calculate starting position for each rotation
rotation_starts AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        change,
        -- Starting position: previous cumulative position (or 50 for first step)
        COALESCE(
            LAG(MOD(MOD(cumulative_position, 100) + 100, 100)) OVER (ORDER BY step),
            50
        ) AS start_position
    FROM cumulative_positions
),

-- Step 6: Calculate ending position and count zeros
rotation_analysis AS (
    SELECT
        step,
        instruction,
        start_position,
        change,
        -- Ending position after rotation
        MOD(MOD(start_position + change, 100) + 100, 100) AS end_position,
        -- Count how many times we're at position 0 during rotation
        -- We count positions from start+1 to end (we don't count the starting position)
        -- For positive change: count how many k in [1, change] satisfy (start + k) mod 100 = 0
        -- For negative change: count how many k in [change, -1] satisfy (start + k) mod 100 = 0
        CASE
            WHEN change > 0 THEN
                -- Count how many multiples of 100 are in range (start, start+change]
                -- This is: floor((start + change) / 100) - floor(start / 100)
                -- But if start mod 100 = 0, we need to subtract 1 because we don't count the start
                FLOOR((start_position + change)::DOUBLE / 100.0) - FLOOR(start_position::DOUBLE / 100.0) -
                CASE WHEN MOD(start_position, 100) = 0 THEN 1 ELSE 0 END
            WHEN change < 0 THEN
                -- For negative: count multiples of 100 in range [start+change, start)
                -- This is: floor(start / 100) - floor((start + change) / 100)
                -- But if start mod 100 = 0, we need to subtract 1
                GREATEST(0, FLOOR(start_position::DOUBLE / 100.0) - FLOOR((start_position + change)::DOUBLE / 100.0) -
                CASE WHEN MOD(start_position, 100) = 0 THEN 1 ELSE 0 END)
            ELSE 0
        END AS zeros_during_rotation
    FROM rotation_starts
),

-- Step 6: Calculate zero at end (only if not already counted during rotation)
rotation_with_zeros AS (
    SELECT
        step,
        instruction,
        start_position,
        change,
        end_position,
        zeros_during_rotation,
        -- Count if we end at 0, but only if we didn't already count it during rotation
        CASE
            WHEN end_position = 0 AND zeros_during_rotation = 0 THEN 1
            ELSE 0
        END AS zero_at_end
    FROM rotation_analysis
),

-- Step 7: Sum all zero counts
zero_counts AS (
    SELECT
        zeros_during_rotation + zero_at_end AS total_zeros
    FROM rotation_with_zeros
)

-- Step 8: Count total times dial points at 0
SELECT
    SUM(total_zeros) AS password
FROM zero_counts;

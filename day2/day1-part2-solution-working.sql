-- Day 1 Part 2: Secret Entrance Part Two Solution - Showing Working
-- This query shows step-by-step how the dial moves and counts zeros

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

parsed_instructions AS (
    SELECT
        step,
        instruction,
        substr(instruction, 1, 1) AS direction,  -- L or R
        CAST(substr(instruction, 2) AS INTEGER) AS distance
    FROM input_data
),

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

cumulative_positions AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        change,
        50 + SUM(change) OVER (ORDER BY step ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_position
    FROM rotations
),

rotation_starts AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        change,
        COALESCE(
            LAG(MOD(MOD(cumulative_position, 100) + 100, 100)) OVER (ORDER BY step),
            50
        ) AS start_position
    FROM cumulative_positions
),

rotation_analysis AS (
    SELECT
        step,
        instruction,
        start_position,
        change,
        MOD(MOD(start_position + change, 100) + 100, 100) AS end_position,
        CASE
            WHEN change > 0 THEN
                FLOOR((start_position + change)::DOUBLE / 100.0) - FLOOR(start_position::DOUBLE / 100.0) -
                CASE WHEN MOD(start_position, 100) = 0 THEN 1 ELSE 0 END
            WHEN change < 0 THEN
                GREATEST(0, FLOOR(start_position::DOUBLE / 100.0) - FLOOR((start_position + change)::DOUBLE / 100.0) -
                CASE WHEN MOD(start_position, 100) = 0 THEN 1 ELSE 0 END)
            ELSE 0
        END AS zeros_during_rotation
    FROM rotation_starts
),

rotation_with_zeros AS (
    SELECT
        step,
        instruction,
        start_position,
        change,
        end_position,
        zeros_during_rotation,
        CASE
            WHEN end_position = 0 AND zeros_during_rotation = 0 THEN 1
            ELSE 0
        END AS zero_at_end
    FROM rotation_analysis
)

-- Show first 20 steps to demonstrate the working
SELECT
    step,
    instruction,
    start_position,
    change,
    end_position,
    zeros_during_rotation,
    zero_at_end,
    zeros_during_rotation + zero_at_end AS total_zeros,
    CASE WHEN zeros_during_rotation + zero_at_end > 0 THEN '*** ZERO ***' ELSE '' END AS marker
FROM rotation_with_zeros
ORDER BY step
LIMIT 20;


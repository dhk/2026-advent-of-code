-- Day 1: Secret Entrance Solution - Showing Working
-- This query shows step-by-step how the dial moves

WITH input_data AS (
    SELECT
        row_number() OVER () AS step,
        instruction
    FROM read_csv('day1-input.txt',
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

position_calculations AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        change,
        50 + SUM(change) OVER (ORDER BY step ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_position
    FROM rotations
),

final_positions AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        MOD(MOD(cumulative_position, 100) + 100, 100) AS final_position
    FROM position_calculations
)

-- Show first 20 steps to demonstrate the working
SELECT
    step,
    instruction,
    direction,
    distance,
    final_position,
    CASE WHEN final_position = 0 THEN '*** AT ZERO ***' ELSE '' END AS marker
FROM final_positions
ORDER BY step
LIMIT 20;


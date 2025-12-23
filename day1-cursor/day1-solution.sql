-- Day 1: Secret Entrance Solution
-- Using DuckDB to solve the dial rotation problem

-- Step 1: Load the input data and parse it
WITH input_data AS (
    SELECT
        row_number() OVER () AS step,
        instruction
    FROM read_csv('day1-input.txt',
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

-- Step 3: Calculate position after each rotation
-- We'll use a recursive CTE or window functions to track position
rotations AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        -- Calculate position: start at 50, then apply rotations
        -- For each step, calculate cumulative position
        -- Position calculation: (current_position + change) MOD 100
        -- But we need to handle negative modulo correctly
        CASE
            WHEN direction = 'R' THEN distance
            WHEN direction = 'L' THEN -distance
        END AS change
    FROM parsed_instructions
),

-- Step 4: Calculate position after each rotation using cumulative sum
position_calculations AS (
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

-- Step 5: Calculate final position with proper modulo (handling negatives)
final_positions AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        -- Proper modulo for circular dial: handle negatives correctly
        -- ((x % 100) + 100) % 100 ensures result is always 0-99
        MOD(MOD(cumulative_position, 100) + 100, 100) AS final_position
    FROM position_calculations
)

-- Step 6: Count how many times we end at 0
SELECT
    COUNT(*) AS password
FROM final_positions
WHERE final_position = 0;


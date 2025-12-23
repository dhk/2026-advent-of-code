-- ============================================================
-- Advent of Code Day 1: Secret Entrance - DuckDB Solution
-- ============================================================
-- Run this with: duckdb < day1-duckdb-solution.sql
-- Or in DuckDB CLI: .read day1-duckdb-solution.sql
-- ============================================================

WITH RECURSIVE
-- Read and parse the input file directly using DuckDB's read_csv
rotations AS (
    SELECT
        ROW_NUMBER() OVER () as step,
        SUBSTRING(column0, 1, 1) as direction,  -- Extract L or R
        CAST(SUBSTRING(column0, 2) AS INTEGER) as distance,  -- Extract number
        column0 as instruction
    FROM read_csv(
        '/Users/dhk/Documents/github/2026-advent-of-code/claude/day1/day1-input.txt',
        header=false,
        delim='|',  -- Use delimiter that won't appear in data
        columns={'column0': 'VARCHAR'}
    )
),
-- Simulate the dial rotations using recursive CTE
dial_positions AS (
    -- Base case: dial starts at position 50
    SELECT
        0 as step,
        50 as position,
        '' as instruction

    UNION ALL

    -- Recursive case: calculate next position
    SELECT
        r.step,
        CASE
            WHEN r.direction = 'L' THEN
                -- Left: subtract distance with proper modulo for negative numbers
                ((d.position - r.distance) % 100 + 100) % 100
            WHEN r.direction = 'R' THEN
                -- Right: add distance with modulo wrap-around
                (d.position + r.distance) % 100
        END as position,
        r.instruction
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
    WHERE d.step < (SELECT MAX(step) FROM rotations)
)
-- Main query: count how many times position = 0
SELECT
    COUNT(*) as password_answer,
    'The password (number of times dial points at 0)' as description
FROM dial_positions
WHERE position = 0 AND step > 0;

-- ============================================================
-- Optional: Uncomment to see all zero positions
-- ============================================================
-- WITH RECURSIVE
-- rotations AS (
--     SELECT
--         ROW_NUMBER() OVER () as step,
--         SUBSTRING(column0, 1, 1) as direction,
--         CAST(SUBSTRING(column0, 2) AS INTEGER) as distance,
--         column0 as instruction
--     FROM read_csv(
--         '/Users/dhk/Documents/github/2026-advent-of-code/claude/day1/day1-input.txt',
--         header=false, delim='|', columns={'column0': 'VARCHAR'}
--     )
-- ),
-- dial_positions AS (
--     SELECT 0 as step, 50 as position, '' as instruction
--     UNION ALL
--     SELECT
--         r.step,
--         CASE
--             WHEN r.direction = 'L' THEN ((d.position - r.distance) % 100 + 100) % 100
--             WHEN r.direction = 'R' THEN (d.position + r.distance) % 100
--         END as position,
--         r.instruction
--     FROM dial_positions d
--     JOIN rotations r ON r.step = d.step + 1
--     WHERE d.step < (SELECT MAX(step) FROM rotations)
-- )
-- SELECT step, instruction, position
-- FROM dial_positions
-- WHERE position = 0 AND step > 0
-- ORDER BY step;

-- ============================================================
-- Optional: Uncomment for statistics
-- ============================================================
-- WITH RECURSIVE
-- rotations AS (
--     SELECT
--         ROW_NUMBER() OVER () as step,
--         SUBSTRING(column0, 1, 1) as direction,
--         CAST(SUBSTRING(column0, 2) AS INTEGER) as distance,
--         column0 as instruction
--     FROM read_csv(
--         '/Users/dhk/Documents/github/2026-advent-of-code/claude/day1/day1-input.txt',
--         header=false, delim='|', columns={'column0': 'VARCHAR'}
--     )
-- ),
-- dial_positions AS (
--     SELECT 0 as step, 50 as position, '' as instruction
--     UNION ALL
--     SELECT
--         r.step,
--         CASE
--             WHEN r.direction = 'L' THEN ((d.position - r.distance) % 100 + 100) % 100
--             WHEN r.direction = 'R' THEN (d.position + r.distance) % 100
--         END as position,
--         r.instruction
--     FROM dial_positions d
--     JOIN rotations r ON r.step = d.step + 1
--     WHERE d.step < (SELECT MAX(step) FROM rotations)
-- )
-- SELECT
--     COUNT(*) as total_rotations,
--     SUM(CASE WHEN position = 0 AND step > 0 THEN 1 ELSE 0 END) as times_at_zero,
--     MIN(position) as min_position,
--     MAX(position) as max_position,
--     ROUND(AVG(position), 2) as avg_position
-- FROM dial_positions
-- WHERE step > 0;

#!/usr/bin/env python3
"""
Advent of Code Day 1: Secret Entrance - DuckDB Solution
Solves the dial rotation puzzle using DuckDB
"""

import duckdb

# Read the input file
input_file = '/Users/dhk/Documents/github/2026-advent-of-code/claude/day1/day1-input.txt'

# Create DuckDB connection
conn = duckdb.connect(':memory:')

print("Solving Advent of Code Day 1 using DuckDB...")
print("=" * 60)

# DuckDB can read the file directly and process it
result = conn.execute("""
WITH RECURSIVE
-- Read and parse the input file directly
rotations AS (
    SELECT
        ROW_NUMBER() OVER () as step,
        SUBSTRING(column0, 1, 1) as direction,
        CAST(SUBSTRING(column0, 2) AS INTEGER) as distance,
        column0 as instruction
    FROM read_csv(?,
        header=false,
        delim='|',  -- Use a delimiter that won't appear in data
        columns={'column0': 'VARCHAR'}
    )
),
-- Simulate the dial rotations
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
                -- Left: subtract distance, use modulo for wrap-around
                ((d.position - r.distance) % 100 + 100) % 100
            WHEN r.direction = 'R' THEN
                -- Right: add distance, use modulo for wrap-around
                (d.position + r.distance) % 100
        END as position,
        r.instruction
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
    WHERE d.step < (SELECT MAX(step) FROM rotations)
)
-- Get all positions
SELECT
    position,
    step,
    instruction
FROM dial_positions
ORDER BY step
""", [input_file])

# Fetch all results
all_positions = result.fetchall()

# Count zeros (excluding initial position)
zero_count = sum(1 for pos, step, _ in all_positions if pos == 0 and step > 0)

print(f"\nSOLUTION: The password is {zero_count}")
print("=" * 60)

# Show sample positions
print("\nSample positions (first 20 rotations):")
print(f"{'Step':<6} {'Instruction':<12} {'Position':<10}")
print("-" * 40)
for pos, step, inst in all_positions[:21]:
    zero_marker = " <- ZERO!" if pos == 0 and step > 0 else ""
    print(f"{step:<6} {inst:<12} {pos:<10}{zero_marker}")

# Show all zeros
print(f"\nAll positions where dial points at 0:")
zeros = [(pos, step, inst) for pos, step, inst in all_positions if pos == 0 and step > 0]
print(f"{'Step':<6} {'Instruction':<12} {'Position':<10}")
print("-" * 40)
for pos, step, inst in zeros[:20]:  # Show first 20
    print(f"{step:<6} {inst:<12} {pos:<10}")
if len(zeros) > 20:
    print(f"... and {len(zeros) - 20} more")

print("\n" + "=" * 60)
print(f"FINAL ANSWER: {zero_count}")
print("=" * 60)

# Also show summary statistics using DuckDB
print("\nBonus: Statistics from DuckDB")
stats = conn.execute("""
WITH RECURSIVE
rotations AS (
    SELECT
        ROW_NUMBER() OVER () as step,
        SUBSTRING(column0, 1, 1) as direction,
        CAST(SUBSTRING(column0, 2) AS INTEGER) as distance,
        column0 as instruction
    FROM read_csv(?, header=false, delim='|', columns={'column0': 'VARCHAR'})
),
dial_positions AS (
    SELECT 0 as step, 50 as position, '' as instruction
    UNION ALL
    SELECT
        r.step,
        CASE
            WHEN r.direction = 'L' THEN ((d.position - r.distance) % 100 + 100) % 100
            WHEN r.direction = 'R' THEN (d.position + r.distance) % 100
        END as position,
        r.instruction
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
    WHERE d.step < (SELECT MAX(step) FROM rotations)
)
SELECT
    COUNT(*) as total_rotations,
    SUM(CASE WHEN position = 0 AND step > 0 THEN 1 ELSE 0 END) as times_at_zero,
    MIN(position) as min_position,
    MAX(position) as max_position,
    AVG(position) as avg_position
FROM dial_positions
WHERE step > 0
""", [input_file]).fetchone()

print(f"Total rotations: {stats[0]}")
print(f"Times at zero: {stats[1]}")
print(f"Min position: {stats[2]}")
print(f"Max position: {stats[3]}")
print(f"Avg position: {stats[4]:.2f}")

conn.close()

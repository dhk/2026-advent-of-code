#!/usr/bin/env python3
"""
Advent of Code Day 1: Secret Entrance - SQL Solution
Solves the dial rotation puzzle using SQL
"""

import sqlite3

# Read the input file
with open('/Users/dhk/Documents/github/2026-advent-of-code/claude/day1/day1-input.txt', 'r') as f:
    lines = f.readlines()

# Execute SQL
conn = sqlite3.connect(':memory:')
cursor = conn.cursor()

# Create and populate input table
cursor.execute("""
    CREATE TABLE input_rotations (
        line_num INTEGER,
        rotation TEXT
    )
""")

# Insert rotations
rotations_data = []
for i, line in enumerate(lines, 1):
    rotation = line.strip()
    if rotation:
        rotations_data.append((i, rotation))

cursor.executemany("INSERT INTO input_rotations VALUES (?, ?)", rotations_data)

# Build SQL query
sql_query = """
WITH RECURSIVE rotations AS (
    -- Parse the input data
    SELECT
        ROW_NUMBER() OVER (ORDER BY line_num) as step,
        SUBSTR(rotation, 1, 1) as direction,
        CAST(SUBSTR(rotation, 2) AS INTEGER) as distance,
        rotation as instruction
    FROM input_rotations
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
                (d.position - r.distance + 10000) % 100
            WHEN r.direction = 'R' THEN
                (d.position + r.distance) % 100
        END as position,
        r.instruction
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
    WHERE d.step < (SELECT MAX(step) FROM rotations)
)
SELECT
    position,
    step,
    instruction
FROM dial_positions
ORDER BY step;
"""

print("Executing SQL query to solve the puzzle...")
cursor.execute(sql_query)

# Get all positions
positions = cursor.fetchall()

# Count how many times position is 0 (excluding the start)
zero_count = sum(1 for pos, step, _ in positions if pos == 0 and step > 0)

print(f"\n{'='*60}")
print(f"SOLUTION: The password is {zero_count}")
print(f"{'='*60}\n")

# Show some details
print("Sample positions (first 20 rotations):")
print(f"{'Step':<6} {'Instruction':<12} {'Position':<10}")
print(f"{'-'*30}")
for pos, step, inst in positions[:21]:
    zero_marker = " <- ZERO!" if pos == 0 and step > 0 else ""
    print(f"{step:<6} {inst:<12} {pos:<10}{zero_marker}")

# Count zeros
print(f"\nAll positions where dial points at 0:")
zeros = [(pos, step, inst) for pos, step, inst in positions if pos == 0 and step > 0]
print(f"{'Step':<6} {'Instruction':<12} {'Position':<10}")
print(f"{'-'*30}")
for pos, step, inst in zeros[:20]:  # Show first 20
    print(f"{step:<6} {inst:<12} {pos:<10}")
if len(zeros) > 20:
    print(f"... and {len(zeros) - 20} more")

print(f"\n{'='*60}")
print(f"ANSWER: {zero_count}")
print(f"{'='*60}")

conn.close()

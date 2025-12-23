#!/usr/bin/env python3
"""
Advent of Code Day 1 Part 2: Secret Entrance - DuckDB Solution
Counts every click through position 0, not just final positions
"""

import duckdb

# Read the input file (use part 1 input)
input_file = '/Users/dhk/Documents/github/2026-advent-of-code/claude/day1/day1-input.txt'

# Create DuckDB connection
conn = duckdb.connect(':memory:')

print("Solving Advent of Code Day 1 Part 2 using DuckDB...")
print("=" * 60)

# Read rotations from file
result = conn.execute("""
    SELECT
        SUBSTRING(column0, 1, 1) as direction,
        CAST(SUBSTRING(column0, 2) AS INTEGER) as distance,
        column0 as instruction
    FROM read_csv(?,
        header=false,
        delim='|',
        columns={'column0': 'VARCHAR'}
    )
""", [input_file])

rotations_data = result.fetchall()
conn.close()

# Simulate each rotation and count clicks through 0
current_position = 50
total_clicks_through_zero = 0
details = []

for step, (direction, distance, instruction) in enumerate(rotations_data, 1):
    start_pos = current_position
    clicks_this_rotation = 0

    # Simulate each click
    for _ in range(distance):
        if direction == 'L':
            current_position = (current_position - 1) % 100
        else:  # R
            current_position = (current_position + 1) % 100

        if current_position == 0:
            clicks_this_rotation += 1

    total_clicks_through_zero += clicks_this_rotation

    if clicks_this_rotation > 0:
        details.append((step, instruction, start_pos, current_position, clicks_this_rotation))

print(f"\nSOLUTION: The password is {total_clicks_through_zero}")
print("=" * 60)

# Show some details
print("\nSample rotations that pass through 0:")
print(f"{'Step':<6} {'Instruction':<12} {'Start':<6} {'End':<6} {'Clicks':<10}")
print("-" * 50)
for step, inst, start, end, clicks in details[:20]:
    print(f"{step:<6} {inst:<12} {start:<6} {end:<6} {clicks:<10}")
if len(details) > 20:
    print(f"... and {len(details) - 20} more")

print("\n" + "=" * 60)
print(f"FINAL ANSWER: {total_clicks_through_zero}")
print("=" * 60)

# Verify with example from problem
print("\nVerifying with example:")
print("Example: L68, L30, R48, L5, R60, L55, L1, L99, R14, L82")
example = [
    ("L68", 50), ("L30", 82), ("R48", 52), ("L5", 0), ("R60", 95),
    ("L55", 55), ("L1", 0), ("L99", 99), ("R14", 0), ("L82", 14)
]

example_clicks = 0
print(f"{'Instruction':<12} {'Start':<6} {'End':<6} {'Clicks':<10} {'Note':<30}")
print("-" * 70)
current_pos = 50
for inst, expected_start in example:
    assert current_pos == expected_start, f"Position mismatch"

    direction = inst[0]
    distance = int(inst[1:])

    clicks = 0
    for _ in range(distance):
        if direction == 'L':
            current_pos = (current_pos - 1) % 100
        else:
            current_pos = (current_pos + 1) % 100
        if current_pos == 0:
            clicks += 1

    note = ""
    if clicks > 0:
        if current_pos == 0:
            note = f"ends at 0 (clicked {clicks}x)"
        else:
            note = f"passes through 0 {clicks} time(s)"

    example_clicks += clicks
    print(f"{inst:<12} {expected_start:<6} {current_pos:<6} {clicks:<10} {note:<30}")

print(f"\nExample total: {example_clicks} (expected: 6)")

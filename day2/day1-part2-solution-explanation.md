# Day 1 Part 2: Secret Entrance Part Two - SQL Solution Explanation

## Problem Summary

This is Part Two of Day 1. The problem is similar but with a key difference:
- **Part One**: Count how many times the dial **ends** at position 0 after any rotation
- **Part Two**: Count how many times the dial **points at 0** during any rotation (including intermediate positions, not just final positions)

**Key Details:**
- Dial is circular (0-99, wrapping around)
- Starting position: 50
- L = left (decrease), R = right (increase)
- We must count **every** time the dial points at 0 during a rotation, not just at the end
- Example: Rotating R1000 from position 50 causes the dial to point at 0 **ten times** during the rotation!

## Solution Approach

The solution uses mathematical calculation to count how many times we cross position 0 during each rotation, rather than generating all intermediate positions (which would be inefficient for large rotations).

### Step 1: Load and Parse Input
Same as Part One - loads the input file and parses instructions.

### Step 2-4: Parse Instructions and Calculate Positions
Same as Part One - converts directions to changes and calculates starting positions.

### Step 5: Count Zeros During Rotation (Key Difference)

For each rotation from `start_position` with `change`:
- We need to count how many positions in the range `[start+1, start+change]` (for positive) or `[start+change, start-1]` (for negative) equal 0 modulo 100.

**Mathematical approach:**
- For positive change: Count multiples of 100 in range `(start, start+change]`
  - Formula: `floor((start + change) / 100) - floor(start / 100)`
  - But if `start mod 100 = 0`, we subtract 1 because we don't count the starting position
- For negative change: Count multiples of 100 in range `[start+change, start)`
  - Formula: `floor(start / 100) - floor((start + change) / 100)`
  - Same adjustment if starting at 0

### Step 6: Count Zeros at End

If the rotation ends at 0, we count it **only if** we didn't already count it during the rotation (to avoid double-counting).

### Step 7-8: Sum All Zeros

Sum all zeros from all rotations to get the final answer.

## Key SQL Features Used

- Window functions for cumulative calculations
- Mathematical floor division for counting multiples
- Modulo arithmetic for circular dial
- CTEs for step-by-step transformation

## Results

- **Answer**: 5280
- The dial points at position 0 a total of **5280 times** during all rotations

## Example Calculation

From the prompt example:
- L68 from 50: Goes 50→49→...→0→99→...→82. Crosses 0 once during rotation. Total: 1
- R48 from 52: Goes 52→53→...→99→0. Ends at 0. Total: 1
- R60 from 95: Goes 95→96→...→99→0→1→...→55. Crosses 0 once during rotation. Total: 1
- L55 from 55: Goes 55→54→...→1→0. Ends at 0. Total: 1
- L99 from 99: Goes 99→0. Ends at 0. Total: 1
- L82 from 14: Goes 14→13→...→1→0→99→...→32. Crosses 0 once during rotation. Total: 1

**Total for example: 6** (matches the prompt)

## Running the Solution

From the day2 directory (or day1-part2):

```bash
# Get the answer
duckdb < day1-part2-solution.sql

# See step-by-step working (first 20 steps)
duckdb < day1-part2-solution-working.sql
```

## Key Insight

The challenge is efficiently counting zeros without generating all intermediate positions. The mathematical approach using floor division allows us to calculate this in O(1) per rotation rather than O(change) per rotation.


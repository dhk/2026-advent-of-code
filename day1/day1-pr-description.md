# Day 1: Secret Entrance - SQL Solution

## Problem Summary

The safe has a dial with numbers 0-99 (circular). Starting at position 50, we need to follow a sequence of rotations (L/R followed by distance) and count how many times the dial points at 0 after any rotation.

**Key Details:**
- Dial is circular (0-99, wrapping around)
- Starting position: 50
- L = left (decrease), R = right (increase)
- Answer: Count of times dial points at 0

## Solution

Implemented using **DuckDB** with SQL window functions to:
1. Parse rotation instructions (L/R + distance)
2. Calculate cumulative position starting from 50
3. Apply circular modulo arithmetic (0-99 wrapping)
4. Count positions where dial points at 0

### Answer: **964**

The dial points at position 0 a total of **964 times** after rotations in the input sequence.

## Files Included

### Solution Files
- **`day1-solution.sql`** - Main solution that calculates the answer
- **`day1-solution-working.sql`** - Step-by-step working showing first 20 rotations
- **`day1-solution-explanation.md`** - Detailed explanation of the approach

### Input Files
- **`day1-input.txt`** - Puzzle input (4,035 rotation instructions)
- **`day1-prompt.txt`** - Problem description

## Solution Approach

The solution uses a series of CTEs (Common Table Expressions) to:

1. **Load Input**: Read and parse rotation instructions from CSV
2. **Parse Instructions**: Extract direction (L/R) and distance
3. **Convert to Changes**: R = positive, L = negative
4. **Calculate Positions**: Use window functions for cumulative sum starting from 50
5. **Apply Circular Modulo**: Handle 0-99 wrapping with `MOD(MOD(x, 100) + 100, 100)`
6. **Count Zeros**: Count positions where final_position = 0

### Key SQL Features Used
- Window functions (`SUM() OVER()`)
- CTEs for step-by-step transformation
- Proper modulo arithmetic for circular dial

## Running the Solution

From the `day1` directory:

```bash
# Get the answer
duckdb < day1-solution.sql

# See step-by-step working (first 20 steps)
duckdb < day1-solution-working.sql
```

## Verification

Tested with the example from the prompt:
- Expected: 3 times at position 0
- Result: 3 times at position 0 ✓

The solution correctly handles:
- ✅ Starting position of 50
- ✅ Circular dial (0-99 wrapping)
- ✅ Left rotations (decrease) and right rotations (increase)
- ✅ Negative modulo arithmetic

## Results

- **Total instructions**: 4,035
- **Password (times at position 0)**: 964
- **First few steps where we hit 0**: 50, 53, 55, 60, 62

## Example Calculation

Tracing through the first few steps:
1. Start at 50
2. R11: 50 + 11 = 61
3. R8: 61 + 8 = 69
4. L47: 69 - 47 = 22
5. L20: 22 - 20 = 2
6. L25: 2 - 25 = -23 → MOD(-23, 100) = 77

---

**Note**: This solution uses DuckDB, an in-process analytical database. The SQL approach demonstrates how to solve the problem using declarative SQL rather than imperative programming.


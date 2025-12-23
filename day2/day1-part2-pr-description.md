# Day 1 Part 2: Secret Entrance Part Two - SQL Solution

## Problem Summary

Part Two of Day 1 extends the problem to count **every time** the dial points at 0 during rotations, not just at the end of rotations.

**Key Difference from Part One:**
- Part One: Counted when dial **ends** at position 0
- Part Two: Counts **every time** dial points at 0 during any rotation (including intermediate positions)

**Example from prompt:**
- Rotating R1000 from position 50 causes the dial to point at 0 **ten times** during the rotation!

## Solution

Implemented using **DuckDB** with mathematical calculations to efficiently count zero crossings without generating all intermediate positions.

### Answer: **5280**

The dial points at position 0 a total of **5280 times** during all rotations in the input sequence.

## Files Included

### Solution Files
- **`day1-part2-solution.sql`** - Main solution that calculates the answer
- **`day1-part2-solution-working.sql`** - Step-by-step working showing first 20 rotations
- **`day1-part2-solution-explanation.md`** - Detailed explanation of the approach

### Input Files
- Uses same input as Part One: `../day1/day1-input.txt`

## Solution Approach

The solution uses mathematical floor division to count how many times we cross position 0 during each rotation:

1. **Load Input**: Read rotation instructions (same as Part One)
2. **Parse Instructions**: Extract direction and distance
3. **Calculate Positions**: Track starting position for each rotation
4. **Count Zeros During Rotation**:
   - For positive change: Count multiples of 100 in range `(start, start+change]`
   - For negative change: Count multiples of 100 in range `[start+change, start)`
   - Adjust for starting at position 0 (don't count the start)
5. **Count Zeros at End**: If rotation ends at 0 and we didn't already count it
6. **Sum All Zeros**: Total count across all rotations

### Key Insight

Instead of generating all intermediate positions (inefficient for large rotations like R1000), we use mathematical formulas:
- `floor((start + change) / 100) - floor(start / 100)` for positive changes
- `floor(start / 100) - floor((start + change) / 100)` for negative changes

This allows O(1) calculation per rotation instead of O(change).

## Running the Solution

From the `day2` directory (or `day1-part2`):

```bash
# Get the answer
duckdb < day1-part2-solution.sql

# See step-by-step working (first 20 steps)
duckdb < day1-part2-solution-working.sql
```

## Verification

Tested with the example from the prompt:
- Expected: 6 times at position 0
- Result: 6 times at position 0 ✓

The solution correctly handles:
- ✅ Starting position of 50
- ✅ Circular dial (0-99 wrapping)
- ✅ Large rotations (e.g., R1000 hits 0 ten times)
- ✅ Counting intermediate positions, not just final positions
- ✅ Avoiding double-counting when ending at 0

## Results

- **Total instructions**: 4,035 (same as Part One)
- **Password (times at position 0)**: 5280
- **Approach**: Mathematical calculation using floor division

---

**Note**: This solution efficiently handles large rotations without generating all intermediate positions, making it scalable for any rotation size.


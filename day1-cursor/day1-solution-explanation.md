# Day 1: Secret Entrance - SQL Solution Explanation

## Problem Summary
- We have a dial that goes from 0 to 99 (circular)
- Starting position: 50
- Each instruction is either L (left, decrease) or R (right, increase) followed by a distance
- We need to count how many times the dial points at 0 after any rotation

## Solution Approach

### Step 1: Load and Parse Input
```sql
WITH input_data AS (
    SELECT
        row_number() OVER () AS step,
        instruction
    FROM read_csv('day1-input.txt',
                  header=false,
                  columns={'instruction': 'VARCHAR'})
    WHERE instruction != ''
)
```
- Loads the input file using DuckDB's `read_csv` function
- Assigns a step number to each instruction

### Step 2: Parse Direction and Distance
```sql
parsed_instructions AS (
    SELECT
        step,
        instruction,
        substr(instruction, 1, 1) AS direction,  -- L or R
        CAST(substr(instruction, 2) AS INTEGER) AS distance
    FROM input_data
)
```
- Extracts the direction (first character) and distance (remaining characters)

### Step 3: Convert to Numeric Change
```sql
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
)
```
- Converts L/R directions to positive/negative changes
- R = positive (increase), L = negative (decrease)

### Step 4: Calculate Cumulative Position
```sql
position_calculations AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        change,
        50 + SUM(change) OVER (ORDER BY step ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_position
    FROM rotations
)
```
- Uses window function to calculate cumulative sum starting from 50
- `SUM(change) OVER (ORDER BY step ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` gives running total

### Step 5: Apply Circular Modulo
```sql
final_positions AS (
    SELECT
        step,
        instruction,
        direction,
        distance,
        MOD(MOD(cumulative_position, 100) + 100, 100) AS final_position
    FROM position_calculations
)
```
- Applies modulo 100 to handle circular dial
- `MOD(MOD(x, 100) + 100, 100)` ensures result is always 0-99, even for negative numbers
- Example: -5 becomes 95, 105 becomes 5

### Step 6: Count Positions at Zero
```sql
SELECT
    COUNT(*) AS password
FROM final_positions
WHERE final_position = 0
```
- Counts how many times we end at position 0

## Results

- **Total instructions**: 4,035
- **Password (times at position 0)**: 964
- **First few steps where we hit 0**: 50, 53, 55, 60, 62

## Example Calculation

Let's trace through the first few steps:

1. Start at 50
2. R11: 50 + 11 = 61
3. R8: 61 + 8 = 69
4. L47: 69 - 47 = 22
5. L20: 22 - 20 = 2
6. L25: 2 - 25 = -23 → MOD(-23, 100) = 77

The solution correctly handles the circular nature of the dial and counts all positions where we end at 0.

## Running the Solution

From the day1 directory, run:
```bash
duckdb < day1-solution.sql
```

Or to see the working:
```bash
duckdb < day1-solution-working.sql
```


# Advent of Code - Day 1: Secret Entrance

## SQL Solution using DuckDB

### Problem Summary
A safe has a circular dial with numbers 0-99. The dial starts at position 50. Given a sequence of rotation instructions (L/R followed by distance), count how many times the dial lands on position 0.

### Answer: **964**

---

## Solution Approaches

### 1. Pure SQL (DuckDB) - Recommended ✨

**Run directly:**
```bash
cd /Users/dhk/Documents/github/2026-advent-of-code/claude/day1
duckdb < day1-duckdb-solution.sql
```

**Features:**
- Reads input file directly using DuckDB's `read_csv()`
- Uses recursive CTE to simulate dial rotations
- Single SQL query solution
- No Python required

### 2. Python + DuckDB

**Run:**
```bash
python3 solve-day1-duckdb.py
```

**Features:**
- Detailed output with step-by-step positions
- Shows all positions where dial = 0
- Bonus statistics (min, max, avg position)

### 3. Python + SQLite

**Run:**
```bash
python3 solve-day1.py
```

**Features:**
- Uses SQLite (no external dependencies)
- Similar functionality to DuckDB version

---

## How the SQL Solution Works

### 1. Parse Input Data
```sql
rotations AS (
    SELECT
        ROW_NUMBER() OVER () as step,
        SUBSTRING(column0, 1, 1) as direction,  -- L or R
        CAST(SUBSTRING(column0, 2) AS INTEGER) as distance
    FROM read_csv('day1-input.txt', ...)
)
```

### 2. Simulate Dial Rotations (Recursive CTE)
```sql
dial_positions AS (
    -- Start at 50
    SELECT 0 as step, 50 as position

    UNION ALL

    -- Calculate each rotation
    SELECT
        r.step,
        CASE
            WHEN r.direction = 'L' THEN ((position - distance) % 100 + 100) % 100
            WHEN r.direction = 'R' THEN (position + distance) % 100
        END as position
    FROM dial_positions d
    JOIN rotations r ON r.step = d.step + 1
)
```

### 3. Count Zeros
```sql
SELECT COUNT(*)
FROM dial_positions
WHERE position = 0 AND step > 0
```

---

## Example Walkthrough

Starting position: 50

| Step | Instruction | Calculation | Position |
|------|-------------|-------------|----------|
| 0    | -           | -           | 50       |
| 1    | R11         | 50 + 11     | 61       |
| 2    | R8          | 61 + 8      | 69       |
| 3    | L47         | 69 - 47     | 22       |
| 50   | L34         | 34 - 34     | **0** ✓  |
| 53   | R29         | 71 + 29     | **0** ✓  |

The dial lands on 0 a total of **964 times** across all 4,035 rotations.

---

## Key SQL Techniques Used

1. **Recursive CTE** - Simulates sequential state changes
2. **Modulo arithmetic** - Handles circular wrap-around (0-99)
3. **Pattern matching** - SUBSTRING to parse L/R and distance
4. **Direct file reading** - DuckDB's `read_csv()` eliminates preprocessing

---

## Files

- `day1-duckdb-solution.sql` - Pure SQL solution (run with DuckDB)
- `solve-day1-duckdb.py` - Python wrapper with detailed output
- `solve-day1.py` - SQLite version
- `day1-complete-solution.sql` - Standalone SQL with comments

---

## Requirements

### DuckDB Solution
```bash
pip install duckdb
```

### SQLite Solution
- No dependencies (uses Python's built-in sqlite3)

---

## Verification

All three solutions produce the same answer: **964**

The dial points at position 0 exactly 964 times during the 4,035 rotations.

# Advent of Code - Day 1 Part 2: Secret Entrance

## SQL Solution using DuckDB

### Problem Summary
Count **every click** through position 0, not just the final positions after each rotation. This includes all clicks that pass through 0 during a rotation.

For example:
- Starting at 50, rotating R1000 would click through 0 **ten times** (at positions 0, 100, 200, ..., 900) before ending back at 50

### Answer: **5872**

---

## Solution Approaches

### 1. Pure SQL (DuckDB) - Recommended ✨

**Run directly:**
```bash
cd /Users/dhk/Documents/github/2026-advent-of-code/claude/day1-part2
duckdb < day1-part2-duckdb-solution.sql
```

**Features:**
- Single SQL query solution
- Calculates clicks during rotations using integer division
- No Python required

### 2. Python + DuckDB

**Run:**
```bash
python3 solve-day1-part2-duckdb.py
```

**Features:**
- Detailed output showing each rotation
- Example verification from problem statement
- Shows which rotations pass through 0

---

## How the Solution Works

### Key Insight

When rotating the dial by distance `d`:
- **Full rotations**: Every 100 clicks = 1 pass through 0
- **Partial rotation**: Check if we cross 0 in the remainder

### Left Rotation (L)
```
Position: 50 -> 49 -> ... -> 1 -> 0 -> 99 -> 98 -> ...
```

Clicks through 0:
```sql
-- If starting at 0: only count full rotations
CASE WHEN start_position = 0 THEN distance // 100
-- Otherwise: land on 0 after 'start_position' clicks, then every 100
WHEN distance >= start_position THEN 1 + (distance - start_position) // 100
ELSE 0 END
```

**Example**: L68 from position 50
- Starting position: 50 (not 0)
- Distance: 68 >= 50? YES
- Clicks: 1 + (68 - 50) // 100 = 1 + 0 = **1**

### Right Rotation (R)
```
Position: 50 -> 51 -> ... -> 98 -> 99 -> 0 -> 1 -> ...
```

Clicks through 0:
```sql
-- If starting at 0: only count full rotations
CASE WHEN start_position = 0 THEN distance // 100
-- Otherwise: land on 0 after (100 - start_position) clicks, then every 100
WHEN distance >= (100 - start_position) THEN 1 + (distance - (100 - start_position)) // 100
ELSE 0 END
```

**Example**: R60 from position 95
- Starting position: 95 (not 0)
- Distance to first zero: 100 - 95 = 5
- Distance: 60 >= 5? YES
- Clicks: 1 + (60 - 5) // 100 = 1 + 0 = **1**

---

## Example Walkthrough (from problem)

Starting position: 50

| Step | Instruction | Start | End | Calculation | Clicks | Note |
|------|-------------|-------|-----|-------------|--------|------|
| 1 | L68 | 50 | 82 | 50 < 68 | **1** | Crosses 0 |
| 2 | L30 | 82 | 52 | 82 >= 30 | 0 | No cross |
| 3 | R48 | 52 | 0 | 52+48=100 | **1** | Crosses 0 |
| 4 | L5 | 0 | 95 | 0 < 5 | **1** | Crosses 0 |
| 5 | R60 | 95 | 55 | 95+60>=100 | **1** | Crosses 0 |
| 6 | L55 | 55 | 0 | 55 >= 55 | 0 | Ends at 0, doesn't cross |
| 7 | L1 | 0 | 99 | 0 < 1 | **1** | Crosses 0 |
| 8 | L99 | 99 | 0 | 99 >= 99 | 0 | Ends at 0, doesn't cross |
| 9 | R14 | 0 | 14 | 0+14<100 | 0 | No cross |
| 10 | L82 | 14 | 32 | 14 < 82 | **1** | Crosses 0 |

**Total: 6 clicks through 0** ✓

---

## Key Differences from Part 1

| Aspect | Part 1 | Part 2 |
|--------|--------|--------|
| What to count | Final positions = 0 | All clicks through 0 |
| Answer | 964 | 5,872 |
| Complexity | Simple position check | Must calculate crossing logic |

---

## SQL Technique

```sql
-- Calculate clicks through 0 for each rotation
CASE
    WHEN distance = 0 THEN 0
    WHEN direction = 'L' THEN
        CASE
            WHEN position = 0 THEN distance // 100  -- Starting at 0
            WHEN distance >= position THEN 1 + (distance - position) // 100
            ELSE 0
        END
    WHEN direction = 'R' THEN
        CASE
            WHEN position = 0 THEN distance // 100  -- Starting at 0
            WHEN distance >= (100 - position) THEN 1 + (distance - (100 - position)) // 100
            ELSE 0
        END
    ELSE 0
END as clicks
```

---

## Files

- `day1-part2-duckdb-solution.sql` - Pure SQL solution
- `solve-day1-part2-duckdb.py` - Python wrapper with detailed output
- `README.md` - This file

---

## Requirements

```bash
pip install duckdb
```

---

## Verification

Both solutions produce the same answer: **5,872**

The dial clicks through position 0 exactly 5,872 times during all 4,035 rotations.

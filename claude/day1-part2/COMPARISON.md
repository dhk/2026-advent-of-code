# Day 1: Part 1 vs Part 2 Comparison

## Quick Summary

| Metric | Part 1 | Part 2 |
|--------|--------|--------|
| **Answer** | 964 | 5,872 |
| **What to Count** | Final positions = 0 | All clicks through 0 |
| **Complexity** | Simple | Medium |

---

## The Key Difference

### Part 1: "After Any Rotation"
Count the number of times the dial **ends** at position 0 after completing a rotation.

**Example**: L68 from position 50 → ends at 82
- Passes through 0 during rotation? YES, but **don't count** it
- Ends at 0? NO
- **Count: 0**

### Part 2: "Any Click"
Count **every single click** where the dial points at 0, including during rotations.

**Example**: L68 from position 50 → ends at 82
- 50 → 49 → 48 → ... → 1 → **0** → 99 → ... → 82
- Clicks through 0 during rotation? YES
- **Count: 1**

---

## Another Example: R1000 from position 50

### Part 1
- 50 + 1000 = 1050
- 1050 % 100 = 50
- Ends at position 50, not 0
- **Count: 0**

### Part 2
- Distance = 1000 clicks
- Every 100 clicks passes through 0 once
- 1000 / 100 = 10 complete rotations
- Each rotation passes 0 once
- **Count: 10**

---

## SQL Logic Comparison

### Part 1: Simple Position Check
```sql
SELECT COUNT(*)
FROM dial_positions
WHERE position = 0 AND step > 0
```

### Part 2: Calculate Crossings
```sql
-- For LEFT rotations
clicks = (distance // 100) +
         CASE WHEN start_pos < (distance % 100) THEN 1 ELSE 0 END

-- For RIGHT rotations
clicks = (distance // 100) +
         CASE WHEN start_pos + (distance % 100) >= 100 THEN 1 ELSE 0 END
```

---

## Why Part 2 Answer is Larger

1. **Part 1 counted**: 964 final positions
2. **Part 2 includes**:
   - All clicks through 0, whether ending there or passing through
   - **Total: 5,872**

The difference (5,872 - 964 = 4,442) represents all the times the dial clicked through 0 **during** a rotation without ending there.

---

## Tricky Cases

### Case 1: Starting at 0
**Rotation**: L5 from position 0

- **Part 1**: Ends at 95, not 0 → Count: 0
- **Part 2**: Goes 0 → 99 → 98 → 97 → 96 → 95, crosses 0 once → Count: 1

### Case 2: Ending at 0
**Rotation**: L100 from position 0

- **Part 1**: Ends at 0 → Count: 1
- **Part 2**: Makes exactly one full loop, crosses 0 once → Count: 1

(Same result, but for different reasons!)

### Case 3: Multiple Loops
**Rotation**: R250 from position 75

- **Part 1**: (75 + 250) % 100 = 25, not 0 → Count: 0
- **Part 2**:
  - Crosses 0 at: 100, 200, 300
  - Total: 3 crossings → Count: 3

---

## Files Location

```
claude/
├── day1/              # Part 1
│   ├── README.md
│   ├── day1-duckdb-solution.sql
│   └── solve-day1-duckdb.py
└── day1-part2/        # Part 2
    ├── README.md
    ├── COMPARISON.md (this file)
    ├── day1-part2-duckdb-solution.sql
    └── solve-day1-part2-duckdb.py
```

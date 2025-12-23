# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an Advent of Code solutions repository that uses **SQL (DuckDB)** to solve puzzles. Each day's solution is organized in its own folder (e.g., `day1/`, `day2/`) with multiple files documenting the problem, solution, and approach.

## Commands

### Running Solutions
```bash
# Run a solution from within the dayX directory
cd dayX
duckdb < dayX-solution.sql

# Or run directly from root
duckdb < dayX/dayX-solution.sql
```

### Testing Working Steps
```bash
# View step-by-step working (shows first 20-50 intermediate steps)
cd dayX
duckdb < dayX-solution-working.sql
```

## File Structure

Each day's solution follows a strict structure in its `dayX/` folder:

1. **`dayX-prompt.txt`** - Original problem description
2. **`dayX-input.txt`** - Input data for the puzzle
3. **`dayX-solution.sql`** - Main solution that produces the final answer
4. **`dayX-solution-working.sql`** - Step-by-step working showing intermediate results (first 20-50 steps)
5. **`dayX-solution-explanation.md`** - Detailed explanation including:
   - Problem summary
   - Solution approach with step-by-step breakdown
   - Key SQL features used
   - Results and verification
   - Example calculations
   - How to run the solution
6. **`dayX-pr-description.md`** - PR description for the solution

**Note:** Part 2 solutions may follow a similar naming convention with `-part2` suffix (e.g., `day1-part2-solution.sql`)

## SQL Solution Guidelines

### DuckDB-Specific Patterns
- Use **CTEs (Common Table Expressions)** to break down problems into logical steps
- Use **window functions** for cumulative calculations (e.g., `SUM() OVER (ORDER BY step)`)
- Read input files using `read_csv()` with relative paths (e.g., `'dayX-input.txt'`)
- Handle circular/modular arithmetic correctly: `MOD(MOD(x, 100) + 100, 100)` to ensure positive results

### Code Style
- Name CTEs descriptively: `input_data`, `parsed_instructions`, `calculations`, `final_positions`
- Add clear inline comments explaining each step
- Use proper SQL formatting and indentation
- Structure solutions as a series of CTEs leading to a final SELECT

### Common Patterns
```sql
-- Reading input
WITH input_data AS (
    SELECT row_number() OVER () AS step, column_name
    FROM read_csv('dayX-input.txt', header=false, columns={'column_name': 'VARCHAR'})
    WHERE column_name != ''
)

-- Parsing instructions
parsed_instructions AS (
    SELECT step, substr(instruction, 1, 1) AS direction,
           CAST(substr(instruction, 2) AS INTEGER) AS distance
    FROM input_data
)

-- Cumulative calculations with window functions
position_calculations AS (
    SELECT step,
           50 + SUM(change) OVER (ORDER BY step ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_position
    FROM rotations
)
```

## Solution Workflow

When solving a new day's puzzle:

1. Read `dayX-prompt.txt` to understand the problem
2. Read `dayX-input.txt` to understand the input format
3. Design SQL solution using CTEs for clarity
4. Create `dayX-solution.sql` - main solution
5. Create `dayX-solution-working.sql` - show intermediate steps (limit to first 20-50 rows)
6. Test solution and verify answer
7. Create `dayX-solution-explanation.md` - document the approach
8. Create `dayX-pr-description.md` - PR description

Use the template in `quick-prompt-template.txt` or detailed guidelines in `advent-of-code-solution-prompt.md` for reference.

## Verification

- Always verify solutions with examples from the prompt (if provided)
- Test that solutions handle edge cases (negative numbers, modulo arithmetic, etc.)
- Ensure working files show meaningful intermediate steps
- Check that all files use relative paths for input files

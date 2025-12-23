# Advent of Code Solution Prompt Template

Use this prompt for solving Advent of Code problems with SQL (DuckDB).

## Instructions

1. Read the problem description from `dayX-prompt.txt` to understand the task
2. Read the input data from `dayX-input.txt`
3. Solve the problem using SQL with DuckDB
4. Show your working step-by-step
5. Create comprehensive documentation

## Solution Requirements

### File Structure
Create the following files in the `dayX/` folder:

1. **`dayX-solution.sql`** - Main solution file that produces the final answer
2. **`dayX-solution-working.sql`** - Step-by-step working showing intermediate results (first 20-50 steps)
3. **`dayX-solution-explanation.md`** - Detailed explanation including:
   - Problem summary
   - Solution approach with step-by-step breakdown
   - Key SQL features used
   - Results and verification
   - Example calculations
   - How to run the solution
4. **`dayX-pr-description.md`** - PR description including:
   - Problem summary
   - Solution approach
   - Answer
   - Files included
   - How to run
   - Verification
   - Results

### SQL Solution Guidelines

- Use **DuckDB** for SQL execution
- Structure solution with **CTEs (Common Table Expressions)** for clarity
- Use **window functions** where appropriate for cumulative calculations
- Add **clear comments** explaining each step
- Handle edge cases (negative numbers, modulo arithmetic, etc.)
- Use relative paths for input files (e.g., `'dayX-input.txt'`)

### Code Style

- Break complex problems into logical steps using CTEs
- Name CTEs descriptively (e.g., `input_data`, `parsed_instructions`, `calculations`)
- Add inline comments explaining non-obvious logic
- Use proper SQL formatting and indentation
- Include verification queries when possible

### Documentation Style

- Start with a clear problem summary
- Explain the approach before showing code
- Show example calculations for clarity
- Include verification steps
- Provide clear instructions for running the solution
- List all files created and their purposes

## Example Workflow

```
1. Read dayX-prompt.txt → Understand problem
2. Read dayX-input.txt → Understand input format
3. Design SQL solution using CTEs
4. Create dayX-solution.sql → Main solution
5. Create dayX-solution-working.sql → Show working
6. Test solution → Verify answer
7. Create dayX-solution-explanation.md → Document approach
8. Create dayX-pr-description.md → PR description
```

## Verification Checklist

- [ ] Solution produces correct answer
- [ ] Tested with example from prompt (if provided)
- [ ] Working file shows step-by-step process
- [ ] Explanation document is comprehensive
- [ ] PR description includes all relevant information
- [ ] Files use relative paths
- [ ] Code is well-commented
- [ ] Solution handles edge cases

## Template Prompt for AI Assistant

```
Use the information in dayX-prompt.txt to understand the task at hand.

Solve the problem using the information in dayX-input.txt.

Do it in SQL. Show me your working. Use DuckDB.

Requirements:
1. Create dayX-solution.sql - main solution that produces the answer
2. Create dayX-solution-working.sql - shows step-by-step working (first 20-50 steps)
3. Create dayX-solution-explanation.md - detailed explanation of approach
4. Create dayX-pr-description.md - PR description with problem summary, solution, files, and results

Place all files in the dayX/ folder.

Use relative paths for input files (e.g., 'dayX-input.txt').

Show your working step-by-step with clear comments.
```

## Notes

- Always verify the solution with the example from the prompt (if provided)
- Use window functions for cumulative calculations
- Handle circular/modular arithmetic correctly (e.g., `MOD(MOD(x, 100) + 100, 100)`)
- Break complex problems into smaller, understandable steps
- Document assumptions and edge cases
- Make solutions readable and maintainable


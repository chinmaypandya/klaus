# Documentation

Every unit of work ships with its docs. Not later, not in a follow-up pass.

## What gets documented
- Every public class, method, and function.
- Every non-obvious private method.
- Every module or package: a short header stating its responsibility.
- Every configuration flag, env var, and public constant.

## Doc comment structure
Use the language's native format (docstring, Javadoc, TSDoc, rustdoc) with the
same sections in the same order every time:

1. One-line summary, imperative mood, ending in a period.
2. Blank line, then a short paragraph on *why* this exists — only if the summary
   doesn't cover it.
3. Parameters, each with meaning and constraints (not just the type restated).
4. Return value, including what an empty or null result means.
5. Errors or exceptions raised, and under what condition.
6. A usage example, when the call isn't obvious from the signature.

## Comment rules
- Comments explain *why*, never *what*. If a comment restates the code, delete
  the comment or rename the code.
- A comment explaining a workaround must name the reason (bug, upstream issue,
  platform quirk) and the condition for removing it.
- No commented-out code. Version control exists.

## README expectations
Each project's README covers: what it does, how to run it, how to test it, how
to configure it. Update it in the same change that invalidates it.

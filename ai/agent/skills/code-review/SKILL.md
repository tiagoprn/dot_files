---
name: code-review
description: Review code snippets for readability, maintainability, SOLID principles, and GoF design patterns.
---

## CODE_REVIEW

Your task is to review the provided code snippet.

### RULES

1) READABILITY AND MAINTAINABILITY: Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- When you see the use of excessively long names for variables or functions, suggest shorter ones and docstrings or comments to explain something more specific.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
- Absent error handling that you identify that could be added.
- Other issues related to this subject as covered by the "Clean Code" standard.

2) Standards like SOLID and Clean Code.

3) Gang of Four (GoF) design patterns that promote simplicity, extensibility, and maintainability:
- Factory / Abstract Factory
- Singleton
- Decorator
- Strategy
- Observer
Only suggest patterns from the list above, and give a brief explanatation on the IMPROVEMENT section as described below on why you suggested the pattern and the benefits/drawbacks to applying it to the code.

Finally, your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

### RESPONSE FORMAT

Format your feedback as follows:

NUMBER: (increment this for this way it gets easier for me to ask more questions regarding a specific one)
CODE: (state the code with the problem here - including the file name and the line or lines involved)
CATEGORY: (here describe the type of the improvement as one of the 3 specified above, in a few words. E.g.: Readability, Maintenability, SOLID, Clean Code, GoF Design Patterns )
IMPROVEMENT: (describe here the improvement you suggest as text)
SUGGESTION: (write the code here, with minimal comments if they are needed).

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.

---
name: automated-code-review
description: Automates code review by analyzing code for best practices, potential bugs, stylistic issues, and suggesting improvements.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: code-review
---

## Automated Code Review Skill

This skill is designed to assist developers by performing automated code reviews. It analyzes code against predefined rules, identifies potential issues, suggests improvements, and can integrate with existing static analysis tools and linters.

### Capabilities:

*   **Static Analysis Integration**: Runs configured static analysis tools (e.g., linters, security scanners) and interprets their output.
*   **Best Practice Enforcement**: Checks code against common programming best practices for the detected language/framework.
*   **Bug Pattern Detection**: Identifies common bug patterns and suggests fixes.
*   **Stylistic Consistency**: Ensures code adheres to defined stylistic guidelines.
*   **Suggestion Generation**: Provides actionable recommendations for code improvement, including code snippets where applicable.
*   **Custom Rule Support**: Allows for the definition and application of custom code review rules.

### Workflow:

1.  **Trigger**: The skill can be triggered manually or automatically (e.g., on a `git push` to a feature branch, or before a pull request is created).
2.  **Analysis Scope**: Defines which files or changes are to be reviewed (e.g., only changed files, specific directories).
3.  **Tool Execution**: Executes relevant static analysis tools (e.g., ESLint for JavaScript, Ruff for Python, TypeScript compiler for TypeScript).
4.  **Result Interpretation**: Parses the output of these tools and combines it with internal best practice checks.
5.  **Report Generation**: Generates a summary report of findings, including severity, description, and suggested remedies.
6.  **Actionable Feedback**: Provides feedback in a format suitable for direct application (e.g., comments on a PR, inline suggestions).

### Usage:

To use this skill, you would typically invoke it with the following parameters:
*   `target_files`: (Optional) A list of files or glob patterns to focus the review on. If not provided, it will attempt to review recent changes or the entire codebase depending on configuration.
*   `level`: (Optional) The thoroughness level for the review (e.g., "quick", "thorough", "security-focused").
*   `output_format`: (Optional) The desired output format for the review report (e.g., "text", "markdown", "json", "pr-comment").
Example invocation (conceptual):
```
/review-code target_files="src/**/*.ts" level="thorough" output_format="pr-comment"
```
This skill will then:
1.  Identify the project's language and relevant tools (e.g., `npm run lint` for a Node.js project, `ruff check .` for a Python project).
2.  Execute these tools and capture their output.
3.  Analyze the output and potentially perform additional checks based on best practices.
4.  Generate a comprehensive review report.

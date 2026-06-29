# Contributing to initial-server-setup

Thank you for your interest in contributing! This project welcomes all contributions — from fixing typos to adding new documentation or improving automation scripts.

## How to Contribute

1. **Fork** this repository.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/initial-server-setup.git
   ```
3. **Create a new branch** for your change:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes** following the guidelines below.
5. **Commit** with a descriptive message:
   ```bash
   git commit -m "feat: add guide for logrotate configuration"
   ```
6. **Push** your branch and open a **Pull Request**.

## Guidelines

### For Documentation
- Write clearly and simply. Assume the reader is a beginner.
- Always test commands before adding them.
- If a command differs between Ubuntu and RHEL-based systems, show both.
- Use proper markdown formatting — see existing docs for style reference.

### For Scripts
- Add clear comments above every section explaining *why*, not just *what*.
- Scripts must be idempotent — safe to run more than once.
- Add a safety confirmation prompt for any destructive or irreversible actions.
- Test on a clean minimal ISO before submitting.

## Reporting Issues
Found an error, outdated command, or missing topic? Please open an issue and describe:
- The OS and version you were using.
- The command or section that is incorrect.
- What you expected vs. what happened.

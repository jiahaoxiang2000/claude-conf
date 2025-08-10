# Commit and Push Changes

Commit staged changes with emoji-first format and immediately push to remote repository.

## Commit Message Format

```
<emoji> <type>: <description>

- Detailed explanation of changes
- Follow up with specific modifications
- Reference issues if applicable

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Emoji Mapping

- 🎉 feat: New feature
- 🐛 fix: Bug fix  
- 📚 docs: Documentation
- 🎨 style: Code style/formatting
- ♻️ refactor: Code refactoring
- ⚡ perf: Performance improvement
- 🧪 test: Tests
- 🔨 build: Build system
- 👷 ci: CI/CD
- 🔧 chore: Maintenance

## Implementation

When this command is used, it will:
1. Check for staged changes
2. Select appropriate emoji based on type
3. Format commit message with emoji prefix
4. Execute git commit with the formatted message
5. Immediately push to remote repository
6. Push tags if --tags flag is provided
7. Display success/failure status for both operations

## Safety Features

- Validates staged changes exist before committing
- Shows commit summary before pushing
- Handles push failures gracefully
- Confirms successful operations
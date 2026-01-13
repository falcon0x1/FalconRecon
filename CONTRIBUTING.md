# Contributing to FalconRecon 𓅃

Thank you for your interest in contributing to FalconRecon! 🐦‍🔥

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/falcon0x1/FalconRecon/issues)
2. If not, create a new issue using the bug report template
3. Include:
   - OS and version
   - Bash version (`bash --version`)
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs

### Suggesting Features

1. Check existing [feature requests](https://github.com/falcon0x1/FalconRecon/issues?q=is%3Aissue+label%3Aenhancement)
2. Open a new issue using the feature request template
3. Describe your use case and proposed solution

### Pull Requests

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/YOUR_USERNAME/FalconRecon.git`
3. **Create a branch**: `git checkout -b feature/your-feature`
4. **Make changes** following the code style below
5. **Test** your changes thoroughly
6. **Commit**: `git commit -m 'Add: description of changes'`
7. **Push**: `git push origin feature/your-feature`
8. **Open a Pull Request**

## Code Style

### Bash Guidelines

```bash
# Use snake_case for function names
my_function() {
    local variable="value"  # Use local variables
    # ...
}

# Use UPPERCASE for constants
CONSTANT_VALUE="something"

# Always quote variables
echo "$variable"

# Use [[ ]] for conditionals
if [[ "$var" == "value" ]]; then
    # ...
fi
```

### Commit Messages

Use conventional commit format:

- `Add:` New feature
- `Fix:` Bug fix
- `Update:` Enhancement
- `Docs:` Documentation
- `Refactor:` Code refactoring

### Egyptian Theme

When adding new modules, follow the hieroglyphic theme:

| Symbol | Usage |
|--------|-------|
| 𓅃 | Primary branding |
| 𓆲 | Section headers |
| 𓅈 𓅉 𓅂 | Module indicators |
| 𖤍 | Checkmarks/status |
| 🐦‍🔥 | Special highlights |

## Development Setup

```bash
# Clone and setup
git clone https://github.com/falcon0x1/FalconRecon.git
cd FalconRecon

# Install shellcheck for linting
sudo apt install shellcheck

# Run linter
shellcheck FalconRecon.sh setup_tools.sh

# Test syntax
bash -n FalconRecon.sh
```

## Questions?

Open an issue or reach out to [@falcon0x1](https://github.com/falcon0x1).

---

𓅃 Thank you for contributing! 🐦‍🔥

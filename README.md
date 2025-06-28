# Claude Code Configuration

This directory contains Claude Code configuration files and custom commands for the All-in-MCP project.

## Directory Structure

```
.claude/
├── README.md              # This documentation file
├── settings.json          # Main Claude Code settings
├── settings.local.json    # Local environment settings
└── commands/              # Custom command definitions
    ├── crypto-research.md # Cryptography research assistant
    ├── search-papers.md   # Academic paper search commands
    └── wpaper.md          # Academic paper writing assistant
```

## Configuration Files

### settings.json

Core Claude Code settings including:

- Permission configurations for tools and commands
- Default operation modes
- MCP server integration settings

### settings.local.json

Local environment-specific configurations and overrides.

## Custom Commands

### Academic Research Commands

#### `/search-papers` - Paper Search Assistant

Search for academic papers across multiple platforms:

- **IACR ePrint Archive**: Cryptography and security papers
- **Google Scholar**: Broad academic search across disciplines
- **Crossref**: Academic publications with DOI metadata
- **CryptoBib**: Specialized cryptography bibliography

**Usage Examples:**

```
Search for neural networks papers on Google Scholar
Search for "homomorphic encryption" on IACR
Find recent cryptography papers from 2024
```

#### `/crypto-research` - Cryptography Research Assistant

Specialized assistant for cryptographic research with access to:

- IACR paper search and download
- CryptoBib bibliography search
- Paper analysis and summarization
- Research trend identification

**Research Areas:**

- Symmetric/Asymmetric Cryptography
- Post-Quantum Cryptography
- Zero-Knowledge Proofs
- Blockchain & Applied Crypto

#### `/wpaper` - Academic Writing Assistant

Enhance academic paper writing with rigorous standards:

- Precise, academic language optimization
- Objective tone and passive voice conversion
- Technical precision and redundancy elimination
- Reproducible methodology descriptions

**Usage Examples:**

```
/wpaper abstract "We propose a new cryptographic protocol..."
/wpaper methodology "The algorithm consists of three phases..."
/wpaper review "Check this introduction for academic tone"
```

## All-in-MCP Integration

These commands leverage the All-in-MCP server tools:

### Available MCP Tools

- `mcp__all-in-mcp__search-iacr-papers`
- `mcp__all-in-mcp__search-google-scholar-papers`
- `mcp__all-in-mcp__search-crossref-papers`
- `mcp__all-in-mcp__search-cryptobib-papers`
- `mcp__all-in-mcp__download-iacr-paper`
- `mcp__all-in-mcp__read-iacr-paper`
- `mcp__all-in-mcp__read-pdf`

### Project Context

The commands are tailored for the All-in-MCP project, which provides:

- Academic paper search across multiple platforms
- PDF processing and text extraction
- Standardized paper data models
- MCP server architecture for tool integration

## Usage Guidelines

1. **Research Workflow**: Use search commands to find relevant papers, then analyze with crypto-research or wpaper commands
2. **Writing Support**: Leverage wpaper for academic writing enhancement and clarity
3. **Development**: Commands integrate with the project's development tools and testing frameworks

## Development Commands

For development tasks, use standard Claude Code tools:

- File operations (Read, Edit, Write)
- Code execution (Bash)
- Project navigation (Glob, Grep, LS)

See the main project `CLAUDE.md` for development guidelines and commands.

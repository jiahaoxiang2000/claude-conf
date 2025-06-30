# Academic Paper Research Assistant

## Objective

Find and analyze academic papers related to the user's research context with emphasis on cryptographic literature quality and relevance.

## Systematic Research Process

### Step 1: Primary Search

- **Action**: Use `mcp__all-in-mcp__search-iacr-papers` to search IACR ePrint Archive
- **Rationale**: IACR is the premier venue for cryptographic research
- **Output**: Extract title, authors, abstract, publication year, and paper ID

### Step 2: Relevance Assessment

- **Criteria**: Evaluate papers based on:
  - Alignment with user's research question
  - Methodological relevance
  - Temporal relevance (recent publications preferred)
- **Decision**: Select top 3-5 most relevant papers for further analysis

### Step 3: Quality Verification

- **Action**: Use `mcp__all-in-mcp__search-cryptobib-papers` to verify inclusion in CryptoBib database
- **Purpose**: Validate academic quality and peer review status
- **Rule**: Exclude papers not found in CryptoBib database

### Step 4: Deep Analysis

- **Action**: Use `mcp__all-in-mcp__read-iacr-paper` for selected high-quality papers
- **Focus**: Extract key contributions, methodology, experimental results, and limitations
- **Deliverable**: Structured summary of findings relevant to user's research

## Quality Criteria

- Peer-reviewed publications only
- Indexed in CryptoBib database
- Directly relevant to research context
- Recent publications (last 5 years preferred)

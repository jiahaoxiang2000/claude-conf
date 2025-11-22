# Invalid IP Address Issue

**Issue Link:** https://github.com/anthropics/claude-code/issues/12081

**Summary:** `/login` command fails with "OAuth error: Invalid IP address: undefined" error, particularly affecting users behind proxies.

**Symptoms**
- Running `/login` in Claude Code returns: `OAuth error: Invalid IP address: undefined`
- Retrying does not resolve the issue
- Affects users behind proxies
- Issue introduced in v2.0.48+

**Affected Versions**
- v2.0.48+
- Confirmed on v2.0.49 and v2.0.50

**Affected Platforms**
- macOS
- Linux (including WSL Ubuntu)
- Windows appears unaffected

**Workaround**

Downgrade to v2.0.47:

```bash
npm install -g @anthropic-ai/claude-code@2.0.47
rm -rf ~/.config/claude-code
claude auth login
```

To prevent auto-update, add to `~/.claude/settings.json`:

```json
{
  "env": { "DISABLE_AUTOUPDATER": "1" }
}
```

**Status:** Open - Regression introduced in v2.0.48

---

## Background: Claude Operational Changes

**September 5th Policy Changes**
- Anthropic released news: https://www.anthropic.com/news/updating-restrictions-of-sales-to-unsupported-regions
- Restricted Claude service access for China region
- Based on regional restriction policy, Chinese users began facing service access limitations
- User experience gradually deteriorated

**November 14th Security Incident**
- Anthropic released report: https://www.anthropic.com/news/disrupting-AI-espionage
- Threat actor "Chinese state-sponsored group" using Claude for cyberattacks discovered
- High-confidence assessment of Chinese-related organizations using Claude for code development for cyberattacks
- This event intensified restrictions on Chinese region users

**Current Status (November 22, 2025)**
- Our IP has been banned
- Anthropic implements strict access restrictions for mainland Chinese users
- We have completely lost trust in Claude
- Need to find reliable alternatives

---

## Alternative: Qwen Code

**Discovery**
- On July 23rd, we discovered Qwen Code published at https://qwen.ai/blog?id=qwen3-coder
- Initially had 256K context length, later upgraded to 1M in Qwen3-Coder-Plus
- Regular updates and new features added to the client at https://github.com/QwenLM/qwen-code
- Detailed introduction available at https://github.com/QwenLM/qwen-code/blob/main/docs/index.md
- We have transferred our main workflow including agents using commands & subagents to Qwen at https://github.com/jiahaoxiang2000/qwen-config/

Basic functionality is now operational. Qwen Code provides a viable replacement solution.

**Features and Advantages**
- Large context window: Up to 1M tokens (vs Claude's 200K)
- Cost-effective for heavy usage
- Better integration with Chinese language and cultural context
- Open source components allow for customization and control
- Compatible with our existing workflow patterns
- Context length evolution: 256K → 1M tokens in Qwen3-Coder-Plus
- Active client development with regular updates
- Integration with agent commands and subagents
- Maintained in mainland China, avoiding regional restrictions

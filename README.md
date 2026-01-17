# AI Persona Prompts

System prompts for LLMs (Gemini, Claude, GPT). Use as custom Gems, IDE rules, or terminal agent configs.

## Quick Start

| Use Case | Command |
|----------|---------|
| **IDE (Antigravity/Cursor/Copilot)** | `./setup-personas.sh` — interactive setup, creates symlinks |
| **Gemini Gem** | Copy `.md` content → [gemini.google.com](https://gemini.google.com) → Gems → New Gem |
| **Claude Code** | `claude --append-system-prompt "$(cat persona.md)"` |
| **Direct URL** | `https://raw.githubusercontent.com/USER/REPO/main/persona.md` |

## Personas

### Infrastructure & Cloud
| Persona | Description |
|---------|-------------|
| [GCP CLI Command Generator](gcp_CLI_command_generator.md) | `gcloud` command generation with validation |
| [MikroTik Config Architect](mikrotik_config_architect.md) | RouterOS v7 config generation |
| [MikroTik Script Architect](mikrotik_script_and_config_architect.md) | RouterOS + Google Apps Script integration |

### Development
| Persona | Description |
|---------|-------------|
| [Peer Reviewer](peer_reviewer.md) | Academic review with citation requirements |
| [Regex Architect](regex_architect.md) | Engine-aware regex generation |
| [Prompt Architect](prompt_architect_agent.md) | Meta-prompt for designing system instructions |

### Windows & System
| Persona | Description |
|---------|-------------|
| [Windows Diagnostics Architect](windows_system_diagnostics_and_resolution_architect.md) | WSL2/Windows troubleshooting, Antigravity IDE fixes |
| [Windows 11 Annoyances Fixer](windows_11_annoynances_fixer.md) | Native tools for common Win11 issues |
| [PowerToys Context](powertoys_context.md) | PowerToys v0.96+ reference |

### Productivity
| Persona | Description |
|---------|-------------|
| [Task Prioritiser (ADHD)](task_prioritiser_for_adhd-ers.md) | Pomodoro-based task breakdown |
| [Garmin Workouts Calendar](garmin_daily_workouts_calendar_adder.md) | Parse workout screenshots to calendar |

### Creative
| Persona | Description |
|---------|-------------|
| [Vector Schematic Generator](vector-image-schematic-prompt_generator.md) | Monochromatic icon/vector prompts |

## IDE Support

The `setup-personas.sh` script handles:

```
Antigravity  → .agent/rules/*.md
Cursor       → .cursor/rules/*.md  
Copilot      → .github/copilot-instructions.md
```

## License

MIT. See [LICENSE](LICENSE).

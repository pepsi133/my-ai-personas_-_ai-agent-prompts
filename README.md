# Personal AI Prompts

A collection of personal prompt engineering templates for various LLMs (Gemini, Claude, GPT, etc.). These prompts were created using personal AI service subscriptions (Gemini Pro, Perplexity, and other commercial tools).

## About

This repository is primarily for personal use, but everyone is free to use, modify, or adapt these prompts for their own purposes. See the [LICENSE](LICENSE) file for details.

## Prompts

### Infrastructure & Cloud
- **[GCP CLI Command Generator](gcp_CLI_command_generator.md)** - Attempts to generate `gcloud` CLI commands with strict validation rules. Useful for common operations; always verify output against official docs.

- **[MikroTik Config Architect](mikrotik_config_architect.md)** - Structured prompt for RouterOS v7 configuration generation. Requires PDF documentation context; LLMs struggle with v6/v7 syntax differences without it.

- **[MikroTik Script and Config Architect](mikrotik_script_and_config_architect.md)** - Extends MikroTik prompts with Google Apps Script integration concepts. Complex workflows still require manual validation and testing.

### Development & Code
- **[Peer Reviewer](peer_reviewer.md)** - Academic peer review framework emphasizing citation-backed critique. Works best for conceptual/theoretical content; citation accuracy must be verified.

- **[Regex Architect](regex_architect.md)** - Regex generation with engine-specific syntax awareness. Good for straightforward patterns; complex lookaheads and performance optimization need testing.

### Productivity & Workflows
- **[Task Prioritiser for ADHD-ers](task_prioritiser_for_adhd-ers.md)** - Structured task breakdown using Pomodoro slots. Provides external framework for time-blind planning; effectiveness depends on honest user input.

- **[Garmin Daily Workouts Calendar Adder](garmin_daily_workouts_calendar_adder.md)** - Structured approach for parsing Garmin workout screenshots into calendar format. OCR quality and repeat block complexity affect accuracy.

### Windows & System Configuration
- **[Windows 11 Annoyances Fixer](windows_11_annoynances_fixer.md)** - Troubleshooting framework prioritizing native tools over third-party solutions. PowerToys version-specific; registry edits require careful review.

- **[PowerToys Context](powertoys_context.md)** - Reference document for PowerToys v0.96+ feature names and capabilities. Static snapshot; features and executables change between versions.

### Design & Creative
- **[Vector Image Schematic Prompt Generator](vector-image-schematic-prompt_generator.md)** - Template for monochromatic vector/icon prompts in image generators. Results vary significantly by AI model and require iteration.

### Meta
- **[Prompt Architect Agent](prompt_architect_agent.md)** - Meta-prompt for designing system instructions with architectural patterns. Useful framework; generated prompts still need real-world testing and refinement.

## License

This work is licensed under the MIT License. See [LICENSE](LICENSE) for full terms. These prompts are provided as-is with no warranties or liability.

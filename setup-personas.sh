#!/usr/bin/env bash
#
# setup-personas.sh
# Copies AI persona files to IDE-specific directories with proper formatting
#
# Supports: Antigravity, Cursor, GitHub Copilot (VS Code/JetBrains)
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# IDE configuration: directory paths relative to target project
declare -A IDE_DIRS=(
    ["antigravity"]=".agent/rules"
    ["cursor"]=".cursor/rules"
    ["copilot-vscode"]=".github"
    ["copilot-jetbrains"]="$HOME/.config/github-copilot/intellij"
)

# File patterns for Copilot (single file vs directory of files)
declare -A IDE_PATTERNS=(
    ["antigravity"]="multi"      # Multiple files in directory
    ["cursor"]="multi"           # Multiple .mdc files
    ["copilot-vscode"]="single"  # Single copilot-instructions.md
    ["copilot-jetbrains"]="single" # Single global-copilot-instructions.md
)

#------------------------------------------------------------------------------
# Helper functions
#------------------------------------------------------------------------------

log_info() { echo -e "${BLUE}[INFO]${NC} $1" >&2; }
log_ok() { echo -e "${GREEN}[OK]${NC} $1" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

#------------------------------------------------------------------------------
# Detect IDE based on environment and installed tools
#------------------------------------------------------------------------------

detect_ide() {
    local detected=""
    local confidence="low"
    
    # Check for Antigravity
    if [[ -n "${ANTIGRAVITY_HOME:-}" ]] || command -v agy &>/dev/null; then
        detected="antigravity"
        confidence="high"
    # Check for Cursor
    elif [[ -n "${CURSOR_TRACE:-}" ]] || [[ -d "$HOME/.cursor" ]]; then
        detected="cursor"
        confidence="medium"
    # Check for VS Code with Copilot
    elif command -v code &>/dev/null && [[ -d "$HOME/.vscode" ]]; then
        detected="copilot-vscode"
        confidence="medium"
    # Check for JetBrains IDEs
    elif [[ -d "$HOME/.config/JetBrains" ]] || command -v idea &>/dev/null; then
        detected="copilot-jetbrains"
        confidence="medium"
    fi
    
    echo "$detected:$confidence"
}

#------------------------------------------------------------------------------
# Ask user to select IDE
#------------------------------------------------------------------------------

select_ide() {
    local detected_result
    detected_result=$(detect_ide)
    local detected_ide="${detected_result%%:*}"
    local confidence="${detected_result##*:}"
    
    if [[ "$confidence" == "high" && -n "$detected_ide" ]]; then
        log_info "Detected IDE: ${GREEN}${detected_ide}${NC}"
        read -rp "Use this IDE? [Y/n]: " confirm
        if [[ "${confirm,,}" != "n" ]]; then
            echo "$detected_ide"
            return
        fi
    elif [[ -n "$detected_ide" ]]; then
        log_info "Possibly detected: ${YELLOW}${detected_ide}${NC} (confidence: $confidence)"
    fi
    
    echo "" >&2
    echo "Select your IDE:" >&2
    echo "  1) Antigravity IDE" >&2
    echo "  2) Cursor" >&2
    echo "  3) VS Code with GitHub Copilot" >&2
    echo "  4) JetBrains IDE with GitHub Copilot" >&2
    echo "" >&2
    read -rp "Enter number [1-4]: " choice
    
    case "$choice" in
        1) echo "antigravity" ;;
        2) echo "cursor" ;;
        3) echo "copilot-vscode" ;;
        4) echo "copilot-jetbrains" ;;
        *) log_error "Invalid choice"; exit 1 ;;
    esac
}

#------------------------------------------------------------------------------
# Get list of available personas
#------------------------------------------------------------------------------

get_personas() {
    find "$SCRIPT_DIR" -maxdepth 1 -name "*.md" -type f \
        ! -name "README.md" \
        ! -name "LICENSE*" \
        -printf "%f\n" | sort
}

#------------------------------------------------------------------------------
# Check and report existing persona files
#------------------------------------------------------------------------------

check_existing_files() {
    local target_dir="$1"
    local existing_files=()
    
    if [[ ! -d "$target_dir" ]]; then
        return
    fi
    
    shopt -s nullglob
    for file in "$target_dir"/*.md "$target_dir"/*.mdc; do
        if [[ -f "$file" ]]; then
            local filename
            filename=$(basename "$file")
            existing_files+=("$filename")
        fi
    done
    shopt -u nullglob
    
    if [[ ${#existing_files[@]} -gt 0 ]]; then
        echo "" >&2
        log_info "Existing persona files in target directory:"
        for f in "${existing_files[@]}"; do
            echo "  ${GREEN}✓${NC} $f" >&2
        done
        echo "" >&2
        echo "These will be overwritten if you select the same personas." >&2
        echo "Press Ctrl+C to cancel, or continue to proceed." >&2
        read -rp "Press Enter to continue..."
    fi
}

#------------------------------------------------------------------------------
# Select personas interactively
#------------------------------------------------------------------------------

select_personas() {
    local -a personas
    mapfile -t personas < <(get_personas)
    
    if [[ ${#personas[@]} -eq 0 ]]; then
        log_error "No persona files found in $SCRIPT_DIR"
        exit 1
    fi
    
    echo "" >&2
    echo "Available personas:" >&2
    echo "-------------------" >&2
    local i=1
    for persona in "${personas[@]}"; do
        local name="${persona%.md}"
        echo "  $i) $name" >&2
        ((i++))
    done
    echo "" >&2
    echo "Enter comma-separated numbers (e.g., 1,3,5) or 'all' for all personas:" >&2
    read -rp "> " selection
    
    local -a selected=()
    
    if [[ "${selection,,}" == "all" ]]; then
        selected=("${personas[@]}")
    else
        IFS=',' read -ra indices <<< "$selection"
        for idx in "${indices[@]}"; do
            idx=$(echo "$idx" | tr -d ' ')  # trim whitespace
            if [[ "$idx" =~ ^[0-9]+$ ]] && ((idx >= 1 && idx <= ${#personas[@]})); then
                selected+=("${personas[$((idx-1))]}")
            else
                log_warn "Skipping invalid selection: $idx"
            fi
        done
    fi
    
    printf '%s\n' "${selected[@]}"
}

#------------------------------------------------------------------------------
# Create persona files for selected personas
#------------------------------------------------------------------------------

create_persona_files() {
    local ide="$1"
    local target_dir="$2"
    shift 2
    local -a personas=("$@")
    
    local pattern="${IDE_PATTERNS[$ide]}"
    local created=0
    
    # Create target directory if needed
    mkdir -p "$target_dir"
    
    if [[ "$pattern" == "single" ]]; then
        # For Copilot: only one instructions file allowed
        if [[ ${#personas[@]} -gt 1 ]]; then
            log_warn "This IDE only supports a single instructions file."
            log_info "Using first selected persona: ${personas[0]}"
        fi
        
        local source="$SCRIPT_DIR/${personas[0]}"
        local target
        
        if [[ "$ide" == "copilot-vscode" ]]; then
            target="$target_dir/copilot-instructions.md"
        else
            target="$target_dir/global-copilot-instructions.md"
        fi
        
        # Remove existing file if present
        [[ -f "$target" ]] && rm "$target"
        
        # Copy file content
        cat "$source" > "$target"
        log_ok "Copied: ${personas[0]} -> $(basename "$target")"
        created=1
    else
        # Multiple files supported
        for persona in "${personas[@]}"; do
            local source="$SCRIPT_DIR/$persona"
            local target="$target_dir/$persona"
            
            # Remove existing file if present
            [[ -f "$target" ]] && rm "$target"

            if [[ "$ide" == "antigravity" ]]; then
                # Antigravity needs YAML frontmatter to activate rules
                {
                    echo "---"
                    echo "description: ${persona%.md}"
                    echo "globs: [\"**/*\"]"
                    echo "alwaysApply: true"
                    echo "---"
                    echo ""
                    cat "$source"
                } > "$target"
                log_ok "Generated: $persona (with frontmatter)"
            else
                # Cursor and other IDEs: copy raw content
                cat "$source" > "$target"
                log_ok "Copied: $persona"
            fi
            
            : $((created++))
        done
    fi
    
    echo ""
    log_info "Created $created persona file(s) in $target_dir"
}



#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           AI Personas Setup Script                          ║"
    echo "║   Links persona files to your IDE's rules directory         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    
    # Step 1: Detect/select IDE
    local ide
    ide=$(select_ide)
    log_info "Selected IDE: ${GREEN}${ide}${NC}"
    
    # Step 2: Determine target directory
    local target_dir
    if [[ "$ide" == "copilot-jetbrains" ]]; then
        target_dir="${IDE_DIRS[$ide]}"
    else
        # For project-local IDEs, ask where the target project is
        read -rp "Target project directory [current: $(pwd)]: " project_dir
        project_dir="${project_dir:-$(pwd)}"
        target_dir="$project_dir/${IDE_DIRS[$ide]}"
    fi
    
    log_info "Target directory: $target_dir"
    
    # Step 3: Check existing files
    check_existing_files "$target_dir"
    
    # Step 4: Select personas
    local -a selected_personas
    mapfile -t selected_personas < <(select_personas)
    
    if [[ ${#selected_personas[@]} -eq 0 ]]; then
        log_error "No personas selected"
        exit 1
    fi
    
    # Step 5: Create persona files
    create_persona_files "$ide" "$target_dir" "${selected_personas[@]}"
    

    
    echo ""
    log_ok "Setup complete!"
    echo ""
}

main "$@"

#!/bin/bash
set -e

SKILLS_DIR="${HOME}/.claude/skills/hew"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  ⚒  Hew — Installer"
echo "  ─────────────────────"
echo ""

# Create skills directory if needed
mkdir -p "${SKILLS_DIR}"

# Copy SKILL.md
cp "${SCRIPT_DIR}/SKILL.md" "${SKILLS_DIR}/SKILL.md"
echo "  ✓ SKILL.md → ${SKILLS_DIR}/"

# Make this script findable
chmod +x "${SCRIPT_DIR}/install.sh"

echo ""
echo "  Hew is installed. Activate with:"
echo "    /hew questions \"your goal\""
echo "    /hew full"
echo "    /hew build"
echo ""
echo "  Quick install from anywhere:"
echo "    git clone https://github.com/jecruz/hew.git /tmp/hew && bash /tmp/hew/install.sh"
echo ""

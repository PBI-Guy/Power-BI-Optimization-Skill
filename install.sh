#!/bin/bash
#
# Install Power BI Optimization Skill for GitHub Copilot
#
# Usage:
#   ./install.sh              # Install to user scope
#   ./install.sh workspace    # Install to workspace
#   ./install.sh /custom/path # Install to custom path

set -e

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Banner
echo ""
echo -e "${CYAN}=====================================${NC}"
echo -e "${CYAN} Power BI Optimization Skill Installer${NC}"
echo -e "${CYAN}=====================================${NC}"
echo ""

# Determine installation path
SCOPE="${1:-user}"
if [[ "$SCOPE" == "user" ]]; then
    INSTALL_PATH="$HOME/.github/skills/powerbi-optimization"
    echo -e "${GREEN}Installing to user scope: $INSTALL_PATH${NC}"
elif [[ "$SCOPE" == "workspace" ]]; then
    INSTALL_PATH=".github/skills/powerbi-optimization"
    echo -e "${GREEN}Installing to workspace: $INSTALL_PATH${NC}"
else
    INSTALL_PATH="$SCOPE/powerbi-optimization"
    echo -e "${YELLOW}Installing to custom path: $INSTALL_PATH${NC}"
fi

# Create directory if it doesn't exist
if [ ! -d "$INSTALL_PATH" ]; then
    echo -e "${YELLOW}Creating directory...${NC}"
    mkdir -p "$INSTALL_PATH"
fi

# Copy skill files
echo -e "${YELLOW}Copying skill files...${NC}"
cp -r .github/skills/powerbi-optimization/* "$INSTALL_PATH/"

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${CYAN}Installed skills:${NC}"
echo -e "${WHITE}  - @powerbi-optimization (Hub skill)${NC}"
echo -e "${WHITE}  - @dax-mastery (Specialist)${NC}"
echo -e "${WHITE}  - @model-design (Specialist)${NC}"
echo -e "${WHITE}  - @report-performance (Specialist)${NC}"
echo -e "${WHITE}  - @powerquery-m (Specialist)${NC}"
echo -e "${WHITE}  - @security-rls (Specialist)${NC}"
echo ""
echo -e "${CYAN}Usage in GitHub Copilot:${NC}"
echo -e "${WHITE}  @powerbi-optimization optimize my report${NC}"
echo -e "${WHITE}  @dax-mastery check this measure${NC}"
echo -e "${WHITE}  @model-design analyze unused objects${NC}"
echo ""
echo -e "${CYAN}Documentation:${NC}"
echo -e "${WHITE}  https://github.com/PBI-Guy/Power-BI-Optimization-Skill${NC}"
echo ""

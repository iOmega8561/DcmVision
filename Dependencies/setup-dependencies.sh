# POSSIBLE VALUES:
# 1) "xros"        for Apple Vision Pro
# 2) "xrsimulator" for visionOS Simulator
TARGET=xrsimulator

############################################################
#                                                          #
#                  DO NOT EDIT BELOW                       #
#        Any changes beyond this point may break           #
#                 the functionality!                       #
#                                                          #
############################################################
############################################################
############################################################

# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`

# Define colors for better visibility
YELLOW='\e[1;33m'
GREEN='\e[1;32m'
CYAN='\e[1;36m'
WHITE='\e[1;37m'
RED='\e[1;31m'
BOLD='\e[1m'
RESET='\e[0m'

set -e

# Setting up the environment
export SCRIPTPATH
export SDKROOT=$(xcrun --sdk $TARGET --show-sdk-path)
export PARALLEL=$(sysctl -n hw.logicalcpu)

# Entering the build location
cd $SCRIPTPATH

############################################################
############################################################
############################################################
#                                                          #
#                  DO NOT EDIT BELOW                       #
#        Build tools and Homebrew dependencies             #
#                                                          #
############################################################

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ $1 is not installed."
        return 1
    else
        echo "✅ $1 is installed."
        return 0
    fi
}

echo "🔍 Checking dependencies..."

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
    exit 1
else
    echo "✅ Homebrew is installed."
fi

# List of dependencies
dependencies=(cmake ninja meson wget automake autoconf autoconf-archive)

# Check each dependency
missing_packages=()
for dep in "${dependencies[@]}"; do
    if ! brew list --formula | grep -q "^${dep}$"; then
        echo "❌ $dep is not installed."
        missing_packages+=("$dep")
    else
        echo "✅ $dep is installed."
    fi
done

# Install missing dependencies if any
if [[ ${#missing_packages[@]} -gt 0 ]]; then
    echo "⚠️  Installing missing dependencies: ${missing_packages[*]}"
    brew install "${missing_packages[@]}"
else
    echo "🎉 All dependencies are installed!"
fi

############################################################
#                                                          #
#                    DO NOT EDIT BELOW                     #
#               DcmVision dependency setup                 #
#                                                          #
############################################################

echo "🔍 Starting dependency setup..."

# Ensure scripts are executable
chmod +x ./.scripts/*.sh

# List of dependencies (script suffixes and folder names)
dependencies=(libpng openssl zlib dcmtk vtk-compiletools vtk)

# Function to run setup scripts
run_setup() {

    local dep="$1"
    local script="./.scripts/setup-${dep}.sh"
    local folder="./${dep}"
    
    printf "${CYAN}📦 ==> Checking ${dep} setup...${RESET}\n"

    # Check if the folder already exists (meaning it's installed)
    if [[ -d "$folder" ]]; then
        printf "${YELLOW}⚠️  Skipping ${dep} setup: Folder '${folder}' already exists.${RESET}\n"
    else
    
        # If folder doesn't exist, proceed with setup
        if [[ -f "$script" ]]; then
            printf "${CYAN}🔧 Preparing ${dep}...${RESET}\n"
            source "$script" > /dev/null && \
            printf "${GREEN}✅ ${dep} setup complete!${RESET}\n" || \
            printf "${RED}❌ ${dep} setup failed!${RESET}\n"
        else
            printf "${RED}⚠️  Setup script for ${dep} not found! Skipping...${RESET}\n"
        fi
    fi

    printf "${YELLOW}------------------------------------${RESET}\n\n"
}

# Start setup process
printf "${YELLOW}============================${RESET}\n"
printf "${BOLD}${GREEN}🔍 STARTING DEPENDENCY SETUP...${RESET}\n"
printf "${YELLOW}============================${RESET}\n\n"

# Loop through dependencies and execute setup
for dep in "${dependencies[@]}"; do
    run_setup "$dep"
done

# Post-check: Ensure all dependency folders exist
printf "${YELLOW}============================${RESET}\n"
printf "${BOLD}${CYAN}🔍 VERIFYING DEPENDENCIES...${RESET}\n"
printf "${YELLOW}============================${RESET}\n\n"

missing_deps=()

for dep in "${dependencies[@]}"; do

    if [[ -d "./${dep}" ]]; then
        printf "${GREEN}✅ ${dep} is correctly installed.${RESET}\n"
    else
        printf "${RED}❌ ${dep} is missing!${RESET}\n"
        missing_deps+=("$dep")
    fi
done

# Final status
if [[ ${#missing_deps[@]} -eq 0 ]]; then
    printf "\n${BOLD}${GREEN}🎉 ALL DEPENDENCIES HAVE BEEN SUCCESSFULLY INSTALLED!${RESET}\n\n"
    
else
    printf "\n${BOLD}${RED}❌ WARNING: The following dependencies are missing:${RESET}\n"
    
    for dep in "${missing_deps[@]}"; do
        printf "${RED}- $dep${RESET}\n"
    done
    
    printf "\n${BOLD}${YELLOW}⚠️  Please check the setup logs above.${RESET}\n\n"
fi

printf "${YELLOW}============================${RESET}\n\n"

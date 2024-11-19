# Install dependencies
if ! command -v brew &> /dev/null
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v gh &> /dev/null
then
    brew install gh
fi

if ! command -v jq &> /dev/null
then
    brew install jq
fi

if ! command -v yq &> /dev/null
then
    brew install yq
fi

# Make executable
chmod +x *.sh

# Create a GitHub token if not already authenticated
if [ -z "$(gh auth status)" ]; then
    echo "Please authenticate with GitHub"
    gh auth login
fi



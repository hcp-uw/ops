#!/bin/bash

# Function to convert string to slug format
slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Please authenticate with GitHub first using 'gh auth login'"
    exit 1
fi

# Get organization name
read -p "Enter your GitHub organization name: " org_name

# Get team name
read -p "Enter team name: " team_name
team_slug=$(slugify "$team_name")

# Get GitHub usernames (comma-separated)
read -p "Enter GitHub usernames (comma-separated): " github_users
IFS=',' read -ra github_array <<< "$github_users"

# Get template repository (optional)
read -p "Enter template repository name (press Enter to skip): " template_repo

# Create team
echo "Creating team: $team_slug"
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/orgs/$org_name/teams" \
  -f name="$team_name" \
  -f permission="push" \
  -f privacy="closed"

# Create repository
echo "Creating repository: $team_slug"
if [ -n "$template_repo" ]; then
    gh repo create "$org_name/$team_slug" \
        --private \
        --team "$team_slug" \
        --template "$template_repo"
else
    gh repo create "$org_name/$team_slug" \
        --private \
        --team "$team_slug"
fi

# Add team members
for username in "${github_array[@]}"; do
    username=$(echo "$username" | tr -d ' ')
    echo "Adding $username to team $team_slug"
    gh api \
        --method PUT \
        -H "Accept: application/vnd.github+json" \
        "/orgs/$org_name/teams/$team_slug/memberships/$username" \
        -f role="member"
done

# Set team permissions for repository
echo "Setting team permissions for repository"
gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    "/orgs/$org_name/teams/$team_slug/repos/$org_name/$team_slug" \
    -f permission="push"

echo "Setup completed successfully!"
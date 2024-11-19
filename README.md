## Setup

```sh
# Install dependencies
brew install gh
brew install jq

# Make executable
chmod +x *.sh

# Create a GitHub token
gh auth login
```

or just run setup.sh

```sh
chmod +x setup.sh
./setup.sh
```


## Usage

```sh
# create a repo for a team (interactive)
./create-team-repo.sh
```

```sh
# elevate perms (required for mass delete)
gh auth refresh -h github.com -s delete_repo
```

```sh

# mass delete repos from an org (useful after testing)
./bulk-delete-repos.sh <org> <repo regex>
```

```sh

# mass delete teams from an org (useful after testing)
./bulk-delete-teams.sh <org> <team regex>
```


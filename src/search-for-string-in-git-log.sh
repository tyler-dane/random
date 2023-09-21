#!/bin/bash

# Store the current branch to revert back later
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Fetch all branches from remote
git fetch origin

# Check out each commit and grep for each line in credentials.txt
while IFS= read -r line; do
    echo "Searching for: $line"
    # git rev-list will list all the commit hashes. We use xargs to feed each hash to git grep.
    git rev-list --all | xargs git grep -F -n "$line"
done < credentials.txt

# Return to the original branch
git checkout "$current_branch"

#!/bin/bash

echo "Looking for secrets in credentials.txt use git log -S ..."

while IFS= read -r secret; do
  echo "🧐 Searching for secret: $secret"

  # Loop through commits and check for matches using git log -S
  git log -S "$secret" --oneline --name-only --pretty=format:"%h %s" | while read -r line; do
    commit_hash=$(echo "$line" | awk '{print $1}')
    commit_message=$(echo "$line" | cut -d' ' -f2-)

    # Print commit information and affected files
    echo "Commit: $commit_hash - $commit_message"
    git show --stat --name-only "$commit_hash"
    echo "----------------------------------------------------"
  done

done < credentials.txt

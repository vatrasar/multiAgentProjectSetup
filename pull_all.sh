#!/bin/bash

# The script iterates through the directory structure to find git repositories
# and executes 'git pull' inside them.

find . -maxdepth 3 -name ".git" -type d | while read gitdir; do
    repo_dir=$(dirname "$gitdir")
    
    # Skip the current directory if it happens to be a git repository itself
    if [ "$repo_dir" = "." ]; then
        continue
    fi
    
    echo ">>> Updating: $repo_dir"
    
    # Enter the directory and pull
    (cd "$repo_dir" && git pull)
    
    echo "----------------------------------------"
done

#!/bin/bash

# The script iterates through each subdirectory in the current directory
# and executes 'git pull' inside it.

for dir in */; do
    # Remove the trailing slash for cleaner display
    dir_name="${dir%/}"
    
    if [ -d "$dir" ]; then
        echo ">>> Updating: $dir_name"
        
        # Enter the subdirectory
        cd "$dir" || continue
        
        # Check if it is a git repository
        if [ -d ".git" ]; then
            git pull
        else
            echo "Skipped: $dir_name (no .git folder)"
        fi
        
        # Return to the parent directory
        cd ..
        echo "----------------------------------------"
    fi
done

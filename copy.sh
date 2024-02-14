#!/bin/bash

deploy_dir="/root/Docker/deploy"
volume_dir="/root/Docker/volume"
git_repo="https://gpt2963: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@github.com/gpt2963/deploy.git"

# Change directory to deploy_dir
cd "$deploy_dir" || exit

# Check if ROOT.war exists in deploy_dir or in the git repository
if [ -f "ROOT.war" ]; then
    # Remove ROOT.war from deploy_dir
    rm "ROOT.war"
fi

# Remove ROOT.war from the Git repository if it exists
if git rev-parse --verify HEAD >/dev/null 2>&1; then
    git rm --cached ROOT.war
    git commit -m "Remove ROOT.war"
fi

# Move new ROOT.war from volume_dir to deploy_dir
cp "$volume_dir/ROOT.war" "$deploy_dir/ROOT.war"

# Add new ROOT.war to Git staging area
git add ROOT.war

# Commit changes with a message
git commit -m "Updated ROOT.war"

# Push changes to the Git repository
git push "$git_repo" master


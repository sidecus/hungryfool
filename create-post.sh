#!/bin/bash
# Usage: ./newpost.sh "My New Blog Post"

if [ $# -eq 0 ]; then
  echo "Usage: $0 \"Post Title\""
  exit 1
fi

# Join all arguments into one title string
title="$*"

# Convert title to lowercase and replace spaces with hyphens
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

# Create new post using Hugo
hugo new "posts/${slug}.md"

# Print friendly info
echo "✅ Created new post:"
echo "   posts/${slug}.md"
echo "   Title: $title"
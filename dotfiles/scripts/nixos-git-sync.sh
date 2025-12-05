#!/usr/bin/env zsh
set -e

doas zsh <<'ROOT'
cd /etc/nixos
git config --system --add safe.directory /etc/nixos

echo "🔍 Checking Git status..."
branch=$(git rev-parse --abbrev-ref HEAD)
echo "📦 Current branch: $branch"

changes=$(git status --porcelain)
if [[ -z $changes ]]; then
  echo "✅ No changes to commit."
else
  echo "📝 Staging all changes..."
  git add -A
  timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  git commit -m "Auto-commit: $timestamp"
  git push origin "$branch"
fi

echo "\n📋 Final repo status:"
git status

echo "\n📈 Recent commits:"
git --no-pager log --oneline -n 5
ROOT


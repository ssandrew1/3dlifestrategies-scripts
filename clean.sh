# 1. Delete the GitHub branch (if allowed)
git push origin --delete main || true

# 2. Remove all local git history
rm -rf .git

# 3. Reinitialize a brand‑new repo
git init

# 4. Add all current clean files
git add .

# 5. Create a fresh initial commit
git commit -m "Clean initial commit after history reset"

# 6. Reconnect to GitHub
git remote add origin git@github.com:ssandrew1/3dlifestrategies-scripts.git

# 7. Push the clean repo as the new main branch
git push -u origin main --force


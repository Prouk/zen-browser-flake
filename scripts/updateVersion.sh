curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser-auto/www-temp/tags \
  | jq -r '.[0].name' > resp.json
  cat resp.json

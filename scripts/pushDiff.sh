VERSION_CONTENT=$(cat version.json | base64 -w 0)

VERSION_SHA=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/Prouk/zen-browser-flake/contents/version.json \
  | jq -r '.sha')

curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/Prouk/zen-browser-flake/contents/version.json \
  -d '{"message":"version.js update","branch":"main","sha":"'"$VERSION_SHA"'","committer":{"name":"Prouk (action)","email":"valentin.tahon2@gmail.com"},"content":"'"$VERSION_CONTENT"'"}'

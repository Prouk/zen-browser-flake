echo "Getting last tag from temp"
echo "[" > version.json
   
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser-auto/www-temp/tags \
  | jq -r '.[0]' > version.json 

echo "]" > version.json

VERSION_CONTENT= cat version.json | base64

curl -L \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/Prouk/zen-browser-flake/contents/version.json \
  -d '{"message":"version.js update","branch":"main","sha","committer":{"name":"Prouk (action)","email":"valentin.tahon2@gmail.com"},"content":'"${VERSION_CONTENT"'}}'

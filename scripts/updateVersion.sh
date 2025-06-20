curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser/desktop/tags \
  | jq -r '.[0,1] | {(if .name=="twilight" then "twilight" else "beta" end): .}' > version.json 

sed -i '12,13d' version.json
sed -i -e '11a,' version.json

BTNAME=$(wget "$(jq -r '.beta.zipball_url' version.json)")
TWNAME=$(wget "$(jq -r '.twilight.zipball_url' version.json)")

unzip $BTNAME
unzip $TWNAME

BTSHA=$(sudo sha256sum "$BTNAME" | sudo awk '{print $1}')
TWSHA=$(sudo sha256sum "$TWNAME" | sudo awk '{print $1}')

ls -la

jq '.beta += {tarball_sha: "'"$BTSHA"'"} | .twilight += {tarball_sha: "'"$TWSHA"'"}' version.json > version.tmp && mv version.tmp version.json

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

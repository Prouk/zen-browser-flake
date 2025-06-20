echo "Getting last tag from temp"
   
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser/desktop/tags \
  | jq -r '.[0,1] | {(if .name=="twilight" then "twilight" else "beta" end): .}' > version.json 

sed -i '12,13d' version.json
sed -i -e '11a,' version.json

curl -OL $(jq -r '.beta.tarball_url' version.json) > zen-beta.tar.gz
curl -OL $(jq -r '.twilight.tarball_url' version.json) > zen-twilight.tar.gz

apt install shasum

BTSHA= $(shasum -a 256 zen-beta.tar.gz | awk '{print $1}')
TWSHA= $(shasum -a 256 zen-beta.tar.gz | awk '{print $1}')

echo "${BTSHA}"

jq '.beta += {tarball_sha: "'"$BTSHA"'"} | .twilight += {tarball_sha: "'"$TWSHA"'"}' version.json > version.json

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

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser/desktop/tags \
  | jq -r '.[0,1] | {(if .name=="twilight" then "twilight" else "beta" end): .}' > version.json 

sed -i '12,13d' version.json
sed -i -e '11a,' version.json

$(wget "$(jq -r '.beta.tarball_url' version.json)")
$(wget "$(jq -r '.twilight.tarball_url' version.json)")

mkdir beta_dir
mkdir twilight_dir

tar -xzf $(jq -r '.beta.name' version.json) -C beta_dir
tar -xzf twilight -C twilight_dir

# BTNAME=$(jq -r '.beta.name' version.json)
# TWNAME=$(jq -r '.twilight.name' version.json)

# BTSHA=$(sudo sha256sum "$BTNAME" | sudo awk '{print $1}')
# TWSHA=$(sudo sha256sum "$TWNAME" | sudo awk '{print $1}')

BTSHA=$(find twilight_dir -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum)
TWSHA=$(find beta_dir -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum)

echo $BTSHA

jq '.beta += {tarball_sha: "'"${BTSHA::-3}"'"} | .twilight += {tarball_sha: "'"${TWSHA::-3}"'"}' version.json > version.tmp && mv version.tmp version.json

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

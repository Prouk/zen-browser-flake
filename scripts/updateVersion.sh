curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser/desktop/tags \
  | jq -r '.[0,1] | {(if .name=="twilight" then "twilight" else "beta" end): .}' > version.json 

sed -i '12,13d' version.json
sed -i -e '11a,' version.json

BTSHA=$(nix-hash --type sha256 --base32 --flat <(curl -o - $(jq -r '.beta.zipball_url' version.json)))
TWSHA=$(nix-hash --type sha256 --base32 --flat <(curl -o - $(jq -r '.twilight.zipball_url' version.json)))

jq '.beta += {zipball_sha: "'"$BTSHA"'"} | .twilight += {zipball_sha: "'"$TWSHA"'"}' version.json > version.tmp && mv version.tmp version.json

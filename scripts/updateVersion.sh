curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/zen-browser/desktop/tags \
  | jq -r '.[0,1] | {(if .name=="twilight" then "twilight" else "beta" end): .}' > version.json 

sed -i '12,13d' version.json
sed -i -e '11a,' version.json

BTSHA=$(nix-hash --type sha256 --base32 --flat <(curl -o - https://github.com/zen-browser/desktop/releases/download/latest/zen.linux-x86_64.tar.xz)
TWSHA=$(nix-hash --type sha256 --base32 --flat <(curl -o - https://github.com/zen-browser/desktop/releases/download/twilight/zen.linux-x86_64.tar.xz)

jq '.beta += {tarball_sha: "'"$BTSHA"'"} | .twilight += {tarball_sha: "'"$TWSHA"'"}' version.json > version.tmp && mv version.tmp version.json

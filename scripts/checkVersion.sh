declare -a VERSION=("twilight")
SOURCES=""
VERSIONSHA=""

GetLatestRelease() {
  echo "Getting latest release tag name"
  BETAVER=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/zen-browser/desktop/releases/latest \
    | jq -r '.tag_name')

  echo "latest release is : $BETAVER"

  VERSION+=("$BETAVER")
}

GetReleaseByTag() {
  echo "Getting release infos for $1"
  SOURCES+=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/zen-browser/desktop/releases/tags/"$1" \
    | jq -r '.tag_name as $tag_name | .assets[] | select(.name == "zen.linux-x86_64.tar.xz") | {'"$2"':{$tag_name, browser_download_url, digest}}')
}

GetVersionSHA() {
  VERSIONSHA=$(curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/Prouk/zen-browser-flake/contents/version.json \
    | jq -r '.sha')
}

PushVersionChanges() {
  B64=$(cat version.json | base64 -w 0)
  curl -s -L \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/Prouk/zen-browser-flake/contents/version.json \
    -d '{"message":"version.json update (automated)","committer":{"name":"Prouk (automated)","email":"valentin.tahon2@gmail.com"},"content":"'"$B64"'","sha":"'"$VERSIONSHA"'"}'
}

 main() {
  GetLatestRelease
  for i in "${!VERSION[@]}"
  do
    if [ "$i" -eq 0 ]
    then
      GetReleaseByTag "${VERSION[$i]}" "twilight"
    else
      GetReleaseByTag "${VERSION[$i]}" "beta"
    fi
  done
  JSON=$(sed '7s/.*/,/' <<<"$SOURCES")

  echo "Writing to version.json file"
  echo "$JSON" > version.json
  GetVersionSHA
  PushVersionChanges
}

 main

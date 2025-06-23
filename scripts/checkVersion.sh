declare -a VERSION=("twilight")
SOURCES=""


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
    | jq -r '.tag_name as $tag_name | .assets[] | select(.name == "zen.linux-x86_64.tar.xz") | {'"$2"':{$tag_name, url, digest}}')
}

 main() {
  
  GetLatestRelease
  for i in "${!VERSION[@]}"
  do
    if ["$i" -eq "0"]
    then
      GetReleaseByTag "${VERSION[$i]}" "twilight"
      SOURCES+=","
    else
      GetReleaseByTag "${VERSION[$i]}" "beta"
    fi
  done
  echo source
}

 main

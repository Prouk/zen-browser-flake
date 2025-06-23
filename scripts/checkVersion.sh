NEEDUPDATE=false
declare -a VERSION=("twilight")


GetLatestRelease() {
  echo "Getting latest release tag name"
  BETAVER=$(curl -L \
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
  ehco $(curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/zen-browser/desktop/releases/tags/"$1")
}


 main() {
  GetLatestRelease
  for V in "${VERSION[@]}"
  do
    GetReleaseByTag $V
  done
}

 main

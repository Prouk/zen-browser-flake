echo $GH_TOKEN
curl --request GET \
--url "https://api.github.com/octocat" \
--header "Authorization: Bearer $GH_TOKEN" \
--header "X-GitHub-Api-Version: 2022-11-28"

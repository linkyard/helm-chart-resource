#!/bin/bash
set -e

init_helm() {
  helm init --client-only > /dev/null
  helm version --client
}

setup_repos() {
  repos=$(jq -c '(try .source.repos[] catch [][])' < $1)
  tiller_namespace=$(jq -r '.source.tiller_namespace // "kube-system"' < $1)

  local IFS=$'\n'
  for r in $repos; do
    name=$(echo $r | jq -r '.name')
    url=$(echo $r | jq -r '.url')
    username=$(echo $r | jq -r '.username // ""')
    password=$(echo $r | jq -r '.password // ""')

    echo Installing helm repository $name $url
    if [[ -n "$username" && -n "$password" ]]; then
      helm repo add $name $url --username $username --password $password
    else
      helm repo add $name $url
    fi
  done

  helm repo update
}

setup_helm() {
  echo "Initializing helm..."
  init_helm $1
  setup_repos $1
  echo "Helm setup successful."
}

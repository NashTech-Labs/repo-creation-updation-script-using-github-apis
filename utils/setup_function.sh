#!/bin/bash

#global vars
RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
UND='\033[4m'

url="https://api.github.com"

usage() {
  printf "
    ${GREEN}${UND}Available flags:${NC}\n
    ${YELLOW}-r|--repo-name${GREEN}  Add a repo by specifying repo name.
    ${YELLOW}-c|--create-repo${GREEN} It will create repo
    ${YELLOW}-o|--org${GREEN}  Create repo under organisation conflicting with username.
    ${YELLOW}-u|--username${GREEN} Create repo under private account conflicting with org.
    ${YELLOW}-a|--add-collaborator${GREEN} Add collaborator to the repo you should pass argument.
    ${YELLOW}-p|--permission${GREEN} Add collaborator permission (admin|user|read|maintain)
    ${YELLOW}-r|--remove-collaborator${GREEN} Remove a collaborator.
    ${YELLOW}-d|--delete-repo${GREEN} flag to delete repo
    ${YELLOW}-h|--help${GREEN} Help
  ${NC}\n" 1>&2
  exit 1
}


add_repo(){
  if [ -z $TOKEN ];
  then
    token_is_empty

  elif [ -n $repo ] && [ -n $user ] && [ -n $private ];
  then
    curl -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/user/repos" \
      --data '{ "name":"'"$repo"'", "private": true }'

  elif [ -n $repo ] && [ -n $user ];
  then
    curl -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/user/repos" \
      --data '{ "name":"'"$repo"'", "private": false }'  
  else
    printf "${RED} please enter valid argument. \n Valid arguments are"
    usage
  fi  
}

add_repo_org(){
  if [ -z $TOKEN ];
  then
    token_is_empty
  
  elif [ -n ${org} ] && [ -n ${repo} ] && [ -n $private ];
  then
    curl -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/orgs/$org/repos" \
      --data '{ "name":"'"$repo"'", "private": true }'

  elif [ -n ${org} ] && [ -n ${repo} ];
  then
    curl -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/orgs/$org/repos" \
      --data '{ "name":"'"$repo"'", "private": false }'
  else
    printf "${RED} please enter valid argument. \n Valid arguments are"
    usage
  fi  
}

add_collaborator(){
    if [ -z $TOKEN ];
    then
      token_is_empty
      
    elif [ -z ${name} ] && [ -z ${permission} ];
    then
      echo "Please enter collaborator username and permissions"
    elif [ -n $org ] && [ -n $repo ] && [ -n $name ] && [ -n $permission ] && [ -z $user ];
    then
      curl  -X PUT -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/repos/$org/$repo/collaborators/$name" --data '{ "permission":"'"$permission"'" }'
    elif [ -n $repo ] && [ -n $name ] && [ -n $permission ] && [ -n $user ] && [ -z $org ];
    then
      curl  -X PUT -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/repos/$user/$repo/collaborators/$name" --data '{ "permission":"'"$permission"'" }'
    else
      usage
    fi
}

remove_collaborator(){
    if [ -z $TOKEN ];
    then
      token_is_empty
      
    elif [ -z $name ] && [ -z $permission ];
    then
      echo "Please enter collaborator username and permissions"
    elif [ -n $user ] && [ -z $org ];
    then
      curl -X DELETE -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/repos/$user/$repo/collaborators/$name"
    elif [ -n $org ] && [ -z $user ];
    then
      curl -X DELETE -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/repos/$org/$repo/collaborators/$name"
    else
      usage
    fi
}

delete_repo(){
  if [ -z $TOKEN ];
  then
    token_is_empty
  elif [ -z $repo ] && [ -z $user ]
  then
    printf "${RED} Please enter repo name and username"
    usage
  elif [ -n $user ]
  then
  curl -X DELETE -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" \
    "$url/repos/$user/$repo"
  elif [ -n $org ]
  then
      curl -X DELETE -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" \
    "$url/repos/$org/$repo"
  fi
}

token_is_empty()
{
  printf "${RED} please export token\n export TOKEN=<value>"
}

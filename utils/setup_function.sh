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
    ${YELLOW}-c|--create-repo${GREEN} It will create repo.
    ${YELLOW}-o|--org${GREEN}  Create repo under organisation conflicting with username.
    ${YELLOW}-u|--username${GREEN} Create repo under private account conflicting with org flag.
    ${YELLOW}-n|--collaborator-name${GREEN} Add collaborator to the repo by passing name conflicting with teamname.
    ${YELLOW}-t|--teamname${GREEN} Add collaborator to the repo by passing name conflicting with collaborator name.
    ${YELLOW}-a|--add-collaborator${GREEN} Add collaborator
    ${YELLOW}-p|--permission${GREEN} Add collaborator permission (admin|user|read)
    ${YELLOW}-r|--remove-collaborator${GREEN} Remove a collaborator or team collaborator.
    ${YELLOW}-d|--delete-repo${GREEN} flag to delete repo.
    ${YELLOW}-h|--help${GREEN} Help
  ${NC}\n" 1>&2

  printf "${GREEN}${UND} Examples:${NC}\n"
  printf "${YELLOW} CHECK README.md\n"
  exit 1
}


add_repo(){
  if [ -z $TOKEN ];
  then
    token_is_empty

  elif [ -n $repo ] && [ -n $user ] && [ $private = "true" ];
  then
    curl -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/user/repos" -d '{ "name":"'"$repo"'", "private": true }'

  elif [ -n $repo ] && [ -n $user ];
  then
    curl -X POST -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/user/repos" -d '{ "name":"'"$repo"'"}'
  else
    printf "${RED} please enter valid argument. \n Valid arguments are"
    usage
  fi  
}

add_repo_org(){
  if [ -z $TOKEN ];
  then
    token_is_empty
  
  elif [ -n ${org} ] && [ -n ${repo} ] && [ $private = "true" ];
  then
    curl -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/orgs/$org/repos" -d '{ "name":"'"$repo"'", "private": true }'

  elif [ -n ${org} ] && [ -n ${repo} ];
  then
    curl -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/orgs/$org/repos" -d '{ "name":"'"$repo"'", "private": false}'
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
    elif [ -n $org ] && [ -z $teamname ] && [ -n $repo ] && [ -n $name ] && [ -n $permission ] && [ -z $user ];
    then
      curl  -X PUT -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/repos/$org/$repo/collaborators/$name" --data '{ "permission":"'"$permission"'" }'
    elif [ -n $repo ] && [ -z $teamname ] && [ -n $name ] && [ -n $permission ] && [ -n $user ] && [ -z $org ];
    then
      curl  -X PUT -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/repos/$user/$repo/collaborators/$name" --data '{ "permission":"'"$permission"'" }'
    else
      usage
    fi
}

add_team_collaborator(){
    if [ -z $TOKEN ];
    then
      token_is_empty
    elif [ -z ${teamname} ] || [ -z ${permission} ] || [ -z ${org} ];
    then
      echo "Please enter collaborator teamname, permissions or org"
    elif [ -n $repo ] && [ -n $teamname ] && [ -n $permission ] && [ -n $org ];
    then
      curl -X PUT -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/orgs/$org/teams/$teamname/repos/$org/$repo" --data '{ "permission":"'"$permission"'" }'
    else
      usage
    fi
}

remove_team_collaborator(){
    if [ -z $TOKEN ];
    then
      token_is_empty
    elif [ -z ${teamname} ] || [ -z ${org} ];
    then
      echo "Please enter collaborator teamname or org name"
    elif [ -n $repo ] && [ -n $teamname ] && [ -n $org ];
    then
      curl -X DELETE -H "Authorization: token $TOKEN" -H "Accept: application/vnd.github.v3+json" "$url/orgs/$org/teams/$teamname/repos/$org/$repo"
    else
      usage
    fi
}


remove_collaborator(){
    if [ -z $TOKEN ];
    then
      token_is_empty
      
    elif [ -z $name ];
    then
      echo "Please enter collaborator username"
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

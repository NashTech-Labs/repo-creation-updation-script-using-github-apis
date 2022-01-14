#!/bin/bash

set -e

source utils/setup_function.sh

main()
{
  if [ $# -eq 0 ]; then
      usage
  fi

  while [[ $# -gt 0 ]]; do
    option="$1"
    case ${option} in
    -c | --create-repo)
			if [ -n $user ] && [ -n $repo ] && [ -z $org ];
			then
				add_repo
			elif [ -n $org ] && [ -n $repo ] && [ -z $user ];
			then
				add_repo_org
			else
				usage
			fi
      shift
      ;;
		-r | --repo-name)
			export repo=$2
			shift 2
			;;
		-o | --org)
			export org=$2
			shift 2
			;;
		-u | --username)
			export user=$2
			shift 2
			;;
		-a | --add-collaborator)
			export name=$2
			add_collaborator
			shift 2
			;;
		-r | --remove-collaborator)
			export name=$2
			remove_collaborator
			shift 2
			;;
		-p |--permission)
			export permission=$2
			shift 2
			;;
		-d | --delete-repo)
			if [ -n $user ] && [ -n $repo ] && [ -z $org ];
			then
				delete_repo
			elif [ -n $org ] && [ -n $repo ] && [ -z $user ];
			then
				delete_repo
			else
				usage
			fi
			shift
			;;
		--private)
			export private="true"
			shift
			;;
		-h | --help)
			usage
			;;
		*)
      usage
      POSITIONAL+=("$1") # save it in an array for later
      shift              # past argument
      ;;
		esac
  done
}

main "$@"
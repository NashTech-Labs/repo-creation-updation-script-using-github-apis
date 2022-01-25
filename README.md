## Github Automation Using API

This project can utilize Github APIs to help you do following:

        1. Create Repo under personal repo and in an org repo
        2. Delete Repo under personal repo and in an org repo
        3. Add a single collaborator name
        4. Delete a single collaborator name
        5. Add a team as a collaborator using name
        6. Remove a team as a collaborator

## MORE

## Requirement

1. Create personal access token from github setting
2. export token as

    export TOKEN=<value>

#### For more info run 

        ./git.sh --help

## examples

1. Create a repo in your account

        ./git.sh --create-repo --repo-name test-repo-1 --user <user-name>

2. Delete a repo in your account

        ./git.sh --create-repo --repo-name test-repo-1 --user <user-name>

3. Create a repo in a organization

        ./git.sh --create-repo --repo-name test-repo-1 --org <org-name>

4. Add a collaborator

        ./git.sh --add-collaborator --collaborator-name <name> --repo-name test-repo-1 --user <user-name> --permission admin|read|write

5. Add a collaborator for org repo

        ./git.sh --add-collaborator --collaborator-name <name> --repo-name test-repo-1 --org <org-name> --permission admin|read|write

6. Remove a collaborator 

        ./git.sh --remove-collaborator --collaborator-name <name> --repo-name test-repo-1 --user|--org <user-name>|<org-name>

7. Add a team as a collaborator

        ./git.sh --add-collaborator --teamname <name> --repo-name test-repo-1 --org <org-name> --permission admin|read|write

8. Remove a team as a collaborator

        ./git.sh --remove-collaborator --teamname <name> --repo-name test-repo-1 --org <org-name>
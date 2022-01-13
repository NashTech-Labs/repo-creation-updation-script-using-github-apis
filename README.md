## Github Automation Using API

This project can utilize Github APIs to help you create new repos inside an org and also give admin rights to a particular person.

### How To Use?

1) Add your Github Personal Access Token in the `token` variable. (You can generate your Github Personal Access Token from [here.](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
2) Add your org game in the `org` variable.
3) Create a file at the same location as the script. You can call this file anything you want, we are calling it `repos.txt`. If you do change it though, update the same in the script. The file should have content in the following format:

```
<repo-name> <contributor-github-id>
<repo-name> <contributor-github-id>
<repo-name> <contributor-github-id>
...

```

### Troubleshooting

1) **Not all repos are being created, the ones at the end of file are getting skipped.**

The input file should have a blank line at the end.

# Google Landing Zone Terraform Modules

This repository contains information about the Terraform Modules to deploy the Google Landing Zone. The modules are **not** in this repository, but in respective `terraform-google-landing-zone-*` repositories.

## Design decisions

The modules are based on [Cloud Foundation Fabric Fast](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/tree/master/fast). We want to provide the modules in a configurable way to reuse them. The approach of division into successive stages is followed. However, instead of providing this in a repository, the individual stages are published as separate repositories and thus modules.  

The original repository is being worked on heavily. Therefore, the possibility to adopt changes into the new modules should be maintained. To allow that we decided to rewrite the history using `git-filter-repo` in an stable way so we can merge changes back to the repositories.

## Rewriting History

The following sections describe how to use [`git-filter-repo`](https://github.com/newren/git-filter-repo) to rewrite the git history. The idea is to have a stable rewrite of commits so subsequent commits can be merged into the new codebase. To achieve that we save the used path-rewrites inside the repository.

### Creating a new Repository

We decided to use the latest released version as a baseline. So you need to checkout the versions from the repository.

First you need to clone the desired version. You can specify a tag name as a branch name. As you only need information leading to the tag and not other branches you can use the `--single-branch` option. To clone version 19 use

```bash
git clone -b v19.0.0 --single-branch https://github.com/GoogleCloudPlatform/cloud-foundation-fabric.git
```

Afterwards you should create the file `git-filter-repo-paths.txt` containing the path rewrites in **another** folder, as git-filter repo expects a clean repository.

> Specify several path filtering and renaming directives, one per line. Lines with ==> in them specify path renames, and lines can begin with literal: (the default), glob:, or regex: to specify different matching styles. Blank lines and lines starting with a # are ignored (if you have a filename that you want to filter on that starts with literal:, #, glob:, or regex:, then prefix the line with literal:).

— [git-filter-repo manual](https://htmlpreview.github.io/?https://github.com/newren/git-filter-repo/blob/docs/html/git-filter-repo.html)

It is very important, that we include all commits for a stage to be able to merge subsequent changes. The first step is to rewrite the git history, so the stage's subfolder is the root of the new repository. This is done by specifying a `literal` path to include and a literal path to rewrite to root. So usually you want to include at least files required for licensing and the folder of the stage.

```
# Paths for the stage
fast/stages/00-bootstrap/
fast/stages/00-bootstrap/==>

# Files required for Licensing
LICENSE
NOTICE
```

Most likely the stage is using files from parent folders (eg. modules or assets). You want to avoid storing files in multiple repositories to avoid code duplication. The following snippet outputs which files/modules are referenced only by `tf`-files in the stage and which are also used by other stages. If something is used by other stages it should be split out into an separate repository. If something is used only by this stage it should be included in the new repository by adding the path of the module/file.

```powershell 
$stage = "00-bootstrap"
$PathToStages = ".\fast\stages\"
$moduleUsageTarget = @{}
$moduleUsageOthers = @{}

$stageDirectoryInfo = Join-Path -Path $PathToStages -ChildPath $stage | Get-Item

Get-ChildItem -LiteralPath $PathToStages -Filter "*.tf" -Recurse | Select-String -Pattern '(?<=").*\.\..*(?=")' | ForEach-Object {
    $terraformDirectory = $_.Path | Split-Path -Parent
    $modulePath = Join-Path -Path $terraformDirectory -ChildPath $_.Matches.Value -Resolve | Resolve-Path -Relative
    if ($terraformDirectory.StartsWith($stageDirectoryInfo.FullName)) {
        $moduleUsageTarget[$modulePath] += @($_)
    } else {
        $moduleUsageOthers[$modulePath] += @($_)
    }
}

$compared = Compare-Object -ReferenceObject ([string[]]$moduleUsageTarget.Keys) -DifferenceObject ([string[]]$moduleUsageOthers.Keys) -IncludeEqual -PassThru

Write-Warning "The following files/modules are used by the stage $stage and other stages"

$compared | Where-Object {$_.SideIndicator -eq "=="}

Write-Output "The following files/modules are used by the stage $stage only"

$compared | Where-Object {$_.SideIndicator -eq "<="}
```

To ensure a stable git history, it is important to prevent subsequent commits from being inserted before the last rewritten commit, as this will cause all subsequent commits to receive a new hash. So it is very important to check which folders to include. You can check movements of files with `git log --pretty=oneline --abbrev-commit --follow --stat <file>`. You should include the previous locations of the files the same way as above. Note intentionally not included folders in the `git-filter-repo-paths.txt` as comments.

Once you have compiled the paths you need, use `git-filter-repo` to rewrite the git history. Tags from the repo will be prefixed with `cff-` so it is clear which version was last used.

```bash
git filter-repo --paths-from-file <path>/git-filter-repo-paths.txt --tag-rename '':'cff-'
```

First step afterward is to copy the `git-filter-repo-paths.txt` to the repository. Afterwards add the `NOTICE` file. Use the [template](NOTICE.template). Commit these two files with meaningful message eg. 

```text
Split out as separate repository
from GoogleCloudPlatform's cloud-foundation-fabric v19
used git-filter-repo
```

Now create a main branch out of the detached HEAD state and switch to a branch that you can later merge with an proper Pull-Request.

```bash
git remote remove origin
git checkout -b main
git checkout -b fix/separation
```


Commit the [`.gitignore` for terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore) `add default .gitignore for terraform`.

Afterwards you need to fix that module. First thing you definitely need to fix are references to files outside the module. Easiest start is to search for files containing `..`. Also have a look for symlinks (eg. `templates`). You may need to go back and redo the process if you notice you missed files. 

**You must add a prominent notice to every file you change!** Any file should already contain an Boilerplate header. If not you can copy it from `LICENSE`. Add the appropriate Notice above the existing information `Copyright 2023 q.beyond AG`. When changing other files without a Copyright notice, please add it and add the q.beyond claim accorsingly.

When you finished fixing all references to other directoy, test the module thourougly. 

When everything is working as expected copy the files `.terraform-docs.yml` and `.github/workflows/docs.yaml` from the [terraform-module-template](https://github.com/qbeyond/terraform-module-template). Run the auto docu once to check the repository. Afterwards read to the `README.md` and change where needed. At least add a reference `This stage is part of the [google landing zone modules](https://github.com/qbeyond/terraform-google-landing-zone).`

When you got everything working, it's time to publish it to github.

```
git remote add origin <url>
git push origin main:main
```

Now add the needed branch protection for main. Afterwards push the changes `git push origin fix/separation:fix/separation` and create a PullRequest.

- Think about Testing of module

### Running git-filter-repo

`git-filter-repo` is not included in default git installation. See [Installation instructions](https://github.com/newren/git-filter-repo/blob/main/INSTALL.md) how to install it. Note that windows ships with an *stub* for `python.exe` and `python3.exe` so even when you installed python by other means then the *msstore* you may get weird behavior. Try to disable the *app execution aliases* in *Windows settings*.
<!-- BEGIN_TF_DOCS -->
## Usage

Basic Example
```hcl
resource "random_id" "testprefix" {
  byte_length = 5
}

module "gcs-provider" {
  source          = "../.."
  bucket_name     = "test${random_id.testprefix.hex}"
  service_account = var.service_account
}

variable "bucket_name" {
  description = "Bucket Name"
  type        = string
}

variable "service_account" {
  description = "service Account to create storage bucket with"
}
```

## Requirements

No requirements.

## Inputs

No inputs.
## Outputs

No outputs.
## Resource types

No resources.


## Modules

No modules.
## Resources by Files

No resources.

<!-- END_TF_DOCS -->
# Remove sensitive info from repo using [BGF](https://rtyley.github.io/bfg-repo-cleaner/)

- [Remove sensitive info from repo using BGF](#remove-sensitive-info-from-repo-using-bgf)
  - [Did you mess up?](#did-you-mess-up)
  - [How to clean current code (HEAD)](#how-to-clean-current-code-head)
    - [Save link to commits (optional)](#save-link-to-commits-optional)
    - [Clean up your code on the `main` branch](#clean-up-your-code-on-the-main-branch)
  - [How to remove sensitive info from repo using BFG](#how-to-remove-sensitive-info-from-repo-using-bfg)
    - [Download BFG](#download-bfg)
    - [Make copy of the repo you want to clean\*](#make-copy-of-the-repo-you-want-to-clean)
    - [Create `credentials.txt`](#create-credentialstxt)
    - [Run BFG command to replace sensitive text](#run-bfg-command-to-replace-sensitive-text)
    - [Check command output and output files to verify](#check-command-output-and-output-files-to-verify)
    - [Review if changes worked](#review-if-changes-worked)
    - [Clone a fresh copy of your repo](#clone-a-fresh-copy-of-your-repo)
    - [Continue working from your fresh copy](#continue-working-from-your-fresh-copy)
  - [Troubleshooting](#troubleshooting)
    - [Error: `deny updating a hidden ref`](#error-deny-updating-a-hidden-ref)
  - [Appendix](#appendix)
    - [Remove large files](#remove-large-files)
    - [References](#references)
    - [Output from replace text command](#output-from-replace-text-command)

## Did you mess up?

You’ve probably committed sensitive information that you don’t want others to see (e.g. passwords, API secrets, emails).

Not sure? Try running these commands from the root of your project, replacing `YOUR_SECRET` with any sensitive text you’re aware of.

```bash
# Search your git history to see where you
# messed up.

# If either of these give you output,
# you've got a problem.

git grep "YOUR_SECRET" $(git rev-list --all)

git log -S "YOUR_SECRET" --oneline --name-only --pretty=format:"%h %s"
```

The easiest way to fix this is remove any secrets from your HEAD and create a new repo. The downside of this approach is that you lose all your commit history, which makes your code harder to understand.

If you’re willing to do some extra work to preserve your commit history, use the [BFG Repo Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) tool to remove troublesome blobs or large files.

## How to clean current code (HEAD)

### Save link to commits (optional)

- Using the output from your search commands, find the commit hashes that include your sensitive info.
- View the files on GitHub and bookmark the URLs. This will make it easier to confirm it worked later

### Clean up your code on the `main` branch

- Replace any sensitive info that's still in the HEAD of your repo.
- Create a new commit.
- That way, BFG can just remove the commit history and you won't have to worry about messing with current commit at HEAD

## How to remove sensitive info from repo using BFG

### Download [BFG](https://rtyley.github.io/bfg-repo-cleaner/)

- save it to `/src/backup-repos` for the examples
- using version 1.13.0 in examples

### Make copy of the repo you want to clean\*

```bash
cd /src/backup-repos
git clone --mirror git://example.com/my-project.git
```

- If you're already getting errors about PRs, then some sensitive info has leaked into your PRs. See the workaround for that in the troubleshooting section (using bare and separate repo)

---

### Create `credentials.txt`

new secret per line:

```text
123abc!9dk
admin@some-company.com
secret-key123
```

### Run BFG command to replace sensitive text

```bash
java -jar bfg-1.13.0.jar --replace-text credentials.txt my-project.git\
```

### Check command output and output files to verify

Find report, which will be saved inside your repo's `.git` folder. For example: `~\src\backup-repos\flask-test-project.git.bfg-report\2019-09-05\14-09-43`

- The output can be confusing, so compare it to the success example in the appendix below to see if everything worked.

If everything looks good, change into the 'mirrored' repo and push:

```bash
cd my-project.git # from your /src/backup-repos directory
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push # requires branch to be unprotected

```

### Review if changes worked

- View your git repo online
- Make sure most-recent commit doesn't have any sensitive data OR `***REMOVED***` (this would probably cause something to break)
- Make sure sensitive data from previous commits replaced with `***REMOVED***`
  - If not, refresh page to make sure you're not seeing the old, cached version
  - See [`git-search-log.sh`](./git-search-log.sh) for an example on how to automate this review process.

If changes worked, rename your old repo

```bash
mv my-project/ my-project-old
```

### Clone a fresh copy of your repo

- From the url on your git host

```bash
git clone ....my-project.git
```

### Continue working from your fresh copy

You need to do this because your original repo will have 'uncommitted' files, and committing them will put you back where you started. So, 'start over' with this new, clean repo

## Troubleshooting

### Error: `deny updating a hidden ref`

The error:

```bash
! [remote rejected] refs/pull/1/head -> refs/pull/1/head (deny updating a hidden ref)
```

This happens because the sensitive info is in PRs from the old repo.

Fix it by cloning without the PRs and pushing to a new repo.

Create new git repo in GitHub.

Then:

```bash
git clone --bare https://github.com/exampleuser/old-repository.git
cd old-repository
git push --mirror https://github.com/exampleuser/new-repository.git
```

## Appendix

### Remove large files

BFG can also remove large files from your history, speeding up dev time.

Here's a brief example. Follow the official docs for more info.

```bash
java -jar bfg-1.13.0.jar --strip-blobs-bigger-than 100M my-project.git\
```

### References

- [Removing Keys, Passwords and Other Sensitive Data from Old Github Commits on OSX](https://medium.com/@rhoprhh/removing-keys-passwords-and-other-sensitive-data-from-old-github-commits-on-osx-2fb903604a56)

### Output from replace text command

```bash
C:\Users\tyler\src\backup-repos
(venv) λ java -jar bfg-1.13.0.jar --replace-text credentials.txt flask-test-project.git\

Using repo : C:\Users\tyler\src\backup-repos\flask-test-project.git

Found 48 objects to protect
Found 2 commit-pointing refs : HEAD, refs/heads/master

## Protected commits

These are your protected commits, and so their contents will NOT be altered:

- commit e7784945 (protected by 'HEAD') - contains 9 dirty files : - recordings/temp_contact.csv (28 B) - static/package.json (547 B) - ...

WARNING: The dirty content above may be removed from other commits, but as
the _protected_ commits still use it, it will STILL exist in your repository.

Details of protected dirty content have been recorded here :

C:\Users\tyler\src\backup-repos\flask-test-project.git.bfg-report\2019-09-05\14-09-43\protected-dirt\

If you _really_ want this content gone, make a manual commit that removes it,
and then run the BFG on a fresh copy of your repo.

## Cleaning

Found 8 commits
Cleaning commits: 100% (8/8)
Cleaning commits completed in 317 ms.

## Updating 1 Ref

        Ref                 Before     After
        ---------------------------------------
        refs/heads/master | e7784945 | 976aa8dc

Updating references: 100% (1/1)
...Ref update completed in 36 ms.

## Commit Tree-Dirt History

        Earliest      Latest
        |                  |
         D D  D D  D D  D m

        D = dirty commits (file tree fixed)
        m = modified commits (commit message or parents changed)
        . = clean commits (no changes to file tree)

                                Before     After
        -------------------------------------------
        First modified commit | 13e5e94e | f447231d
        Last dirty commit     | 348ee14a | a44ffcee

## Changed files

        Filename           Before & After
        -----------------------------------------------------------
        csv_test.py      | 7d381a74 ? 74d2a693
        csv_test2.py     | 7b1a53c9 ? 191dc7f4, 4ce8bd81 ? c89b885b
        hello.html       | e16a1295 ? d305e32c
        index.html       | 24e62d6d ? 75820686, 77f79814 ? b349ebcb
        package.json     | fc4e2d31 ? 44f2483d
        plot_input.py    | ad12a9c6 ? e5c364e6
        pydub_test.py    | d4917745 ? 8470fddd
        temp.py          | 939b11fe ? 6eea2fa5
        temp_contact.csv | ea97c826 ? e77efda0
        wav_test.py      | 3ce0ebdf ? a11f8d57

In total, 26 object ids were changed. Full details are logged here:

        C:\Users\tyler\src\backup-repos\flask-test-project.git.bfg-report\2019-09-05\14-09-43

BFG run is complete! When ready, run: git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

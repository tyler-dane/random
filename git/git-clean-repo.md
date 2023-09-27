# Remove large filesand sensitive info from repo using [BFG](https://rtyley.github.io/bfg-repo-cleaner/)

## Prep

Save link to commits on GitHub with dirty files

- Will make it easier to confirm it worked later

Clean up your code on the `main` branch and make commit first

- That way, BFG can just remove the commit history and you won't have to worry about messing with current commit at HEAD

Download .jar

- save it to `/src/backup-repos` for the examples
- using version 1.13.0 in examples

Make copy of the repo you want to clean\*

        - If you already are getting errors about PRs, see the below troubleshooting (using bare and separate repo)

```bash
cd /src/backup-repos
git clone --mirror git://example.com/my-project.git
```

---

## Opt1 Remove Sensitive Info

create `credentials.txt`, new item per line:

```

123abc!9dk
admin@some-company.com
secret-key123

```

replace text:

```

java -jar bfg-1.13.0.jar --replace-text credentials.txt my-project.git\

```

check command output and output files to verify

- `\src\backup-repos\flask-test-project.git.bfg-report\2019-09-05\14-09-43`

If everything looks good, change into the 'mirrored' repo and push:

```

cd my-project.git # from your /src/backup-repos directory
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push # requires branch to be unprotected

```

Review if changes worked

- View your git repo online
- Make sure most-recent commit doesn't have any sensitive data OR `***REMOVED***` (this would probably cause something to break)
- Make sure sensitive data is replaced with `***REMOVED***` for previous commits
  - If not, refresh page to make sure you're not seeing the old, cached version

If changes worked:

rename your old repo

```

mv my-project/ my-project-old

```

clone a fresh copy of your repo (from the url on your git host)

```

git clone ....my-project.git

```

Continue working from your fresh copy

- You need to do this because your original repo will have 'uncommitted' files, and committing them will put you back where you started. So, start 'over' with this new, clean
  repo

### Troubleshooting

Do this if you run into the hidden ref error:
`! [remote rejected] refs/pull/1/head -> refs/pull/1/head (deny updating a hidden ref),do this:`

This happens because the sensitive info is in PRs from the old repo.
Fix it by cloning without the PRs and pushing to a new repo.

Create new git repo in GitHub, then:

```

git clone --bare https://github.com/exampleuser/old-repository.git
cd old-repository
git push --mirror https://github.com/exampleuser/new-repository.git

```

## Opt 2: remove large files:

```

java -jar bfg-1.13.0.jar --strip-blobs-bigger-than 100M my-project.git\

```

### References:

- [Removing Keys, Passwords and Other Sensitive Data from Old Github Commits on OSX](https://medium.com/@rhoprhh/removing-keys-passwords-and-other-sensitive-data-from-old-github-commits-on-osx-2fb903604a56)

## Appendix

1. output from replace text command:

```

C:\Users\tyler.hitzeman\src\backup-repos
(venv) λ java -jar bfg-1.13.0.jar --replace-text credentials.txt flask-test-project.git\

Using repo : C:\Users\tyler.hitzeman\src\backup-repos\flask-test-project.git

Found 48 objects to protect
Found 2 commit-pointing refs : HEAD, refs/heads/master

## Protected commits

These are your protected commits, and so their contents will NOT be altered:

- commit e7784945 (protected by 'HEAD') - contains 9 dirty files : - recordings/temp_contact.csv (28 B) - static/package.json (547 B) - ...

WARNING: The dirty content above may be removed from other commits, but as
the _protected_ commits still use it, it will STILL exist in your repository.

Details of protected dirty content have been recorded here :

C:\Users\tyler.hitzeman\src\backup-repos\flask-test-project.git.bfg-report\2019-09-05\14-09-43\protected-dirt\

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

        C:\Users\tyler.hitzeman\src\backup-repos\flask-test-project.git.bfg-report\2019-09-05\14-09-43

BFG run is complete! When ready, run: git reflog expire --expire=now --all && git gc --prune=now --aggressive

```

```

```

---
title: So, you’ve decided to change your r package name
date: '2017-10-27'
slug: change-pkg-name
categories: []
aliases:
  - /post/2017/10/27/change-pkg-name/
---

I've had to change my R package names a few times. 


[ggmissing became naniar.](https://github.com/njtierney/naniar/commit/6607a02415053be2386822b5d1f3b8ac0c897106)



[naniar became narnia.](https://github.com/njtierney/naniar/commit/154256718dcae9e5f661597a1b0f90167028c378)



[narnia went back to naniar.](https://github.com/njtierney/naniar/commit/c8040a9cb9ea9527b7258cd8ce8f6f0d92800660)



Every time I've had to do this, there were a few things I had to remember to do. Here's a blog post that describes how to do that.



There are two parts, changing the R package name, and changing the git/github settings.

# Part 1: Changing the R package name

When you change your package name, here is a list of things you need to do.

1. update your DESCRIPTION file package name
2. update the NEWS.md
3. update the name in the README file
4. update the .RProj name
5. update the folder name
6. update your package-<packagename>.R file
7. Do a search (Cmd/Ctr + Shift + F) and look for mentions of your package name

And that's basically it!



Hooray, now to handle the git business.


<p>
<div style="height: auto">
<img src="https://gifs.njtierney.com/njt-gif-jaws-dolly-zoom.gif" alt="Gif of a dolly zoom from Spielbergs Jaws" style="width: 100%;max-height: 100%" />
</div>
</p>

# Part 2: Changing the github name

Now, with this final setup, what you want to do is go into your github repo, go to settings, then change the repo name.

![](https://imgs.njtierney.com/njt-git-name-change.png)

You will then need to tell git where to look for your package online, as the URL has changed.

First, let's show where the origin is.

```
git remote show origin
```

```
* remote origin
  Fetch URL: https://github.com/<USERNAME/ORGANISATION>/<REPO-NAME>.git
  Push  URL: https://github.com/<USERNAME/ORGANISATION>/<REPO-NAME>.git
  HEAD branch: master
  Remote branches:
    maddiedoc tracked
    master    tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)
```

Then, remove the origin, with

```
git remote rm origin
```

Nothing will happen. That is good. Now, check that you have no origin file.

```
git remote show origin
```

```
git remote show origin
fatal: 'origin' does not appear to be a git repository
fatal: Could not read from remote repository.
```

Great. Now, add the new origin.

```
git remote add origin https://github.com/<USERNAME/ORGANISATION>/<YOUR-NEW-REPO-NAME>.git
```

Nothing will happen. This is good.



Now, check that the remote has been set.

```
git remote show origin
```

```
remote origin
  Fetch URL: https://github.com/<USERNAME/ORGANISATION>/<YOUR-NEW-REPO-NAME>.git
  Push  URL: https://github.com/<USERNAME/ORGANISATION>/<YOUR-NEW-REPO-NAME>.git
  HEAD branch: master
  Remote branches:
    maddiedoc new (next fetch will store in remotes/origin)
    master    new (next fetch will store in remotes/origin)
  Local ref configured for 'git push':
    master pushes to master (up to date)
```

Great, now make your changes, then add them, then do a commit.

```
git add .
git commit -m "updated package doco to be clearer about what the data is"
```

And then push them. 

```
git push
```

```
fatal: The current branch master has no upstream branch.
To push the current branch and set the remote as upstream, use

   git push --set-upstream origin master
```

This is fine.



Before we can push these changes onto github, we need to tell it where to push to.



Do this with

```
git push -u https://github.com/<USERNAME/ORGANISATION>/<YOUR-NEW-REPO-NAME>.git
```

This tells git where you want to push to, and to keep pushing there.



And that's it!



Happy coding


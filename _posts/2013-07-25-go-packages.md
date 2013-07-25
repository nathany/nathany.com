---
title: Go Package Management
date: 2013/07/25
tags: golang
excerpt: A cry for gophers to unify on remote package management.
layout: article
published: false
---

## Foundation

The Go tool-chain includes the `go get` command to install third-party packages directly from version control systems.

> "One of the virtues of the Go tool is that it uses Git, Mercurial, Subversion, Bazaar..." - Andrew Gerrand, [Go Fireside Chat 2013](http://www.youtube.com/watch?v=p9VUCp98ay4)

I think this is a brilliant move. In other ecosystems, tools like [Bundler](http://bundler.io/) (Ruby) and [Pip](http://www.pip-installer.org/) (Python) also support installing from a VCS, allowing users to gain access to code that hasn't yet been pushed to their central repositories.

However, we can't really compare `go get` to full-featured package managers like these. It provides a simple means for installation and little more. In particular, it doesn't provide versions or even uninstalls. This _isn't the end-of-the-world_ though, as `go get` can be used to bootstrap more capable tools built by the Go Community.

> "Everything else is built on this flexible foundation (FTP) and has grown over time." - Steffen Mueller,
[Python people want CPAN and how the latter came about](http://www.google.com/url?q=http%3A%2F%2Fmail.python.org%2Fpipermail%2Fdistutils-sig%2F2009-December%2F014977.html&sa=D&sntz=1&usg=AFQjCNHK-oYwAsIsjWXjqi44P8yDBIJgXQ)

A number of third-party tools exist, including
[Envie](https://github.com/sam-falvo/envie),
[Go Nuts](http://www.gonuts.io/-/doc),
[Go Pin](https://github.com/laher/gopin),
[Goven](https://github.com/kr/goven),
[Go Pack](https://github.com/gopack/gpk),
[Go Package Manager](https://github.com/GPMGo/gopm),
[GVM](https://github.com/moovweb/gvm) and
[Rx](http://godoc.org/kylelemons.net/go/rx). It's great that our fellow gophers are building these tools and exploring different avenues, but _which one do I use?_

Newcomers to the Python community had similar confusion, but now there is BDFL-delegate overseeing packaging:

> "That basically gives us the power to say 'Yes'. And lets us channel the energy of all the people involved in productive directions, such that we'll actually improve the ecosystem as whole, rather than people going off their separate ways and just creating more fractured communities." - Nick Coghlan, [Nobody Expects the Python Packaging Authority](http://www.youtube.com/watch?v=8Xrdt3-YVz4)

## Let's Make Things Better

On June 23rd, David Hinks posted a Google Doc with the following message:

> "I want to have reproducible builds on different computers at different times.  This is currently problematic; let's make things better." - David Hinkes, [Go+](https://plus.google.com/u/0/115983116618286597159/posts/gczN5SQ94ek)

After contributing to David's document, I put together my own _intentionally simplistic_ proposal based loosely on `Gemfile.lock` from Bundler. [Dave Cheney](http://dave.cheney.net/) pointed out some flaws, and [Kyle Lemons](http://kylelemons.net/) observed similarities between my proposal and [Rx cabinets](http://godoc.org/kylelemons.net/go/rx#hdr-Cabinet_Command).

There are actually a number of solutions to reproducible builds. Git provides [submodules](http://git-scm.com/book/en/Git-Tools-Submodules) and [subtree merging](http://git-scm.com/book/en/Git-Tools-Subtree-Merging). Third-party tools like Rx and Go Pin can track references, or Goven can copy dependencies into your project.

The problem is that we don't have a "Go Packaging Authority" providing guidance, so every newcomer is left to find their own way.

Shortly after all this, I saw [Mitchell Hashimoto](http://mitchellh.com/)'s GopherVault proposal to the versioning problem. This is a more difficult challenge, and there were some flaws with that proposal as well.

So I thought: I should take a step back and really think about this more. Not because I'm any sort of expect, but because ***I would like Go to have a great packaging story.*** Over the _past month,_ I used a [Google Doc](http://goo.gl/oqkvu) as my outlet, and invited others to comment and make edits.

While I don't have a grand solution, I believe there are a few fundamentals to building a great packaging story.

## 1. Keep Builds Sane

What would happen if your project were to import both `labix.org/v2/mgo` and `labix.org/v1/mgo`? Would it compile? Would each `init()` compete for resources (e.g. connections)? Would it merely enlarge the resulting binary?

While this specific example is unlikely, it doesn't take much imagination to see it becoming a issue. As more Go packages hit v2, and as the typical dependency tree gets deeper, this is set to become a big problem.

### One Import Path

To avoid these scenarios, every package must have one &ndash; and only one &ndash; import path.

Given a package under `$GOPATH/src/fsnotify`, every other package must refer to it with `import "fsnotify"`.

By convention, go get will create a folder `$GOPATH/src/github.com/howeyc/fsnotify` for the code retrieved from `github.com/howeyc/fsnotify`. However, the compiler only cares about the import path referring to a location on disk.

It's absolutely fine if the code actually came from a fork at `github.com/mycompany/fsnotify`, as long as it's still stored locally at `$GOPATH/src/github.com/howeyc/fsnotify`. Likewise, we could add a level of indirection, whether locally or through a `<meta name="go-import"...`, so long as the entire Go ecosystem uses the same import path for fsnotify.

### Avoid Mirrors

A fictional mirror at `bitbucket.org/howeyc/fsnotify` would be problematic. If some packages import the mirror, a project could end up pulling in fsnotify from both locations.

### Avoid Moving Packages

The reason I'm picking on fsnotify is because it has a legitimate reason to move to `code.google.com/p/go.exp/fsnotify` and eventually into the standard library.

If your project were using my mythical fsnotify-ext package, and if it was depending on `code.google.com/p/go.exp/fsnotify` while another dependency (eg. Revel) uses the `github.com/howeyc/fsnotify` import path, oh boy!

### Avoid Versions in Paths

A project should only ever import one version of a given package. Checking out a tag is a much better option.

## 2. Encourage Upstream Contributions

One of the great things about `go get` is the ease of switching into a third-party package, performing a patch and pull request, and getting back to work without reconfiguring your project.

Even better, `gofmt` helps ensure that a pull request only has the necessary changes, without any superfluous formatting differences.

### Avoid Rewriting Imports

Anything that makes upstream contributions more work is a bad idea. It doesn't take much to rewrite import paths locally, but it makes it just a little bit harder to test and submit a patch. Best to avoid.

### Don't Try To Gofix Others

Gofix is a really intriguing tool. It isn't yet to the point where third-party packages can ship gofix modules to update dependent code. As it turns out, designing an simple AST-altering API is a bit of a challenge.

Even with such a wonderful tool, I have my doubts on how it would scale to the larger package ecosystem. It's one thing to Gofix my own code, but Gofixing another third-party package seems fraught with problems. I hope to be proven wrong.

### Don't Forget History

Any package management solution that does away with the .git, .hg, .bzr folder removes the ease of contribution.

## 3. Work Together

If you take anything away from the article, let it be that we need to work together.

### Be Inclusive

While embracing DVCS is a great idea, I believe it can be taken too far.

DVCS-specific solutions like Git submodules prevent the use of Bazaar packages like goamz, gocheck and mgo. Mirroring the packages has its own set of issues, and in the long-term it fractures the Go community by DVCS selection.

Similarly, package management tools should be cross-platform, not catering to a particular OS.

### Interoperability

If multiple package management tools are to exist, they need to interoperate.

As a package maintainer, I'm not about to say "you must install Go Nuts to use this package" or "I recommend Rx to get new versions of this package." It doesn't work.

We as a community need to agree on a set of tools, or at minimum, a common metadata format and strategy for managing packages.

If and when we get into versioning and dependency resolution, the need for interoperability becomes even more pronounced.

### Community

It would be great if the Go Authors specified and built an official solution for package management in Go. It's not a requirement.

The larger Go Community can make a package management tool official. It doesn't need to be part of the `go` tool to be what we all use.

So lets rally together and get started!







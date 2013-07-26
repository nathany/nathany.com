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

I think building on top of DVCS is a brilliant move. While `go get` isn't a full-featured package manager like [Bundler](http://bundler.io/) (Ruby) or [Pip](http://www.pip-installer.org/) (Python), we can use it to bootstrap more capable tools built by the Go Community.

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

Newcomers to the Python community were in a similar situation, but it's getting better, now that there is BDFL-delegate overseeing packaging:

> "That basically gives us the power to say 'Yes'. And lets us channel the energy of all the people involved in productive directions, such that we'll actually improve the ecosystem as whole, rather than people going off their separate ways and just creating more fractured communities." - Nick Coghlan, [Nobody Expects the Python Packaging Authority](http://www.youtube.com/watch?v=8Xrdt3-YVz4)


## Let's Make Things Better

On June 23rd, David Hinks posted a Google Doc with the following message:

> "I want to have reproducible builds on different computers at different times.  This is currently problematic; let's make things better." - David Hinkes, [Go+](https://plus.google.com/u/0/115983116618286597159/posts/gczN5SQ94ek)

After contributing to David's document, I put together my own proposal based loosely on Bundler's `Gemfile.lock`. [Dave Cheney](http://dave.cheney.net/) pointed out some flaws, and [Kyle Lemons](http://kylelemons.net/) observed similarities between my proposal and [Rx cabinets](http://godoc.org/kylelemons.net/go/rx#hdr-Cabinet_Command).

There are actually a number of solutions to reproducible builds. Git provides [submodules](http://git-scm.com/book/en/Git-Tools-Submodules) and [subtree merging](http://git-scm.com/book/en/Git-Tools-Subtree-Merging). Third-party tools like Rx and Go Pin can track references, or Goven can copy dependencies into your project.

The problem is, <mark>we don't have a _"Go Packaging Authority"_ providing guidance</mark>, so every newcomer is left to find their own way.

Shortly after, I saw [Mitchell Hashimoto](http://mitchellh.com/)'s GopherVault proposal to the versioning problem. It too wasn't without flaws, perhaps like any new idea.

So I thought: I should take a step back and really think about this more. Not because I'm any sort of expect, but because <mark>I would like Go to have a great packaging story</mark>. Over the _past month,_ I used a [Google Doc](http://goo.gl/oqkvu) as my outlet, and invited others to contribute.

While I don't have a grand solution, I believe there are a few fundamentals to building a great packaging story.

## 1. Keep Builds Sane

Chris Howey's fsnotify package has a legitimate reason to move. First to `code.google.com/p/go.exp/fsnotify` and eventually into the standard library.

What would happen if a project were to import both `github.com/howeyc/fsnotify` and `code.google.com/p/go.exp/fsnotify`? Would it compile? Would both `init()` and compete for resources? Would it merely enlarge the resulting binary?

It's unlikely that a project would directly depend on fsnotify from two locations. It may depend on my mythical fsnotify-ext package, which imports `code.google.com/p/go.exp/fsnotify` while another dependency (eg. Revel) uses `github.com/howeyc/fsnotify`. Now we're in trouble.

### One Import Path

To avoid this scenario, every package must have one &ndash; and only one &ndash; import path. <mark>The entire Go ecosystem must use the same import path for fsnotify.</mark>

By convention, `go get` will create the folder `$GOPATH/src/github.com/howeyc/fsnotify` for the code retrieved from `github.com/howeyc/fsnotify`.

However, the compiler doesn't care where the source code came from. As long as the package can be found at `$GOPATH/src/github.com/howeyc/fsnotify`, it's absolutely fine if the code came from a fork at `github.com/mycompany/fsnotify` or a fictional mirror at `bitbucket.org/howeyc/fsnotify`.

If the Go Community as a whole decided to use `import "fsnotify"`, we could move the code to `$GOPATH/src/fsnotify`, and the compiler would be happy. A level of indirection, in one form or another, could be be quite helpful for keeping builds sane.

### Avoid Versions in Paths

A project should only ever import one version of a given package. What would happen if your project were to import both `labix.org/v2/mgo` and `labix.org/v1/mgo`? It's the same problem all over again.

While this example may sound far-fetched, it doesn't take much imagination to see it becoming an issue. As packages mature, and dependency trees gets deeper, our tools need to adapt.

## 2. Encourage Upstream Contributions

One of the great things about `go get` is how easy it is to switch into a third-party package, perform a patch and pull request, and get back to work without reconfiguring the project.

Even better, `gofmt` helps ensure that a pull request only has the necessary changes, without any superfluous formatting differences.

### Avoid Rewriting Imports

Anything that makes upstream contributions more work is a bad idea. It doesn't take much to rewrite import paths locally, but it makes it just a little bit harder to test and submit a patch. Best to avoid.

### Don't Try To Gofix Others

Gofix is an incredibly intriguing tool. It isn't yet to the point where package authors can easily ship gofix modules to update dependent code. As it turns out, designing an simple AST-altering API is a bit of a challenge.

Even with such a wonderful tool, I have my doubts on how well it would scale to the larger package ecosystem. It's one thing to Gofix my own code, but Gofixing another third-party package seems fraught with problems. I hope to be proven wrong.

### Don't Forget History

Any package management solution that does away with the hidden .git, .hg, .bzr folder removes the ease of contribution.

## 3. Work Together

Package management tools may be technically interesting to develop, but the real challenge is a people problem. Gophers hail from *NIX and Windows, with backgrounds in C, Python, Ruby, PHP and .NET. We are a diverse group with differing views on what package management should look like.

### Be Inclusive

While embracing DVCS is a great idea, I believe it can be taken too far.

DVCS-specific solutions like Git submodules make it more difficult to use and contribute to Bazaar packages like goamz, gocheck and mgo. I don't want to see the Go community fractured by DVCS selection.

Similarly, package management tools should be cross-platform, not catering to users of a particular OS.

### Interoperability

As a package maintainer, I'm not about to say "you must install Go Nuts to use this package" or "I recommend Rx to get new versions of this package."

We as a community need to agree on a set of tools, a common metadata format and strategy for managing packages. If multiple package management tools are to exist, they need to interoperate.
If and when we get into versioning and dependency resolution, the need for interoperability becomes even more pronounced.


### Community

It would be great if the Go Authors specified and built an official package manager for Go. It's not a requirement though.

The larger Go Community can make a package management tool official. It doesn't need to be part of the `go` tool to be what we all use.

So lets rally together and get started!







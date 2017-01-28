+++
title = "Go Package Management"
date = "2013-07-25"
revised = "2014-04-17"
keywords = ["golang", "packages", "dependencies"]
description = "A summary of dependency management in Go."
+++

<figure data-tooltip="Photograph &copy; 2015 Nathan Youngman" data-tooltip2="Go gopher designed by Ren&eacute;e French">
    <img alt="Gophers with parcels" class="full" src="/images/gopher-tagging.jpg">
    <figcaption>Just another day at the Go package sorting facility.</figcaption>
</figure>

## Remote Packages

The `go get` command installs remote packages directly from version control (GitHub, Bitbucket, Google Code, Launchpad). Building on top of DVCS is a brilliant move. There is a lovely *immediacy* to pulling in a dependency. <mark>Import and go.</mark>

Package managers like [Bundler](http://bundler.io/), [Pip](http://www.pip-installer.org/) and [NPM](https://www.npmjs.org/) all have some mechanism to bypass their central repositories and pull code directly from source control. The go tool makes this first-class.

When I want to contribute to an upstream package, those other tools force me to reconfigure my project. With the go tool, I switch to the package's directory, make a change and test it out. Sending a pull request is just a few steps away. <mark>Open source collaboration made simple.</mark>

For hobbyists and those starting out, the go tool is all you need.

Resources: 

* [How to Write Go Code](http://golang.org/doc/code.html) (golang.org)
* [Organizing Code to Support Go Get](http://www.goinggo.net/2013/08/organizing-code-to-support-go-get.html) by William Kennedy

The simplicity of the go tool does come with its trade-offs.

> "I want to have reproducible builds on different computers at different times.  This is currently problematic; let's make things better." - David Hinkes, [Go+](https://plus.google.com/u/0/115983116618286597159/posts/gczN5SQ94ek) 

`Go get` does not have an explicit concept of versions. Members of a team may be importing different revisions *(version skew)*. Dependencies may introduce incompatibilities or security vulnerabilities, or even change licenses or disappear. For these reasons, it's desirable to have more control over the upgrade process when building a real-world application.

<figure data-tooltip="Photograph &copy; 2015 Nathan Youngman" data-tooltip2="Go gopher designed by Ren&eacute;e French">
    <img alt="A plate of packages." class="full" src="/images/gopher-vendor.jpg">
    <figcaption>I had some packages for lunch and now they are part of me.</figcaption>
</figure>

## Vendor Your Dependencies

Large companies like Google and Facebook do most development in a single giant repository. This enables massive refactors in a single commit, such as changing an API and every use of it.

When it comes to third-party dependencies, the Go Team [recommends](http://golang.org/doc/faq#get_version) copying them into the source tree:

> "If you're using an externally supplied package and worry that it might change in unexpected ways, the simplest solution is to copy it to your local repository. (This is the approach Google takes internally.) Store the copy under a new import path that identifies it as a local copy. For example, you might copy `original.com/pkg` to `you.com/external/original.com/pkg`." - [Go FAQ](http://golang.org/doc/faq#get_version)

There is no need for a central archive of every version of every Go library ever released. Dependencies may move or disappear in the world outside your project, but your project has a copy of the dependencies it needs at any given point in history. Brad Fitzpatrick [describes this](http://www.youtube.com/watch?v=p9VUCp98ay4&t=36m55s) as a <mark>"hermetic view of the world"</mark>. 

How is travelling back through the history of your project useful? Martin Fowler describes some benefits in [ReproducibleBuild](http://martinfowler.com/bliki/ReproducibleBuild.html):

* To reproduce a bug on the release branch that doesn't happen on master.
* Using `bisect` to isolate the commit that introduced a bug.

It's possible to upgrade dependencies in a controlled and tested manner, resolving all the stated issues with `go get`.

So what are the trade-offs?

* Compared to `go get`, it is a little more complicated, likely requiring an additional tool or script to copy, upgrade and remove dependencies.
* It's more difficult to contribute upstream (particularly if import rewriting is one-way). If upstream contributions are frequent, this option may be less appealing.
* This solution applies well to applications, but it's not clear how to better manage dependencies of a *library*.

Resources:

* [Manage Dependencies With Godep](http://www.goinggo.net/2013/10/manage-dependencies-with-godep.html) by William Kennedy

<figure data-tooltip="Photograph &copy; 2015 Nathan Youngman" data-tooltip2="Go gopher designed by Ren&eacute;e French">
    <img alt="Gophers with pliers and packing tape." class="full" src="/images/gopher-packaging-tools.jpg">
    <figcaption>Not all these tools are appropriate for the job.</figcaption>
</figure>

## The Right Tool

Most language ecosystems have settled on one tool for versioning packages. Yet it's worth noting that Yukihiro "Matz" Matsumoto isn't the driving force behind Bundler, nor is Guido van Rossum the BDFL for Pip. Members of the community built these tools, and in time they became established as the *standard.*

Go itself doesn't mandate a one-size-fits-all solution:

> "Versioning is a source of significant complexity, especially in large code bases, and we are unaware of any approach that works well at scale in a large enough variety of situations to be appropriate to force on all Go users." - [Go FAQ](http://golang.org/doc/faq#get_version)

Using `go get` or copying dependencies into a `vendor` folder are the approaches endorsed by the Go Team.

Others have simply forked all their dependencies to control when upgrades occur. Some have built tools to checkout dependencies with SHA revision identifiers. Still others utilize DVCS features like [submodules](http://git-scm.com/book/en/Git-Tools-Submodules) or [subtree merging][subtree merging]. Experiment, find what works for you.



The `go` tool provides a place for newcomers to start and some conventions to build upon.

> "One of the virtues of the Go tool is that it uses Git, Mercurial, Subversion, Bazaar..." - Andrew Gerrand, [Go Fireside Chat 2013](http://www.youtube.com/watch?v=p9VUCp98ay4&t=37m42s)

By convention, `go get` will create the folder `$GOPATH/src/github.com/howeyc/fsnotify` for the code retrieved from `github.com/howeyc/fsnotify`.

The compiler actually doesn't care where the source code came from. As long as the package can be found at `$GOPATH/src/github.com/howeyc/fsnotify`, it's absolutely fine if the code actually came from a fork at `github.com/mycompany/fsnotify` or a mirror at `code.google.com/p/go.exp/fsnotify`.

Adding remotes, checking out tags, all the usual DVCS operations are fair game.

## The Next Big Thing

So you have an idea that will <mark>revolutionize</mark> how we `go get` packages? 

First, join the [GoPM mailing list][gopm], share your passion, and find out what others are working on. Next, [evaluate what's out there][tools]. We don't need 20 tools that do the same thing (NIH). We want to:

> "...channel the energy of all the people involved in productive directions, such that we'll actually improve the ecosystem as whole, rather than people going off their separate ways and just creating more fractured communities." - Nick Coghlan, [Nobody Expects the Python Packaging Authority](http://www.youtube.com/watch?v=8Xrdt3-YVz4)

### Think Different

Take off those Node.js or Ruby-coloured glasses. Recognize that <mark>Go is different.</mark>

#### No NPM

NPM has a unique strategy for handling multiple versions. Each module requires the versions it wants, which may result in multiple versions of the same module being used in an application. This works well for JavaScript, but Go is not JavaScript.

Beyond bloating up executables, the issues will vary from package to package. Different versions may compete for exclusive access to the same file, same port or other resources. Values of `interface` types may be compatible across both versions of the package, while values of other types won't be implicitly interchangeable. The `init()` functions will be called for both packages, and there will be distinct versions of top-level variables and all global state. *Thanks to Kyle Lemons and John Waycott for [making the issues concrete](https://groups.google.com/forum/#!topic/golang-nuts/5Mr6A8zK6Kk).*

#### No Bundler

Those coming from the Ruby on Rails community may remember copying third-party plugins into the `vendor` folder in the days before Bundler. Surely Go has something more *"sophisticated"* than that?

As you read above, the approach used by Google actually has a number of strengths. It won't be suitable for every situation, but the apparent simplicity and increased repository size shouldn't deter you from trying it.

Let's remember that Bundler's approach isn't without flaws:

* The story of [Sprockets 2.2 backport](https://github.com/rails/rails/issues/9492) is a case where one gem took control away from developers, requiring a hacky workaround.
* Central repositories [go down](http://blog.nodejs.org/2013/11/26/npm-post-mortem/), [get hacked](https://news.ycombinator.com/item?id=5139583) and are costly to run.
* Different permissions for those who can commit and those who can publish a gem have resulted in gems without a recent release.

More importantly, such a tool my never gain sufficient traction if existing Go packages are expected to contain version metadata for it to work. Even if it is technically feasible, "Bundler for Go" may not be culturally suitable. <mark>When in Go do as the gophers do.</mark>

### Keep It Simple

Handling dependencies is incredibly important to the Go Team, even more important than [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself):

> "Through the design of the standard library, great effort was spent on controlling dependencies. It can be better to copy a little code than to pull in a big library for one function. Dependency hygiene trumps code reuse." - [Go at Google](http://talks.golang.org/2012/splash.article#TOC_7.)

When [releasing open source](/os-release) libraries, aim to minimize the number of dependencies. Learn and use the standard library. Be go gettable. Take a look at [gopkg.in](http://labix.org/gopkg.in) for your next major version.

When building an app, try [existing tools][tools] to vendor your dependencies. Contribute improvements. If need be, try another approach. Share what works for you. <mark>Let's make things better.</mark>

*Comment on [reddit](http://www.reddit.com/r/golang/comments/1z900p/go_package_management_20/) or the [GoPM mailing list][gopm].*

Related Articles:

* [Managing Dependencies](http://blog.gopheracademy.com/advent-2014/deps/) by Nathan Youngman
* [Go and Package Versioning](http://zduck.com/2014/go-and-package-versioning/) by Joshua Poehls
* [Maybe Go without dependency management can be a good thing](http://mwholt.blogspot.ca/2014/03/maybe-go-without-dependency-management.html) by Matthew Holt
* [Why I think Go package management is important](http://dave.cheney.net/2013/10/10/why-i-think-go-package-management-is-important) and [Thoughts on Go package management six months on](http://dave.cheney.net/2014/03/22/thoughts-on-go-package-management-six-months-on) by Dave Cheney
* [Go Package Management For 2014](http://www.goinggo.net/2014/01/go-package-management-for-2014.html) by William Kennedy
* [Rx: My prescription for your Go dependency headaches](http://kylelemons.net/blog/2012/04/22-rx-for-go-headaches.article) by Kyle Lemons
* [100% Reproducible Builds in Go](https://vividcortex.com/blog/2013/09/10/100-reproducible-builds-in-go/) (with Johnny Deps) by Baron Schwartz
* [Dependency Hell](http://areyoufuckingcoding.me/2012/04/16/dpendency-hell/) by Chris Kowalik
* [A journey in golang package manager](http://dev.af83.com/2013/09/14/a-journey-in-golang-package-manager.html) by Bruno Michel
* [The Saga of Go Dependency Management](https://blog.gopheracademy.com/advent-2016/saga-go-dependency-management/) by Sam Boyer
* [Go dependency tool](https://github.com/golang/dep)

[subtree merging]: http://git-scm.com/book/en/Git-Tools-Subtree-Merging
[tools]: https://code.google.com/p/go-wiki/wiki/PackageManagementTools
[gopm]: https://groups.google.com/forum/#!forum/go-package-management

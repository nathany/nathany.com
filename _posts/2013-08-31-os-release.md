---
title: Releasing Open Source
date: 2013/08/31
tags: golang, packages, tagging, open source
excerpt: Being a good open source citizen for the benefit of humans and tooling.
layout: article
---

![Gophers with parcels](/assets/images/gopher-tagging.jpg)

*Go get* is [cool and all](http://www.goinggo.net/2013/08/organizing-code-to-support-go-get.html), but like many gophers, I yearn for robust dependency management. Given that it took 13 months for [Bundler](http://bundler.io/) 1.0 to be realized, I don't expect it to happen overnight.

It would be great to chip in somehow, but I have no idea how to write a [SAT solver](http://en.wikipedia.org/wiki/Boolean_satisfiability_problem). Maybe you're in the same boat.

There a few simple things <mark>we can all do</mark> to improve the Go ecosystem. Before you unleash your next open source project and \[ANN\] it on [Go Nuts](https://groups.google.com/forum/#!forum/golang-nuts), consider this.

## See What's Out There

Before getting started, do a search on [GoDoc](http://godoc.org/).

Here are a few packages for working with databases: [codex](https://github.com/chuckpreslar/codex), [gorp](https://github.com/coopernurse/gorp), [goSQL](https://github.com/quintans/goSQL), [hood](https://github.com/eaigner/hood), [jet](https://github.com/eaigner/jet), [kdb](https://github.com/sdming/kdb), [meddler](https://github.com/russross/meddler), and [sqlx](https://github.com/jmoiron/sqlx).

We probably have enough options, but I bet any one of these packages could be improved upon. Why not find something close to your needs and contribute?

If later you decide to start fresh, or take a wildly different approach, you'll have met a fellow gopher and probably learned something too.

## Write A Readme

Make a good first impression with a README that describes the purpose of your project, how to install it, and how to use it.

You might even consider [writing it first](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html). Go itself began with the spec:

```bash
$ hg log -r4
changeset:   4:4e9a5b095532
user:        Robert Griesemer <gri@golang.org>
date:        Sun Mar 02 20:47:34 2008 -0800
summary:     Go spec starting point.
```

If you're writing a package, be sure to [document the APIs](http://blog.golang.org/godoc-documenting-go-code) and link to your [GoDoc](http://godoc.org/) from the README.

### Contributing

In addition to a `README.md`, provide instructions for those who have a question, an issue, or code to contribute. Put this in a file named `CONTRIBUTING.md`. If you're using GitHub, it will link to your CONTRIBUTING file from the *New Issue* form:

> Please review the [guidelines for contributing][contributing] to this repository.


## Choose A License

Go is under a BSD (3-clause) License. I don't need the third clause for personal projects, so I just use the BSD 2-clause License (Simplified BSD). [Choose whatever license suits your needs](http://choosealicense.com/).

There is a `LICENSE` file in the root of my Development folder with the Copyright set, so I can just copy the file and I'm good to go. To make it easier to tell which license I'm using, I like to commit the LICENSE by itself with the message "Simplified BSD License".

## Tag Your Releases

Tools like [Johnny Deps](https://github.com/vividcortex/johnny-deps) and [Rx](http://godoc.org/kylelemons.net/go/rx) already make use of tags to checkout specific releases. When I looked at using one of these tools, I found that 3 of 4 dependencies had no tags (sad panda). Then I realized I hadn't tagged my project either!

Whether or not you use these tools, it's still a good habit to add tags in your DVCS of choice.

### Git

See [Pro Git](http://git-scm.com/book/ch2-6.html) for details.

```bash
git tag v1.0.0         # Tag the current revision
git tag v0.1.0 b13a082 # Tag a past revision
git tag                # List tags
git push origin --tags # Share tags (pushes tags only)
```

### Mercurial

See [Mercurial: The Definitive Guide](http://hgbook.red-bean.com/read/managing-releases-and-branchy-development.html) for details.

```bash
hg tag v1.0.0          # Tag the current revision
hg tag -r 13 v0.1.0    # Tag a past revision
hg tags                # List tags
hg push                # Share tags (.hgtags already committed)
```

### Bazaar

See [Bazaar Wiki](http://wiki.bazaar.canonical.com/Tag) for details. *Yes, these instructions are exactly the same as Mercurial.*

```bash
bzr tag v1.0.0         # Tag the current revision
bzr tag -r 13 v0.1.0   # Tag a past revision
bzr tags               # List tags
bzr push               # Share tags (stores tags with branch)
```


### Versions

Go uses Semantic Versioning and ***so should you.*** Go went through many changes until it stabilized as 1.0.0. This year 1.1.0 was released, a backwards compatible update. 1.1.2 was a patch release, and breaking changes await a 2.0.0 release in the distant future. Please <mark>read and follow</mark> [Semantic Versioning 2.0.0](http://semver.org/).

By convention, tags that specify a version should start with the letter 'v', for example: <mark>v1.0.0-rc.1</mark>.

If you have something against versions, please still tag your releases. Might I suggest using the international date format (ISO 8601), as in <mark>r2013-08-31</mark>.

***Add a tag today!***

### Futureproof

Before we can specify dependencies, we need to version our releases. Tags are the most obvious approach. Using a consistent format opens up possibilities for future tooling, but tags remain useful for humans even if future tooling doesn't use them directly.

In case you are wondering, there are APIs to list tags for [GitHub](http://developer.github.com/v3/git/refs/#get-all-references) and [BitBucket](https://confluence.atlassian.com/display/BITBUCKET/repository+Resource#repositoryResource-GETalistofthetags).



## Write a Changelog

[Dominik Honnef](http://dominik.honnef.co/) is writing a series entitled *"What's happening in Go tip"*. Reading a high-level summary of changes is so much nicer than parsing dozens of commit messages.

This is the benefit of providing a changelog for your project, even if it's just in point form. Here's an example:

```
# Changelog

## v0.2.1 / 2013-07-06

* Add --debug flag to help track down [#6] Tests run twice

## v0.2.0 / 2013-05-16

* Rename to Looper
* Packages are the unit of compilation in Go. Use a package-level
  granularity for testing.
* Don't log Stat errors (can be caused by atomic saves in editors)
...
```

Please take note:

* Entries are in ***reverse chronological*** order, putting the most relevant information first.
* The first "word" for ***second-level headings*** matches the **tag** we used previously.
* A standard filename makes it easier for humans to locate (I'm currently using CHANGES, though some people use HISTORY, NEWS or CHANGELOG). We could [bring it to a vote][survey]. :-)
* Though not shown here, it's fairly common to have an "Unreleased" section at the top, listing changes on `master` that will become the next release.

Markdown is a well known format that displays nicely on GitHub and BitBucket. The [Go present](http://godoc.org/code.google.com/p/go.talks/pkg/present) format is only slightly different:

```
* Changelog

** v0.1.1 / 2013-04-21

- Fixes "named files must all be in one directory" error [#2]
- Pass through for -tags command line argument. Thanks @jtacoma.
```

For the lazy, [tools exist to generate changelogs](http://rubyworks.github.io/vclog/), though I have yet to try it.

What I find more interesting are tools to [parse changelogs](https://github.com/tech-angels/vandamme). Apps like [Gemnasium](https://gemnasium.com/) will present the *relevant subset* of a changelog. Consistent use of tags, subheadings and filenames make this kind of tooling fairly straightforward.

## Finî

I hope this is a good starting place for practices that are beneficial to us humans today, while also paving the way for more and better tooling. Thanks for reading. If you wouldn't mind, please complete [this five question survey][survey].

Let me know how I can improve this article. You can reach me on Twitter [@gophertown](https://twitter.com/gophertown) or comment on [Go+](https://plus.google.com/104313268939103200754/posts/Ca9S8UjSfLU),
[reddit](http://www.reddit.com/r/golang/comments/1lgy4p/releasing_open_source_for_humans_and_for_tooling/), or the
[Go Nuts mailing list](https://groups.google.com/forum/#!topic/golang-nuts/FyXLZNPH7_U).

Related Articles:

* [Go Package Management](/go-packages)



[contributing]: https://github.com/gophertown/looper/blob/master/CONTRIBUTING.md
[survey]: https://docs.google.com/forms/d/1XGjy74hrq2DG-Zh4VwqxSuAWPlLf2zx5KAU1VCph5ys/viewform


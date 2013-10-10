---
title: Go Testing Toolbox
date: 2013-09-28
tags: golang, testing, vagrantup, coverage, mocking, continuous integration, looper, autotest
excerpt: A conglomeration of testing tools, from Autotest to Vagrant.
layout: article
---

![Gophers with a ruler and a hammer](/assets/images/gopher-tools.jpg)

Let's explore some of the tools available for testing our Go code.

## Unit Testing

Go has testing baked in. Below we contrast the standard [testing][] package with Gustavo Niemeyer's popular [gocheck][] library:

```go
// with testing
if !reflect.DeepEqual(value, 42) {
    t.Errorf("Give us the ultimate question then")
}

// with gocheck
c.Check(value, DeepEquals, 42, Commentf("Give us the ultimate question then"))
```

Gocheck one-liners are a little more concise, and we don't lose out in extensibility. For example, gocheck [doesn't ship with a delta checker for floats](https://bugs.launchpad.net/gocheck/+bug/1131537). I wanted something that looked like this:

```go
c.Assert(gear.GearInches(), Within, 0.01, 137.1)
```

So I wrote [a custom checker](https://github.com/nathany/go-poodr/blob/master/chapter9/gear1/gear1_check_test.go) in less than 20 lines of code. Arguably, I could've written a `Within()` helper function in 3. So you win some, you lose some.

There are ways to write concise tests without pulling in an xUnit assertion frameworks. If you've ever seen Cucumber <mark>data tables</mark>, you will appreciate [table driven tests][tabledriven], a simple way of testing many variations with relatively compact code.


### Alternatives

Gocheck isn't the only third-party option out there. Andrea Fazzi's [PrettyTest][] has a colourful test runner, and it is compatible with gocheck assertions.

Go has anonymous functions, so it was only a matter of time before someone built a [Jasmine][]-style BDD library. There are several options, including [Mao][]/[Zen][], [GoConvey][] and [Ginkgo][]/[G&Omega;mega][gomega]. Unfortunately I haven't had a chance to try these yet, so I can't vouch for them. 

No doubt there are other tools that have slipped past my radar. Lately I've been reaching for the standard testing package, mostly to avoid *yet-another-dependency* in reusable libraries. Go 1.2's ability to download test dependencies with `go get -t` may change that for me.


## Mocking

Mocking, stubbing, fakes, test doubles... it can be a bit confusing.

A summer ago, I was learning OpenGL, and wanted a way to stub out the graphics context in tests. I looked at [gomock][], but I wasn't a huge fan of the code generation required, and I didn't actually need expectations.

So I looked for a light weight alternative. The solution was to use <mark>interfaces</mark> in the production code, which allowed me to write a test double that satisfied said interface. That worked pretty well, and is the approach I continue to use today.

If [mocking with an interface](http://play.golang.org/p/9JUvbeBTAY) doesn't fit, Karl Seguin has an different approach, by [redefining functions in tests][injection]. [Gomock][] has continued to improve and may fit your situation, and there is a newcomer to the mocking scene, [withmock][].

Then there are specialized "mocking" tools. For testing HTTP client libraries, the standard library ships with [httptest][]. Will Norris explains how it works in [Testing in go-github][go-github].


## Coverage

Test coverage allows you to see which methods and conditional branches your test suite doesn't reach.

Andrew Gerrand and Rob Pike are developing [a new coverage tool](http://tip.golang.org/doc/go1.2#cover) for Go 1.2. To try it out, you'll need the Go 1.2 release candidate or [install Go from source](http://golang.org/doc/install/source). After you *go get* it, a lovely report in your browser is as simple as:

```bash
go test -coverprofile=c.out -covermode=count
go tool cover -html=c.out
```

If the new cover tool doesn't suit your fancy/needs, take a look at Andrew Wilkins' [gocov][]. Combine it with drone.io for CI to be able to hook it up to [Coveralls][]. See [goveralls](https://github.com/mattn/goveralls) for details.

Having played with both, I much prefer the new cover tools UI to [Coveralls][]. It's snappy and easy to navigate.

## Continuous Integration

If you're a fan of [Jenkins][], take a look at [go2xunit][], otherwise you may like one of these services. They all support Go and are <mark>free for open source</mark>.

*Note: If you previously read my [Releasing Open Source][os-release] article, most of this section will be familiar.*

### GoCI

[GoCI](http://goci.me/) is an [open source](https://github.com/zeebo/goci) continuous integration service by Jeff Wendling.

While more rudimentary than the other offerings, it is the only CI service focussed exclusively on Go. I'm curious what it could become if the Go community chips in.

### drone.io

[drone.io](https://drone.io/) is super quick to setup through the web interface, and it supports GitHub, BitBucket and Google Code. I'm impressed.

For those private projects, the pricing is quite competitive, and it so happens to be [written in Go](https://groups.google.com/forum/#!topic/golang-nuts/Lo7KP3rWP3o) too. The default build commands for Go [may need a little tweaking](https://gist.github.com/nathany/6402146).

### Travis CI

[Travis CI](https://travis-ci.org/) has been around longer than most, and has some nice features. Though it only integrates with GitHub, Travis will let you know if pull requests are *safe to merge.* It also allows testing against [older versions of Go or Go tip](http://about.travis-ci.org/docs/user/languages/go/).

### AppVeyor

[AppVeyor][] is a CI service for .NET developers. I approached them over Twitter with an interest in testing Go libraries on Windows. They added the option to use a PowerShell script for the build phase, installed Go on their servers, and have since [officially announced Go language support][appveyor-ann].

Here is the [source code][appveyortest] for a sample application with the necessary build script.

### wercker

[wercker](http://wercker.com/) looks to be the most flexible offering, though I found the whole thing a bit overwhelming. It allows the community to build custom boxes for any language or environment required, and includes [support for Go](http://devcenter.wercker.com/articles/languages/go.html).

They [blog frequently on Go](http://blog.wercker.com/tags/golang.html) deployment to Heroku and App Engine, code coverage, and more. Wercker is currently a free beta, but they plan to keep it [free for open source](https://hacks.mozilla.org/2013/02/wercker-continuous-delivery-made-easy-a-webfwd-project/).



## Cross-Platform Testing

Before contributing to [fsnotify][], I wanted a way to test my changes across the adapters for kqueue (BSD), inotify (Linux) and ReadDirectoryChanges (Windows). My development machine is running OS X, which currently uses the kqueue adapter (though support for FSEvents is in the works). How would I test the others?

### Vagrant

[Vagrant][] is a tool to script the creation of [VirtualBox][] VMs (as well as VMWare and other providers). 

When you run `vagrant up` with the Vagrantfile I wrote, it will download Linux and BSD *boxes* if necessary, install the DVCS tools and Go binaries, and configure GOPATH and other environment variables.

The way I have this setup, my `src/` folder is shared, so I can continue to use my editor and tools on OS X, while being able to issue commands to Linux and BSD VMs:

```bash
vagrant ssh linux -c 'cd gophertown/looper; go test ./...'
```

Each VM has its own `bin/` folder so `go install` won't stomp on the binaries created by your host OS or the other VM.

If you would like to try it out, there are more details in the [Vagrant Gopher][vagrant-gopher] repository. I welcome contributions, but be warned, you'll be dealing with Bash script embedded in Ruby. Lotsa fun!

### Windows

I'm not aware of a way to work with the Windows command line through Vagrant, so I had to set all this up manually.

You can [download Windows Virtual Machines][modernie] from Microsoft for free, but I went with a proper Windows 7 Professional license to avoid the constant "Genuine Windows" nagging.

Using VMWare Fusion, I shared my project folder which contains src, bin, and pkg. It becomes Z:\project on Windows. 

Fortunately, this doesn't cause conflicts, because binaries on Windows have an `.exe` extension and Go puts static libraries under `pkg\windows_amd64`.

With the Go binaries installed, I can use PowerShell to run my tests.

## Autotest

Many people like running tests directly in their editor or IDE. I prefer to have a separate Terminal window for running tests. 

This past February I wrote an autotest tool at a hackathon. [Looper][] uses [fsnotify][] to watch your file system. When you hit save it runs the tests for that package (folder).

Looper still has a long ways to go, but even at the start it had some nice features:

* Recursive watching, when you add a subfolder it will start watching it.
* It has a prompt that uses readline to manage history.
* ANSI colours indicate pass/fail.
 
I'm already thinking about automatically running tests across multiple VMs using Vagrant, and maybe adding one-off commands for shortcuts, like generating a coverage report. My goal isn't to replace Bash though, so there is much to consider.

The [Looper][] README maintains a list of alternative tools for all your autotest and file watching needs.

## PASS

Well, I hope you found this article helpful. If it was a FAIL, [please let me know](https://twitter.com/nathany) how I can improve it.

Comment on
[Go+](https://plus.google.com/104313268939103200754/posts/TJSwZWpLBfg),
[Hacker News](https://news.ycombinator.com/item?id=6465480),
[reddit](http://www.reddit.com/r/golang/comments/1ndodi/go_testing_toolbox/), or the
[Go Nuts mailing list](https://groups.google.com/forum/#!topic/golang-nuts/VUjD2LRwCTQ).

Related Articles:

* [Writing table driven tests in Go][tabledriven] by Dave Cheney
* ["Dependency Injection" in Go][injection] by Karl Seguin
* [Testing in go-github][go-github] by Will Norris
* [Code coverage with gocov and wercker][gocov-wercker] by Pieter Joost
* [Continuous Integration for Go Code](http://jmcvetta.github.io/blog/2013/08/30/continuous-integration-for-go-code/) by Jason McVetta


[testing]: http://golang.org/pkg/testing/
[tabledriven]: http://dave.cheney.net/2013/06/09/writing-table-driven-tests-in-go

[gocheck]: http://labix.org/gocheck
[PrettyTest]: https://github.com/remogatto/prettytest

[Jasmine]: http://pivotal.github.io/jasmine/

[Mao]: https://github.com/azer/mao
[Zen]: https://github.com/pranavraja/zen
[GoConvey]: https://github.com/smartystreets/goconvey
[Ginkgo]: https://github.com/onsi/ginkgo
[gomega]: https://github.com/onsi/gomega

[injection]: http://openmymind.net/Dependency-Injection-In-Go/

[withmock]: https://github.com/qur/withmock
[gomock]: https://code.google.com/p/gomock/
[httptest]: http://golang.org/pkg/net/http/httptest/

[gocov]: https://github.com/axw/gocov
[Coveralls]: https://coveralls.io/

[go2xunit]: https://bitbucket.org/tebeka/go2xunit
[Jenkins]: http://jenkins-ci.org/

[fsnotify]: https://github.com/howeyc/fsnotify

[Vagrant]: http://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
[vagrant-gopher]: https://github.com/gophertown/vagrant-gopher

[modernie]: http://www.modern.ie/en-us/virtualization-tools

[AppVeyor]: http://www.appveyor.com/
[appveyortest]: https://bitbucket.org/appveyor/test-go/src
[appveyor-ann]: http://blog.appveyor.com/2013/09/25/appveyor-update-and-new-pricing/

[gocov-wercker]: http://blog.wercker.com/2013/08/05/checking-code-coverage-with-gocov.html
[go-github]: https://willnorris.com/2013/08/testing-in-go-github

[os-release]: /os-release

[Looper]: https://github.com/gophertown/looper


+++
title = "Why Go?"
date = "2012-05-07"
revised = "2015-02-27"
keywords = ["golang"]
description = "Intrigued by the Go programming language."
+++

<figure data-tooltip="Photograph &copy; 2015 Nathan Youngman" data-tooltip2="Go gopher designed by Ren&eacute;e French">
    <img src="/images/gopher-swing.jpg" alt="Gophers on a swing" class="full">
    <figcaption>Getting into the swing of it.</figcaption>
</figure>

Go was [introduced](http://www.youtube.com/watch?v=rKnDgT73v8s) on November 10th, 2009 as a new system programming language with quick build times. Go's excellent tooling, <mark>elegant concurrency model</mark> and unique approach to object-orientation has captivated the attention of developers from compiled and scripting languages alike.

> "[Go will be the server language of the future.][tobi]" - Tobias Lütke, Shopify

Is there truth to Tobi's assertion? Before we can evaluate if Go is a panacea for modern web development, let's look at the trends, and consider what <mark>"the server language of future"</mark> should provide.

[tobi]: https://twitter.com/tobi/status/326086379207536640

### Real-Time Web

<mark>Ajax is so 2005.</mark>

Modern web applications provide real-time collaboration, with [Trello][] ([tech][trello_tech]) and [Asana][] ([tech][asana_tech]) being exemplary.

Some applications employ bolt-on solutions like Pusher. It works in a pinch, but feels analogous to a movie filmed in 3D vs. a movie with 3D added later.

> "People's expectations of any product they use are set by the *best* experiences they have." - Gene Smith, nForm

Go should address the C10K problem, being able to maintain connections with thousands of users from a single instance, without exhausting available memory.

[Trello]: https://trello.com/
[Asana]: http://asana.com/

[trello_tech]: http://blog.fogcreek.com/the-trello-tech-stack/
[asana_tech]: http://www.quora.com/Web-Application-Frameworks/What-is-Asanas-Luna-technology-framework

### Cloud Computing

There is a distinction between *the Cloud* and the data centre underneath it. The cloud offers servers on-demand. Turn a knob to handle traffic, or let auto-scaling turn the knobs for you.

When scaling up or restarting instances, some virtual machines take a long, long, long time to come to life. Scripting languages may load and parse every line of code.

Go applications should launch quickly so our servers respond immediately to increased demand. Idle instances, warmup requests, or other work arounds should be unnecessary.

### Multicore Performance

Multicore went mainstream in 2004 with the first x86 dual-core chips. Even with data centres using commodity hardware, we should expect [the number of cores to double][8core] on a regular basis.

Go should be scalable. We should not need to rewrite our software to take advantage of additional cores.

### Microservices

Today applications rely on a number of external services: databases, caches, search and message queues.

It is becoming more common to [build applications as a collection of microservices](http://info.thoughtworks.com/building-microservices-book.html). 

Go should use asynchronous I/O so that our application can interact with any number of services without blocking web requests.

###  The Fat Client Renaissance

With native mobile, HTML5 and Web Components, clients are doing more and servers are getting skinny. Modern apps are designed <mark>API first</mark>, built with the flexibility to support multiple clients.

Go shouldn't be tied to the *frameworks of yore*, but it should excel at writing APIs, with excellent support for JSON.


## Report Card

So how does Go stack up? Given this is an article on the merits of Go, pretty well! Let's compare Go with our favourite scripting languages.

### Async

Languages like Ruby and Python are afflicted by years of synchronous APIs. These APIs are off-limits when using evented programming based on coroutines.

> "For a while, there will be the classic/legacy synchronous APIs and the new asynchronous APIs... merging them together eventually, and that will take years." Guido van Rossum, [Pycon 2013 Keynote][Tulip]

At least Python is on the right path.

Node.js scores better, especially when coupled with a library like async.js.

[Tulip]: http://pyvideo.org/video/1667/keynote-1

The Go runtime ensures that any one goroutine isn't blocking the others. Code is written in a synchronous style while being fully non-blocking. There is no need for callbacks, so there is no "callback hell."

### Multicore

What happens if we want to support thousands of connections and still take advantage of multicore? We could combine threads and  coroutines (Ruby calls them fibers, Python uses generators). Or mix callbacks and processes, using Node.js with the [Cluster][] module.

Go has one straightforward model. It multiplexes <mark>goroutines</mark> onto OS threads (like Erlang), and stacks grow as needed. Go not only addresses the C10K problem, it blows past it! (C1000K)

And don't forget that Python and Ruby (MRI) still have the GIL/GVL. Go doesn't have an interpreter, nor a virtual machine, so no global lock. Multicore FTW!

[Cluster]: http://nodejs.org/api/cluster.html

### Concurrency

Ruby's support for concurrency is left to users of the language:

>"I don't consider myself as the concurrent guy, I don't think I can make the right decision for an actor library. I'd rather ask you guys to propose and discuss a future standard concurrency model." - Yukihrio 'Matz' Matsumoto, [Ruby Conf 2012 Q&A][matz_talk]

To that end, Tony Arcieri's [Celluloid](http://celluloid.io/) steps in. But providing solid support for concurrency still [requires involvement from the language/runtime][ruby_needs].

[ruby_needs]: http://tonyarcieri.com/2012-the-year-rubyists-learned-to-stop-worrying-and-love-the-threads

[matz_talk]: http://www.youtube.com/watch?v=B7vCuNaqT7k

Go channels provide a concurrency primitive comparable to the actors model. With actors we name the endpoints (mailboxes), whereas channels are the conduit. 

Want to pass a channel over a channel? Go for it!

### Static Binaries

JVM-based languages are saddled with slow startup times. This doesn't just affect auto-scaling and server restarts. It can also be crippling in development.

Go applications compile quickly and launch immediately.

## The Best of Both Worlds

So Go is ready for the future, <mark>but is it fun?</mark> In my opinion, yes!

Go provides type inference, hash maps (dictionaries), variable-length arrays, methods on any user-defined type, and implicitly satisfied interfaces. All without diverging far from the familiar syntax and semantics of C-like languages.

> "Go is closer in spirit to C than to any other language," - Mark Summerfield, [Programming in Go](http://www.informit.com/store/programming-in-go-creating-applications-for-the-21st-9780321774637).

It compiles quickly without makefiles, integrates with Git for distributed package management, and reformats code with `gofmt`. Compilation makes a certain class of tests unnecessary, and code completion works really well thanks to `gocode` built into [GoSublime][] and [vim-go](https://github.com/fatih/vim-go) .

Performance critical code can be optimized without the need to mix C with another language. And [we have gophers][gophers]! What could be more fun than that?

Go strikes a balance between dynamic and statically compiled languages. It's fun and efficient.

The best way to know if you'll like Go is to dive in and <mark>get some first-hand experience</mark>. So think up a small project and try it for yourself!

[GoSublime]: https://github.com/DisposaBoy/GoSublime
[gophers]: https://plus.google.com/photos/104313268939103200754/albums/5876555195702165569

[case]: https://gist.github.com/ungerik/3731476

## Reboot

It's very difficult to change a programming language once widely adopted. Even if the syntax/semantics could be hugely improved, too much code would break.

> "The C++ community has a love-hate relationship with the language. We love what it can do and we hate that it's a mess." - Rivorus

<mark>A new language is a fresh start.</mark>

Go is designed for clarity. It can be terse so long as the meaning is clear. In Go, ambiguity is avoided, even if it means increased verbosity.

> “Go has been described by several engineers here as a WYSIWYG language. That is, the code does exactly what it says on the page.” - Peter Bourgon, [Go at SoundCloud][soundcloud]

The Go [specification][] is easy to digest. Mastery isn't beyond our reach.

[refinements]: https://bugs.ruby-lang.org/issues/4085
[soundcloud]: http://backstage.soundcloud.com/2012/07/go-at-soundcloud/
[specification]: http://golang.org/ref/spec



## Questions

**Should I learn Go?**

It's always good to learn and stretch your mind. Even if learning Go never [lands you a job](http://www.golangprojects.com/), you will gain new perspectives when using other languages. For example, learning Go interfaces may give you a new appreciation for duck types in Python and Ruby.

I began learning Ruby on Rails over Christmas 2005, well before I could find any jobs using it. Ten years later I can safely say it was [a good investment](https://stackoverflow.com/story/nathany).

**Should I build my SaaS startup on Go?**

A startup needs to run lean and prove out the idea. If you're building a web app, you will find a much quicker time-to-MVP using a framework like Ruby on Rails or Django.

I would still recommend [looking into Go](http://startupedmonton.tumblr.com/post/107921476571/why-tech-startups-should-look-at-go) and how it could benefit your company.

**Is there a web framework like Rails or Django for Go?**

Not really. I recommend learning the standard library and [Gorilla Web Toolkit][gorilla]. They provide many of the facilities you would find in Sinatra or Flask. There is a good [tutorial][] that starts out with the standard library and adopts Gorilla.

If you must have a full stack web application framework, [Revel][] is as close as it gets.

[gorilla]: https://www.gorillatoolkit.org/
[tutorial]: https://web.archive.org/web/20120804000251/http://shadynasty.biz/blog/2012/07/30/quick-and-clean-in-go/
[Revel]: https://revel.github.io/

**This all sounds great, but where can I find a second opinion?**

Erik Unger has compiled a list of articles that make [The Case For Go][case].

*Comment on [Hacker News][HN], [reddit][], or [LinkedIn][].*

[reddit]: http://www.reddit.com/r/golang/comments/1eapil/go_will_be_the_server_language_of_the_future/
[HN]: https://news.ycombinator.com/item?id=5703097
[LinkedIn]: http://www.linkedin.com/groups/Go-will-be-server-language-3712244.S.240593516

[Go Programming Language Phrasebook]: http://www.informit.com/store/go-programming-language-phrasebook-9780132919012

[8core]: https://blog.linode.com/2013/03/18/linode-nextgen-the-hardware/

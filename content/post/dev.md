+++
title = "🕸️ My Journey Into Programming"
description = "How I fell into web development, a memoir."
date = "2014-03-30"
revised = "2025-04-15"
keywords = ["self-taught", "web developer", "story", "memoir"]
+++

Hi, I'm Nathan 👋

A self-taught developer from Canada 🇨🇦 and author ✍️ of [Get Programming with Go][programminggo] (Manning Publications, 2018).

What follows is a personal account of becoming a programmer and my career as a web developer.

## Childhood

<img src="/images/atari.jpg" alt="Playing Atari Games" class="right" />

I grew up on Lego, Dr. Seuss, and Berenstain Bears in a tiny Canadian 🇨🇦 village. After my parents' divorce, an Atari Computer found its way into our home. As far as I knew, its sole purpose was to play video games. 🕹

Then one day the school library held a book fair where I found a colourful book filled with short BASIC programs. I don't recall the title, but it was likely one of the books published by Usborne.

When my Dad saw my interest, he gave me a coil-bound manual for BASIC and let me use his [Kaypro](https://en.wikipedia.org/wiki/Kaypro) IV on the weekends. It came with several games, including interactive fiction like *Colossal Cave* and *Hitchhiker's Guide to the Galaxy*, some of which were distributed with BASIC source code.

The first computer I owned was a Commodore 16 from a garage sale, tape drive and all! I wrote a historic text adventure where your character wandered Israel in search of Jesus. It wasn't very sophisticated or well-researched, but one of my first computer projects.

## Youth

By junior high, our school upgraded the lab from Apple IIs to amber-screened XTs. Thankfully there was one computer with a colour screen, plus our neighbours let me use their PC after school. Progressing from GW-BASIC to QBasic, I wrote my own remakes of *[Star Traders][star-traders]* and *Atlantis.*

[star-traders]: https://www.zap.org.au/projects/trader/

In addition to lawn-mowing income, I earned money tutoring people with computers. When I had enough saved, I went to Programmers Guild (a computer store in the city) to buy Turbo C 2.0. Unfortunately Turbo C wasn't the most approachable:

* A simple syntax error would dump a dozen seemingly unrelated errors.
* I found the <abbr title="Integrated Development Environment">IDE</abbr> confusing, the keys reminded me of WordStar!

[QuickBASIC](https://en.wikipedia.org/wiki/Quickbasic) 4.5 turned out to be a much better investment.

While in Grade 9, my Mom helped me pay for a correspondence course from <abbr title="National Radio Institute">NRI</abbr> (McGraw-Hill Education). The three-year course covered computer programming in five languages and came with a 386 SX.

Resolved in my future career path, I wrote a letter to
Nintendo and received a genuine response encouraging me in my studies to become a programmer.

<img src="/images/firebirds.png" alt="Firebirds" class="right">

So, inspired by Galaga and other <abbr title="Shoot 'em up">SHMUPs</abbr>, my brother and I set out to make **Firebirds**. It was a complete game, with title screens, difficulty levels, 2-players, sound effects, and both mouse and keyboard control. It wasn't exactly [Raptor](https://en.wikipedia.org/wiki/Raptor:_Call_of_the_Shadows) though. It had timing issues on faster computers and the "scrolling" and collision system were amateurish.   We distributed it through local Bulletin Board Systems (BBS).

My high school needed an application to do timed typing tests, so I wrote one. The first version of **Trial Type** was a DOS application written in QuickBasic. I registered **Lynx Software** as a sole proprietorship and licensed the software to a number of schools.

QuickBasic also allowed me to build a custom database for an alarm installation company. I was proud of the text-based UI, but unfortunately I knew nothing of B-trees. It got really slow with a lot of data.

<img src="/images/trialtype.gif" alt="Trial Type 2" class="right">

Eventually I gave Turbo C another try, using DOS `edit` and the command-line compiler instead of that unintuitive IDE. Later, Borland C++ allowed me to make a Windows version of Trial Type and the less successful **Graphematics** graphing calculator.

Apps were making me money, but I still really wanted to make games. By now I was using C and Assembly and experimenting with Mode X (320x240) and VESA modes. <mark>640K really wasn't enough.</mark> I was directly addressing EMS/XMS memory, until I bought [Watcom C/C++](https://en.wikipedia.org/wiki/Watcom_C) so I could use DOS4GW. It was wondrous!

The Internet turned out to be quite useful. I was able to assemble a team of artists to work on a real-time strategy game entitled **Galaxy**. We got a prototype up and running, but it lost momentum. The rise of DirectX brought the question of whether to continue or switch technologies. In the end, the prototype was as far as we got.

## Early Career

At that time the web was still relatively new. I remember reading the HTML 2.0 specification, one of the few resources available to learn it.

<img src="/images/hp.jpg" alt="HyperProcess" class="right">

It wasn't long before I wrote a command-line tool to make HTML easier to work with. **HyperProcess** was a cross-platform preprocessor for HTML written in C. It supported file includes and other features, while also serving to lint and minify my HTML. Think static-site generator sans-Markdown, or [Jamstack][] before the rise of JavaScript and RESTful APIs.

HyperProcess came in handy at my first web development job, but at my next job I discovered Server Side Includes and eventually ColdFusion. By the turn of the century, familiarity with SQL, ColdFusion, and JavaScript made for a platform where I could do _real_ programming. I stuck with ColdFusion for eight years across [three jobs][resume].

Though I didn't know it at the time, ColdFusion, Java, JavaScript, PHP, and Ruby were all released in 1995 -- the same year I graduated from High School. Impeccable timing for a budding web developer.

[Jamstack]: https://jamstack.org/

## All Aboard

I was in Europe on sabbatical in 2005 when I first heard of *Ruby on Rails*. The new web framework enticed me with its <abbr title="Object-Relational Mapper">ORM</abbr> and organized file layout. To top it off, my Dad worked for 🛤 <abbr title="Canadian National Railway">CN</abbr> when I was young, so anything remotely associated with trains was appealing.

After returning from Bible school to celebrate Christmas, I found a copy of _Agile Web Development with Rails_ (Pragmatic Bookshelf, 2005) at the local computer bookstore. I did some freelancing until I was hired by a Christian non-profit to build an app with Ruby on Rails. Thus I transitioned my career, with Ruby becoming my primary language for the next eight years, across another [three jobs][resume].

## Scaling Up

When Google introduced the [Go Programming language][go] in 2009, I [watched the video][go-video] and tried it out. But I didn't dig in until 2011. Inspired by a colleague's experience, I read the rough cut of _The Go Programming Language Phrasebook_ (Addison-Wesley Professional, 2012) over a Christmas break.

The following summer I was between jobs with time on my hands. One of my experiments was a Go binding for OpenGL 3.2 Core Profile, which I called [Mantle][] (this was a year before AMD released their low-overhead API of the [same name][amd], no relation). It was fun playing with a C-like language again.

[go]: https://go.dev/
[go-video]: https://www.youtube.com/watch?v=rKnDgT73v8s
[Mantle]: https://github.com/nathany/mantle
[amd]: https://en.wikipedia.org/wiki/Mantle_(API)

That year I landed a job at an early-stage startup, becoming one of the first employees. We were building a Ruby on Rails app and deploying it to Heroku, but scaling was expensive. We upgraded our application server to Unicorn, which uses a process model. The application consumed ~300MB of memory, so one Heroku dyno (1GB) could handle 3 simultaneous requests. Better than only one, but still not great. Eventually I moved the app to [Puma][], which helped improve matters, but I knew Go would be much more efficient.

Go, APIs, and microservices were all the [hype](/why-go), but the monolith at work just grew bigger and bigger. While I couldn't use Go at work, I did invest my own time into [open][fsnotify] [source][looper] [projects][s3up] and started the [Edmonton Go][edmontongo] meetup in 2014.

Later that year I took a second job, working a few hours a week as a contractor for a 🦊 [small consulting company][aai]. My task was to transition performance-sensitive functionality from Ruby to Go, interacting with Ruby through JSON APIs, message queues like Sidekiq, or Redis pub/sub. Projects included Apple push notifications ([open source][buford]), streaming file uploads to S3, and a websockets proxy.

[Puma]: https://puma.io/
[fsnotify]: https://github.com/fsnotify
[s3up]: https://github.com/nathany/s3up
[looper]: https://github.com/nathany/looper
[edmontongo]: https://github.com/edmontongo/

[aai]: https://agileanimal.com
[buford]: https://github.com/RobotsAndPencils/buford

## Pay It Forward

In addition to open source and the Go meetup, I wrote a handful of [blog](/why-go) [posts](/good) on Go. That attracted the attention of acquisition editors from a few well known publishers.

While considering the opportunity, I thought of all the people and authors who got me to where I am, starting from the book fair at the school library so many years ago.

Writing and publishing a book was a chance to "pay it forward" -- an opportunity to inspire and educate the next generation of developers.

[Get Programming with Go][programminggo] was published in 2018. It's a beginner's guide to the Go programming language, focused on the language itself. Every example and exercise runs in [The Go Playground][playground], without first needing to install tools or learn about the Terminal or Command Prompt. The exercises and cartoons are designed to keep the whole experience fun and light-hearted.

Writing a book was far from easy, but it was extremely fulfilling to hear from programmers who were teaching a son or daughter how to code by going through *Get Programming with Go*.

[programminggo]: https://bit.ly/getprogrammingwithgo
[playground]: https://go.dev/play/

## Alchemy

In early 2016, I became an employee at the 🦊 [small consulting company][aai] I had been contracted with previously.

We had just discovered 🧪 [Elixir][] and [Phoenix][]. Built on [Erlang/OTP][erlang], it promised concurrency and efficiency similar to Go, while Phoenix and Ecto provided the niceties of Ruby on Rails. I wasn't sold at first, having come to appreciate Go's simplicity, static type checking, and fast compiler. Still, I enjoy learning, so learn I did.

Elixir has kept me busy for the better part of over 9 years, building products for [several companies][resume].

[Elixir]: https://elixir-lang.org/
[Phoenix]: https://www.phoenixframework.org/
[erlang]: https://www.erlang.org/


## 28 Years Later

When I began my career, I didn't know the web would become an open platform for building apps, or that the <abbr title="Software as a Service">SaaS</abbr> model would become a dominant way to distribute software. I fell into web development, and it worked out incredibly well, despite [a few mistakes][28] along the way.

What comes next? That's [another story][continue].

Related:

* [Résumé][resume]

[copia]: https://copiawealthstudios.com/
[resume]: /resume
[continue]: /continue
[28]: /28

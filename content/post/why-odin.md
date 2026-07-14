+++
title = "🔱 Why Odin?"
description = "First impressions of the Odin programming language."
date = "2026-07-14"
keywords = ["Odin", "code", "programming", "C alternative", "data oriented design", "Joy of Programming"]
+++

When I wrote [Why Go?](/why-go) in 2012, I was struggling to get a Ruby on Rails web app to handle more than 3 concurrent requests. 😅 Go was a revelation! And it continues to be one of the top choices in that space.

Today I'm [retired](/fire) from web development, and pursuing a childhood dream to make video games. I want to get back to the low-level programming I did in my teens, and [Odin][] is one of several languages I've been considering.

## A worse Go?

The Odin language feels familiar, borrowing liberally from Go's syntax and design[^1].

* Pascal-style declaration syntax: `x := 10`
* Zero is initialization (ZII)
* Multiple return values, named return values, and even naked `return`
* Built in dynamic arrays, slices, strings and runes
* Built in maps with the familiar `make(map[string]int)` and `elem, ok := m[key]` syntax
* Struct fields tags: ``struct {name: string `json:"username"`}``
* Nil pointers and the `new(int)` builtin
* Defer keyword (but Odin defers to the end of a scope)
* Directories are packages

The similarities are bound to draw comparison, but while Go strived for simplicity, Odin is _even simpler._ The things I found most intriguing in Go simply aren't in Odin, and there are _no plans_ to add them. There are no language primitives for concurrency and no built in green threads (channels, select, goroutines). Odin doesn't have duck typed interfaces, nor methods on any type. There are lambdas, but no closures. It's an imperative language through and through. 

Worst of all, Odin doesn't even have a cute mascot! 😜 

But I think comparing Odin to Go is the wrong framing. Besides, each of those features has tradeoffs. It isn't strictly better or worse.

## C alternative

Odin bills itself as a _C alternative for the Joy of Programming_. It's one of [many](https://c3-lang.org/) [languages](https://ziglang.org/) that sand down C's rough edges, while avoiding the complexity of C++, Rust and Swift. Each language will appeal to different people, but all these C alternatives have manual memory management with custom allocators.

## Manual memory management

I didn't go looking for manual memory management.

Garbage collection didn't prevent games like Minecraft (Java), Stardew Valley (C#), CrossCode (JavaScript) or Meg's Monster (Go) from being successful. Tiny Glade and (the) Gnorp Apologue are two of several games written in Rust. They fought the borrow checker and won. ⚔️

That said, memory safety isn't the most critical factor for my use case -- small scope, single player entertainment (games).

### Mutation xor sharing

In Odin, _you are the borrow checker._ 😅

I say that jokingly, but it's also true. The compiler won't stop you from mutating the world under your feet. Imagine an update function that runs on every entity, updating its position and state. It can also look at the state of the world, including all the entities contained within it.

```odin
update :: proc(entity: ^Entity, world: World) {
	// do update
}
```

See any problem with this design? Okay, what if we _know_ this game play logic is single-threaded, any problems now?

If the entities interact, those interactions are order dependent. For example, does a monster dodge the bullet by being the first to move, or does the bullet move first?

A borrow checker would see the mutable and shared reference to the same world state and reject it. Maybe a better design would be to double buffer the world data (previous and current frame) or store up the writes to apply at the end. Or maybe entities should be split up (monsters, bullets) and resolved in a defined order. For some, being forced to find a better design [is a good thing](https://www.youtube.com/watch?v=aKLntZcp27M). Others [value iteration](https://loglog.games/blog/leaving-rust-gamedev/) over all else, quickly prototyping a rough implementation without fighting the compiler.

Rust's borrow checker, for all its worth, can't distinguish between a multi-threaded production server susceptible to adversarial attacks and a single-threaded throw-away prototype.

### The low hanging fruit

Spatial memory bugs (e.g. buffer overflows) can be avoided with bounds checking, which Odin provides by default. Bounds check elimination appears to be manual right now (`#no_bounds_check`), but it's starting from the right defaults. Odin also initializes memory to zero. These are easy wins for a new language.[^2]

### Enter the arena

Temporal memory bugs (e.g. use after free) are more difficult, and do require some discipline. Arena allocators can help. 

For example, in a game loop, a `temp_allocator` can be used for any allocations that happen during the frame. At the end of the frame, that arena is cleared for reuse. This reduces calls to the kernel for heap allocations, improving performance. Perhaps more importantly, it groups together all the values with the same lifetime (a single frame). When applied broadly (the lifetime of a level, a frame, etc.), this approach can help reduce the likelihood of temporal memory bugs.

If you want a deep dive, check out Ryan Fleury's [talk][arena-talk] and [article][arena] on arena allocators.

One idea Fleury describes is to reserve a large contiguous block of virtual address space, but without requiring all the physical memory until committed. The [mem/virtual](https://pkg.odin-lang.org/core/mem/virtual/) package in Odin can be used for exactly that purpose.

### Relocation

Odin includes some specialized data structures that don't relocate their data, making it safer to hold pointers into them. 

Fixed capacity dynamic arrays (`[dynamic; 100]int`) are a recent addition. They behave like a dynamic array (`append(&x, 123)`, etc.), but they can't grow beyond their initial capacity.

The [xar](https://pkg.odin-lang.org/core/container/xar/) package is like a dynamic array, but it grows in chunks instead of relocating the data. And other containers like [handle_map](https://pkg.odin-lang.org/core/container/handle_map/) can be layered on top when needed.

### Generation

Though not provided directly by Odin, generational indexes can be used instead of long-lived pointers. As an added benefit, they are easy to serialize to disk (save game) or the network. 

Imagine a monster in a game that is chasing another entity. Instead of an `^Entity` pointer, store an index (often called an ID) into the world's entity array. If the entity being chased is destroyed, the slot in the array could be repurposed for a new entity. A generation is a simple counter that is used to verify that the referenced entity is still the same one.

So there are many ways to reduce the risk of dangling pointers and the like.

### Sanitizers

In addition to arena allocators, there are runtime tools. Odin's tracking allocator and ASAN (`-sanitize:address`) can help find memory bugs. But even with these tools, some memory bugs may slip through. Will good technique and test coverage save me? Time will tell.

## Data-oriented design

Odin calls itself "the Data-Oriented Language for Sane Software Development" -- so what is data-oriented?

Programs are made up of data and transformations to that data. If you know the data and how it's accessed, and you understand the target hardware, then it's possible to write software that runs better on that hardware.

When I was a teenager, using a lookup table to avoid mathematical operations (like trigonometry) was a good idea. Today we have a lot more <abbr title="Random Access Memory">RAM</abbr> and it's somewhat faster. But CPUs are much, much faster. CPUs are so fast at math, that reading from main memory could take an order of magnitude longer than just recalculating the math. 

Since memory is relatively slow, CPUs have levels of progressively larger and slower caches (e.g., <abbr title="level 1">L1</abbr>, L2, L3). When data isn't in a cache (a cache miss), the CPU looks at the next one, and eventually main memory.

Today data-oriented design centres on economical use of memory (the fastest caches are small), and organizing data based on how it's accessed. 
There are [several](https://www.youtube.com/watch?v=WwkuAqObplU) [tricks](https://www.youtube.com/watch?v=IroPQ150F6c) that are worth knowing, but the feature unique to Odin and some other C alternatives is called structure of arrays.

### Structure of arrays

For this example, we have a game with an array of entities:

```odin
Vector2 :: struct {x, y: int}

Location :: struct {
	position: Vector2,
	velocity: Vector2,
}

Entity :: struct {
	location: Location,
	health: int,
	// etc. potentially a lot of data
}

entities: [10000]Entity
```

We know that our physics system only needs a subset of all the entity data, so we collected it into a `Location` struct. That way we can just pass `do_physics(&e.location)`.

```odin
for &e, i in entities {
	do_physics(&e.location)
	fmt.printfln("render %v: (%v, %v)", i, e.location.position.x, e.location.position.y)
}
```

But even though we're only passing the data the physics system needs, the data is still laid out in memory one `Entity` after another. That means fewer `Locations` fit into the cache than if we had a separate `[10000]Location` array. If it's a large amount of data, it could result in more cache misses and slower performance.

We could reorganize our code by hand, but Odin provides a `#soa` directive, which can modify the memory layout for us.

```odin
entities: #soa[10000]Entity
```

Effectively, those four characters changed our memory layout to a struct of arrays, like this:

```odin
EntitySoA :: struct {
	location: [10000]Location,
	health: [10000]int,
	// etc.
}
```

All with no other code changes! By grouping together all the data that our physics system needs, we can take better advantage of the CPU cache.

## Linear algebra

Odin doesn't support operator overloading, but it has built-in vectors, matrices, and quaternions. Impressive! It supports both column major and `#row_major` matrices. 

I need a math refresher before I dig into it myself. In the meantime, I asked Claude Fable 5 to scout ahead of me by porting over source code from books on DirectX 11, [DirectX 12](https://github.com/nathany/d3d12book_2ed/tree/odin/odin_port), Metal and Vulkan. There may be a few small gaps in Odin's `math/linalg` vs. DirectXMath and GLM, but overall it seemed comparable to popular math libraries in other languages.

Aside: While porting _Metal by Tutorials_ from Swift to Odin, Claude Fable 5 uncovered a bug with [passing SIMD types over FFI](https://github.com/odin-lang/Odin/issues/7010), which I reported. It was promptly resolved by a member of the Odin community.

## Vendor

Odin ships with bindings for DirectX 12, DirectX 11, Metal, Vulkan and more. Windows COM and Objective-C APIs feel like part of the language and are fairly pleasant to use. Defer helps with manual cleanup, as there's no <abbr title="Resource Acquisition Is Initialization">RAII</abbr> like C++ or Rust.

Other C bindings are included as well, such as [Box2D](https://box2d.org/) and [raylib](https://www.raylib.com/). There can be value in depending on mature libraries, with stable APIs and logic bugs fixed over many years. 

Having all these libraries bundled makes it quick to get up and running, say, to learn a graphics API from a book or tutorial. 


If there's a C library not provided in vendor, there are tools to [generate bindings](https://github.com/karl-zylinski/odin-c-bindgen). Odin can link in foreign libraries, but those libraries may require CMake or similar to build. Odin doesn't call out to C compilers. This is fine by me, as I have no desire to port and maintain third-party build scripts in Odin.

In Odin, _you are the package manager._ 😅 There's no official tool that pulls in dozens of transitive dependencies with a single line. It's part of the ethos to vet external packages more carefully. For my needs, this too is fine.

## Compile times

In terms of developer experience, one thing Go got right is compile times. Odin doesn't have incremental compilation and its backend is [LLVM][], so it must be slow, right? We won't know for sure until _we put it to the test!_

Presenting the `-show-timings` data provided by the Odin compiler (dev-2026-07a), based on multiple runs with the initial warm-up discarded.
* Windows 11 with an AMD Ryzen 9700X (8c/16t). Odin bundles [RAD Linker][RAD] (0.9.24 ALPHA), which was 20-50ms faster than MSVC.
* macOS Tahoe with an M1 Max (8P+2E) with the default linker.

### Default build
Default optimization level of `-o:minimal`, no debug info, and `-linker:radlink` on Windows. 

| Platform | Project                   | LoC  | Parsed       | LLVM   | Link   | Total      |
| -------- | ------------------------- | ---- | -----------: | -----: | -----: | ---------: |
| Zen 5 8c | Karl2D Snake              | 14K  | 141K         | ~90ms  | ~32ms  | ~230ms     |
| Zen 5 8c | Cat & Onion               | 21K  | 141K         | ~445ms | ~32ms  | ~575ms     |
| Zen 5 8c | Odin Core Library + Tests | 270K | 282K         | ~1s    | ~65ms  | ~1.3s      |
| M1 Max   | Karl2D Snake              | 14K  | 132K         | ~140ms | ~170ms | ~420ms     |
| M1 Max   | Cat & Onion               | 21K  | 134K         | ~615ms | ~180ms | ~900ms     |
| M1 Max   | Odin Core Library + Tests | 270K | 278K         | ~1.6s  | ~200ms | ~2.1s      |

* LoC: Lines of code reported by `cloc`, excluding blanks/comments.
* Parsed: lines parsed by the front-end. Includes core packages/libraries and blanks/comments, but excludes files tagged for other platforms. Reported by `-show-more-timings -show-debug-messages`.
* Odin Core Library + Tests is a *build* of Core and its tests (`-build-mode:test`), but we're not evaluating test execution time.

### Debug build
The `-debug` flag for PDB/DWARF debug info, defaults to `-o:none` optimization. With `-linker:radlink` on Windows.

| Platform | Project                   | LoC  | Parsed       | LLVM   | Link   | Total      |
| -------- | ------------------------- | ---- | -----------: | -----: | -----: | ---------: |
| Zen 5 8c | Karl2D Snake              | 14K  | 141K         | ~145ms | ~65ms  | ~320ms     |
| Zen 5 8c | Cat & Onion               | 21K  | 141K         | ~515ms | ~65ms  | ~680ms     |
| Zen 5 8c | Odin Core Library + Tests | 270K | 282K         | ~1.6s  | ~105ms | ~1.9s      |
| M1 Max   | Karl2D Snake              | 14K  | 132K         | ~190ms | ~235ms | ~540ms     |
| M1 Max   | Cat & Onion               | 21K  | 134K         | ~790ms | ~235ms | ~1.1s      |
| M1 Max   | Odin Core Library + Tests | 270K | 278K         | ~2.4s  | ~400ms | ~3.2s      |

### Findings

* As suspected, LLVM <abbr title="Intermediate Representation">IR</abbr> emit dominates the time in larger projects (~80%).
* Odin build times scale with your largest package, not just your total line count. For development builds (`-o:none` or `-o:minimal`), Odin defaults to `-use-separate-modules`, which emits LLVM IR for each package in parallel.
* The largest package in Cat & Onion (game) emits 5x the LLVM IR of the largest package in Snake (karl2d), as determined with `-keep-temp-files`. This explains the gap in compile times in terms of intermediate output. Keeping packages below 30K LoC should help ensure subsecond build times (on my hardware), with some caveats (below). 
* Core Library + Tests emit 69 MiB of LLVM IR, but spread across 213 packages. The package emitting the largest amount of LLVM IR (14.5 MiB) is the biggest determinant for build time, with the majority of packages emitting far less.
* Monomorphized IR concentrates in the defining package's module, which avoids duplication, but increases the likelihood of a few modules dominating compile time. This is more likely to impact test builds (the flags package tests 60 variations). Moderately slower test builds may be negligible vs. the time running the actual tests.
* Heavy use of <abbr title="parametric polymorphism">parapoly</abbr>, `#load` and reflection (e.g. fmt, json) are things to keep an eye on (with `-build-diagnostics`).
* As Jakub Tomsu [notes](https://jakubtomsu.github.io/posts/odin_comp_speed/), keeping procedure bodies small when using parapoly can help.
* Debug builds add ~100ms to ~600ms on Windows and up to ~1.1s on macOS, despite doing less optimization.
* Overall the Odin compiler scales near-linearly. The front-end roughly tracks lines parsed, while the backend tracks the IR of the largest package in unoptimized (or `-o:minimal`) builds.

I'm happy with these results, especially with my Zen 5 system.

[LLVM]: https://llvm.org/

### Commands

This is the basic command I used to arrive at these numbers (tested in Git Bash on Windows).

```sh
odin build "$HOME/src/github.com/karl-zylinski/karl2d/examples/snake" \
  -linker:radlink -show-timings -out:snake.exe
```

Odin Core + tests provided a large open source codebase as another datapoint.

```sh
odin build "$HOME/src/github.com/odin-lang/Odin/tests/core" \
  -all-packages -build-mode:test -linker:radlink -show-timings -out:core-tests.exe
```

[RAD]: https://github.com/EpicGames/raddebugger#the-rad-linker

## Hot code reloading

Once we have quick build times, hot code reloading provides the ultimate in fast iteration. The goal is to apply code changes without restarting the running app or game.

One common approach is to split a game into two parts: an executable and a shared library (dll/dynlib/so). Launch the game, tweak game play logic or user interface code, then recompile the shared library. Have the main executable reload the shared library so code changes are reflected instantly.

For this to work, the memory the game play code is using must be handed off to the new shared library. The game continues on from where it left off. Odin doesn't provide hot code reloading out of the box, but the focus on plain old data and procedures, along with manual memory management make Odin a natural fit. It keeps the entire solution relatively simple.

There are of course some caveats and gotchas to look out for. To get started, take a look at Karl Zylinski's [article on hot reloading][hot-reload].

[hot-reload]: https://zylinski.se/posts/hot-reload-gameplay-code/

## Stability

The recent [Odin 2027](https://www.youtube.com/watch?v=dLPAqXi9In0) announcement is Odin's 1.0 moment. That said, Odin has been fairly stable for a while now.

As a smoke test, I upgraded the 2024 source code from Cat & Onion (available on [Itch][] 🤑) to the latest Odin dev-2026-07a compiler and Raylib 6.0. The most significant changes were to `core:os`, which were [telegraphed](https://odin-lang.org/news/moving-towards-a-new-core-os/) well-ahead of time. The other big changes related to Raylib, particularly HiDPI.

The later could be considered a potential downside of bundling vendor bindings with the compiler. They move in lockstep with compiler releases. But it's easy enough to copy the files from vendor to lock in an old library, or if modifications are necessary to jump to a newer version than Odin provides.

[Itch]: https://zylinski.itch.io/cat-and-onion

## Conclusion

There are a number of other features and that I didn't cover. Enums (tagged unions), the context system (which is unrelated to Go's context), `or_return` for error handling, conditional compilation (`when`) and more.

So far, I've found Odin _pleasant to read and write_ and the compile times are quite reasonable. The vendor libraries, built-in linear algebra, `#soa` and allocators are all nice to have. Hot code reloading is straightforward. Manual memory management and the bog-standard threading model make <abbr title="Foreign Function Interface">FFI</abbr> simpler. While not everyone's cup of tea, it's a good fit for my use case.

Is it perfect? If I wanted to spend 10 years making my own language, I'm sure I would add or remove a few things. But there are no deal breakers for me.

The reference documentation is incomplete in places, and there are gaps in the core library (e.g. saving PNGs). These are things being worked on for Odin 2027, which isn't that far off.

The tooling is good, but could always be a bit better. Daniel Gavin's [ols][] language server includes a code formatter, but it allows configuration and another formatter exists. Not the single standard that benefited humans and tooling alike in the Go community. There is `odin test` but I'm not aware of a test coverage tool, built-in fuzzing or integrated profiling. Fortunately it's feasible to use existing C/C++ debuggers and profilers, and I can get by without code coverage.

The compiler could always optimize a little better or be a little faster. But isn't that always the case?

Overall, Odin feels well suited for the kind of code I want to write. If you're intrigued, take a gander at the Odin [overview][]. After that, I highly recommend Karl Zylinski's book, [Understanding the Odin Programming Language][odinbook]. Not only is it a good book, he has kept the content in step with the language. I'm currently making my way through it.

This has been my first impression. Why I think Odin is worth my time, and may be of interest to you. More to come.

[^1]: Just as Go takes inspiration from previous languages.
[^2]: A newish language. Odin is 10 years old.

[arena-talk]: https://www.youtube.com/watch?v=TZ5a3gCCZYo
[arena]: https://www.dgtlgrove.com/p/untangling-lifetimes-the-arena-allocator

[overview]: https://odin-lang.org/docs/overview/
[odinbook]: https://odinbook.com/
[ols]: https://github.com/DanielGavin/ols
[Odin]: https://odin-lang.org/

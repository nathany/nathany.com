+++
title = "🔱 Why Odin?"
description = "First impressions of the Odin programming language."
date = "2026-07-16"
keywords = ["Odin", "code", "programming", "C alternative", "data oriented design", "Joy of Programming"]
+++

When I wrote [Why Go?](/why-go) in 2012, I was struggling to get a Ruby on Rails web app to handle more than 3 concurrent requests. 😅 Go was a revelation! And it continues to be one of the top choices in that space.

Today I'm [retired](/fire) from web development, and pursuing a childhood dream to make video games. I want to get back to the low-level programming I did in my teens. 

[Odin][] is the only language that I'm not _waiting around for._ The language itself is effectively done, reinforced by the [Odin 2027 announcement][2027]. It has allocator APIs today. The compiler has a parallel frontend, and build times are entirely reasonable on the hardware and platforms I use.

To top it off:

* The `#soa` directive makes optimizing memory layouts ergonomic -- for when it's _gotta go fast._ 
* <abbr title="Foreign Function Interface">FFI</abbr> to C libraries is a breeze, and it comes fully equipped with bindings to DirectX, Metal and more.
* Vectors, matrices and quaternions are baked into the language.
* Hot code reloading is _almost_ trivial, thanks to a focus on plain old data and manual memory management.

All things I like. Well, except manual memory management! We'll get into all that, and strategies to mitigate the downsides.

[2027]: https://www.youtube.com/watch?v=dLPAqXi9In0

## A familiar face
_It looks like a duck, it quacks like a duck, but it's an entirely different breed._ 🦆

The Odin language feels familiar, borrowing liberally from Go's syntax and design.[^1]

* Pascal-style declaration syntax with type inference: `x := 10`
* Zero is initialization (ZII)
* Multiple return values, named return values, and even naked `return` 😳
* Built-in dynamic arrays, slices, strings and runes
* Built-in maps with the familiar `make(map[string]int)` and `elem, ok := m[key]` syntax
* Struct field tags: ``struct {name: string `json:"username"`}``
* The `new(int)` builtin and nil pointers 💰
* Defer keyword -- but Odin defers to the end of a scope
* Packages are directories
* Conditional compilation with build tags, file suffixes -- and also a `when` statement

The similarities are bound to draw comparison, but while Go strove for simplicity, Odin is _even simpler._ There are no language primitives for concurrency and no built-in green threads. Odin doesn't have duck-typed 🦆 interfaces or methods on any type. No <abbr title="Object Oriented Programming">[OOP][]</abbr>. No closures. It's an _imperative language_ through and through. 

These are not things I _need._ There is, however, one thing Odin sorely lacks.

It doesn't have a cute mascot![^2] 😜 

If it's any consolation, Odin does have a few features that gophers have wanted for a long time:

* Enums and tagged unions with exhaustive switch statements
* The `or_return` operator for more ergonomic error handling

So far I've found Odin quite _pleasant to read and write_ -- familiarity is sure to be playing a role.

[OOP]: https://www.youtube.com/watch?v=wo84LFzx5nI

[^1]: Just like Go takes inspiration from previous languages.
[^2]: I stand corrected, but boy is it [buried](https://github.com/odin-lang/odin-lang.org/tree/master/static/images/mascot).

## Manual memory management
_We better `&address` the elephant in the room._ 🐘 

Memory safety -- it isn't critical for my use case. Single-player entertainment, maybe multiplayer with _friends._ I do want fewer bugs, 🐜 but I also want fast iteration, painless hot code reloading, and a language well-suited for game development.

I'll be the first to admit that garbage collection didn't make Minecraft (Java), Stardew Valley (C#), CrossCode (JavaScript) or Meg's Monster (Go) unplayable. And the borrow checker didn't stop Tiny Glade or (the) Gnorp Apologue from compiling. ⚔️

I've been attempting to _Learn Me Some Rust_ [for years](/4000). In the right hands, all that expressive power has produced some [truly inspiring work][deadlock]. But it's not for me. I _value simplicity_ more than power.

[deadlock]: https://www.youtube.com/watch?v=Ba7fajt4l1M

### The low-hanging fruit
_Safety close at hand._ 🍓

Even a simple language can make moderate improvements to memory safety, helping to reduce bugs.

Spatial memory bugs (e.g. buffer overflows) can be avoided with bounds checking, which Odin provides by default. You can disable bounds checking in tight loops with `#no_bounds_check`. Odin also initializes memory to zero, but you can opt out with `---`. Odin starts from the right defaults, but trusts you to know what you're doing.

The sanitizers that C developers are all-too-familiar with are here. The `-sanitize:address` flag enables <abbr title="AddressSanitizer">ASan</abbr>, which can catch temporal memory bugs (e.g. use after free). Odin also has its own tracking allocator, which doesn't catch everything ASan can, but it has much lower overhead. Both of these are runtime checks, and thus depend on test coverage or manual <abbr title="Quality Assurance">QA</abbr>.

These are easy wins for a new language.[^3]

[^3]: A newish language. Odin is only 10 years old.

### Mutation xor sharing
_In Odin, you are the borrow checker._ 🦀

I say that jokingly, 😅 but it's true. Mutate the world under your feet at your own peril. 

Let's write an update function that runs on every entity, updating its position and state. It can also inspect the state of the world, including all the entities contained within it.

```odin
update :: proc(entity: ^Entity, world: World) {
	// do update
}
```

Rust imposes many decisions on every function parameter. Should it be a mutable borrow, a shared reference, or move ownership? What about aliasing? The compiler will outright reject some combinations. For some, feedback like this is an opportunity to take a step back and [find a better design](https://www.youtube.com/watch?v=aKLntZcp27M). Others [value iteration](https://loglog.games/blog/leaving-rust-gamedev/) over all else, quickly prototyping a rough implementation without fighting the compiler. Rust's borrow checker, for all it's worth, can't distinguish between a multi-threaded production server susceptible to adversarial attacks, and a single-threaded throw-away prototype.

Leaving the borrow checker behind, we're left to ourselves to consider ownership, aliasing and the like. 

Procedure parameters in Odin are _immutable_, but only in a shallow sense. The `update` procedure could mutate any data that `world` holds a _reference_ to, which may not be what we want. Rather than avoid mutation by convention, we could define `World` and `Entity` so that everything is inline.[^4] Then the `world` parameter can be completely immutable:

```odin
World :: struct {
	entities: [10000]Entity,
	// etc.
}

game_tick :: proc(world: ^World) {
	for &e in world.entities {
		// update can modify entity, but world is read-only
		update(&e, world)
	}
}
```

Odin automatically passes large arguments by reference, so passing `world` around doesn't tank our performance. However, changes to `entity` will be reflected in the `world` _immediately_, since `world` isn't a copy.

Which brings up another problem with this design. If the entities interact, those interactions are order dependent. For example, does a monster dodge the bullet by being the first to move, or does the bullet move first?

Maybe a better design would double buffer the world data (previous and current frame) or store up the writes to apply at the end. Or maybe entities should be split up (monsters, bullets) and resolved in a defined order. Maybe there's an entirely different design that's even better. But those design decisions are all language agnostic.

Even though Odin doesn't check your borrows, it doesn't mean your data is a mutable ball of mud with pointers flying everywhere. How you architect your data and code is still up to you.

[^4]: I'm not necessarily recommending this approach, but it serves as an interesting example.

### Enter the arena
_How barley men manage lifetimes._ 🏟️

Why free one gladiator at a time when you can `free_all` at once? Games have some big obvious lifetimes:

* The beginning of the game until the very end
* When a level loads until it unloads
* From the beginning of a frame until the end of the frame

A simple arena allocator operates like the stack you already use every time you call a function, except the arena can have any lifetime you choose. It can use preallocated memory and then reuse that memory again and again. Freeing and allocating memory within an arena is a matter of moving a pointer -- making it very inexpensive to operate.

Instead of just a single global allocator (e.g. `malloc`), Odin has an [implicit context system][context][^5] that provides a default heap allocator and a temporary arena allocator. These can be customized with other allocators, or you can pass allocators around explicitly when desired.

In a game loop, the `temp_allocator` can be used for any allocations that should live for a single frame. At the end of the frame, clear the arena for reuse: 

```odin
free_all(context.temp_allocator)
```

Grouping together values with the same lifetime reduces the cognitive burden of keeping track of every independent value. "Did I remember to free everything?" becomes a matter of allocating things in the arena with the appropriate lifetime.

If you want a deep dive, check out Ryan Fleury's [talk][arena-talk] and [article][arena] on arena allocators.

One idea Fleury describes is reserving a large contiguous block of virtual address space up front. The [mem/virtual](https://pkg.odin-lang.org/core/mem/virtual/) package in Odin can be used for that purpose.

[context]: https://www.gingerbill.org/article/2025/12/15/odins-most-misunderstood-feature-context/

[^5]: Odin's context system has no relation to Go's context.

### Avoiding relocation
_Please don't go._ 🚚

When a dynamic array is full, appending to the end causes the data in the array to be copied to a new, larger location. This is fine, unless there are pointers to elements at the old location. Now those pointers are invalid (dangling pointer).

Odin includes some specialized data structures that don't relocate their data, making it safer to hold pointers into them. 

Fixed-capacity dynamic arrays (`[dynamic; 100]int`) are a recent addition. They behave much like a dynamic array, but they can't grow beyond their initial capacity, and thus never reallocate.

The [xar](https://pkg.odin-lang.org/core/container/xar/) package is like a dynamic array, but it grows in chunks instead of relocating the data. <!--And other containers like [handle_map](https://pkg.odin-lang.org/core/container/handle_map/) can be layered on top.-->

### Generation
_Exit the pointer jungle._ 🐒

_Generational indexes_ provide an alternative to long-lived pointers. As an added benefit, they are easy to serialize to disk (save game) or the network. 


Imagine a monster 🧟‍♀️ that is chasing another entity. Instead of an `^Entity` pointer, store an index (often called an ID or handle) into the world's entity array. If the entity being chased is destroyed, the slot in the array could be repurposed for a new entity. A generation is a simple counter used to verify that the referenced entity is still the same one.

```odin
Index :: distinct u32
Generation :: distinct u32

GenerationalIndex :: struct {
	idx: Index,
	gen: Generation,
}
```

Odin provides a [generational index implementation][handle_map] in the core library.

[handle_map]: https://pkg.odin-lang.org/core/container/handle_map/

So there are many techniques to reduce the risk of dangling pointers and the like. Maybe manual memory management doesn't _need_ to be a pointer jungle full of foot guns and spooky action at a distance.

All that pointer chasing isn't just bad for developer sanity. It can also harm data locality and performance. But to understand why, we need a cursory understanding of how CPUs work.

## Data-oriented design
_Hardware is the platform._ 🌺

Programs are made up of data and transformations to that data. If you know the data and how it's accessed, and you understand the target hardware, then it's possible to write software that runs better on that hardware. This is the thesis of data-oriented design.

When I was a teenager, using a lookup table to avoid mathematical operations (like trigonometry) was a good idea. Today we have a lot more <abbr title="Random Access Memory">RAM</abbr> and it's somewhat faster. But CPUs are much, much faster. CPUs are so fast at math that reading from main memory could take an order of magnitude longer than just recalculating the math. 

Since memory is relatively slow, CPUs have levels of progressively larger and slower caches (e.g. <abbr title="level 1">L1</abbr>, L2, L3). When data isn't in a cache (a cache miss), the CPU looks at the next one, and eventually main memory.

Today, data-oriented design centres on economical use of memory (the fastest caches are small), and organizing data based on how it's accessed. When iterating a data structure, an array places the next value nearby. Whereas a linked list uses pointers, potentially placing each node anywhere on the heap, and therefore increasing the likelihood of a cache miss for each iteration. 

I'm not saying to never use pointers or even linked lists. Rather, it's worth thinking about how our data and code map to the underlying hardware.

There are several [tricks](https://www.youtube.com/watch?v=WwkuAqObplU) that are worth knowing, but the technique that's most relevant here is called structure of arrays.

### Structure of arrays
_Gotta go fast._ 💨

Let's flesh out our array of entities.

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

We know that our physics system only needs a subset of all the entity data, so we collected it into a `Location` struct. Maybe not the _best name,_ but let's go with it. Now we can pass our physics subsystem the subset of data it needs:

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

Effectively, those four characters change our memory layout to a struct of arrays, like this:

```odin
EntitySoA :: struct {
	location: [10000]Location,
	health: [10000]int,
	// etc.
}
```

All with _no other code changes!_ By grouping together all the data that our physics system needs, we can take better advantage of the CPU cache.

## Stability
_A solid foundation._ 🪨

Speaking of _no other code changes,_ we need to talk about stability. [JangaFX](https://jangafx.com/) and others rely on Odin to remain stable and well-maintained, and the recent [Odin 2027 announcement][2027] is Odin's 1.0 moment.

As a smoke test, I upgraded the 2024 source code from Cat & Onion (available on [Itch][] 💸) to the latest Odin dev-2026-07a compiler and [raylib](https://www.raylib.com/) 6.0. The most significant changes were to `core:os`, which were [telegraphed](https://odin-lang.org/news/moving-towards-a-new-core-os/) well ahead of time. The other big changes were for raylib, particularly HiDPI.

Did I mention that raylib bindings are bundled with Odin? 

[Itch]: https://zylinski.itch.io/cat-and-onion

## Vendor
_In Odin, you are the package manager._ 📦

Odin ships with bindings for DirectX 12, DirectX 11, Metal, OpenGL and Vulkan. Windows COM and Objective-C APIs feel like part of the language. Defer helps with cleanup, as there's no <abbr title="Resource Acquisition Is Initialization">RAII</abbr> like in C++ or Rust.

Having all these bindings baked in makes it quick to get up and running, say, to learn a graphics API from a book or tutorial. While porting a _Metal by Tutorials_ demo from Swift to Odin, I hit a bug with [passing SIMD types over FFI](https://github.com/odin-lang/Odin/issues/7010). 🐜 It was promptly resolved by an Odin community member. 👍🏻

Other C bindings are included as well, such as [Box2D](https://box2d.org/). There is value in depending on mature libraries, with logic bugs fixed over many years.

If there's a C library not provided in vendor, there are tools to [generate bindings](https://github.com/karl-zylinski/odin-c-bindgen). Odin can link in foreign libraries, but those libraries may require CMake or similar to build. Odin doesn't call out to C compilers. This is fine by me, as I have no desire to port and maintain third-party build scripts in Odin.

There's no official tool that pulls in dozens of transitive dependencies with a single line. It's part of the ethos to vet external packages more carefully. Very deliberate dependency choices also keep compile times snappy. For my needs, this too is fine.

## Compile times
_Oh. Carry on._ ⚔️

Compile times are one thing Go definitely got right from the start. Odin doesn't have incremental compilation and its backend is [LLVM][], so it must be slow, right? We won't know for sure until _we put it to the test!_

Presenting the `-show-timings` data for the Odin compiler (dev-2026-07a). Default optimization level of `-o:minimal` and no debug info. Based on multiple runs with the initial warm-up discarded.

* Windows 11 with an AMD Ryzen 9700X (8c/16t) and [RAD Linker][RAD] (0.9.24 ALPHA).
* macOS Tahoe with an M1 Max (8P+2E) with the default linker.


| Platform | Project                   | LoC[^6]  | Parsed[^7]       | LLVM   | Link   | Total      |
| -------- | ------------------------- | ---- | -----------: | -----: | -----: | ---------: |
| Zen 5 8c | Karl2D Snake              | 14K  | 141K         | ~90ms  | ~32ms  | ~230ms     |
| Zen 5 8c | Cat & Onion               | 21K  | 141K         | ~445ms | ~32ms  | ~575ms     |
| Zen 5 8c | Odin Core Library + Tests | 270K | 282K         | ~1s    | ~65ms  | ~1.3s      |
| M1 Max   | Karl2D Snake              | 14K  | 132K         | ~140ms | ~170ms | ~420ms     |
| M1 Max   | Cat & Onion               | 21K  | 134K         | ~615ms | ~180ms | ~900ms     |
| M1 Max   | Odin Core Library + Tests | 270K | 278K         | ~1.6s  | ~200ms | ~2.1s      |

[^6]: Lines of code reported by `cloc`, excluding blanks/comments.
[^7]: Lines parsed by the front-end. Includes imported core packages and blanks/comments, but excludes files tagged for other platforms. Reported by `-show-more-timings -show-debug-messages`.

Odin Core Library + Tests is a *build* -- we're not evaluating test execution time.

```sh
odin build tests/core -all-packages -build-mode:test -show-timings -out:core-tests
```

For my hardware setup, Windows was noticeably faster.

* The default Windows linker (MSVC) was 20-50ms slower than the bundled version of [RAD Linker][RAD].
* With debug info, builds were ~100ms to ~600ms slower on Windows and up to ~1.1s slower on macOS.

Odin build times are dominated by the LLVM backend (~80%) on larger projects.

* The Odin front-end scales near-linearly with lines parsed. 
* For debug and development builds (`-o:none` or `-o:minimal`), Odin emits LLVM IR for each package in parallel. LLVM scales according to the largest package, measured in terms of IR emitted.
* The largest package in Cat & Onion (game) emits 5x the LLVM IR of the largest package in Snake (karl2d). This explains the gap in compile times, despite parsing a similar number of lines.
* Core Library + Tests emits 69 MiB of LLVM IR spread across 213 modules. The package emitting the largest amount of LLVM IR (14.5 MiB) was the biggest determinant of build time, with the majority of packages emitting far less.

In addition to pure lines of code, <abbr title="parametric polymorphism">parapoly</abbr> is a factor. In Odin, monomorphized IR concentrates in the defining package's module. This avoids duplication, 👍🏻 but it also increases the likelihood of a few modules dominating compile time. This seems more likely to impact test builds (e.g. the flags package tests 60 variations). Moderately slower test builds may be negligible vs. the time running the test suite.

As Jakub Tomsu [writes](https://jakubtomsu.github.io/posts/odin_comp_speed/), keeping procedure bodies small when using parapoly can help. 

Keeping package sizes reasonable and not overusing generics are common recommendations in many languages. Heavy use of `#load` and reflection (e.g. fmt, json) may also be worth keeping an eye on. Odin's `-show-timings` and `-build-diagnostics` are helpful tools if builds ever start feeling slow.

Overall I'm happy with these results, especially on my Zen 5 system.

[LLVM]: https://llvm.org/
[RAD]: https://github.com/EpicGames/raddebugger#the-rad-linker

## Hot code reloading
_Instant gratification._ ♻️

Once we have reasonably quick build times, hot code reloading provides the ultimate in fast iteration. The goal is to apply code changes without restarting the running app or game.

There are three approaches that I'm aware of. The best option for hot reloading Odin code is to split a game into two parts: an executable and a shared library (dll/dynlib/so). Launch the game, tweak gameplay logic or user interface code, then recompile the shared library. Have the main executable reload the shared library so code changes are reflected instantly.

For this to work, the memory that the gameplay code is using must be handed off to the new shared library. The game continues on from where it left off. Odin doesn't provide hot code reloading out of the box, but its focus on plain old data and procedures, along with manual memory management makes Odin a natural fit. It keeps the entire solution relatively simple.

There are still some gotchas to look out for. To get started, take a look at Karl Zylinski's [article][hot-reload] and [templates][karl-git] for hot reloading.

[hot-reload]: https://zylinski.se/posts/hot-reload-gameplay-code/
[karl-git]: https://github.com/karl-zylinski/

## What's not to love?
_Baby, don't hurt me._ 💔

The reference documentation is incomplete and there are gaps in the core library (e.g. saving PNGs). These are things being worked on for [Odin 2027][2027], which isn't that far off.

The tooling is good, but could always be better. Daniel Gavin's [ols][] language server includes a code formatter, but it allows configuration and [another formatter][lucyfmt] exists. I'm grateful that these tools exist, but a single standard would benefit humans and tooling alike.

There is `odin test`, but I'm not aware of a built-in test coverage or fuzzing tool. Fortunately it's feasible to use existing C/C++ debuggers and profilers.

Maybe the compiler could optimize a little better or be a little faster. That's always the case.

[ols]: https://github.com/DanielGavin/ols
[lucyfmt]: https://lucypero.com/blog/lucyfmt.html

## Conclusion
_Most outstanding._ ✌🏻

I've enjoyed my time with Odin so far. The ergonomics and the compile times. The vendor libraries, built-in linear algebra, `#soa` and allocators are all nice to have. Manual memory management, plain old data and the bog-standard threading model make FFI and hot code reloading simpler. While not everyone's 🍵 cup of tea, it's a good fit for my use case.

If you're at all intrigued, take a gander at the Odin [overview][]. After that, I highly recommend Karl Zylinski's book, [Understanding the Odin Programming Language][odinbook]. He has kept the content in step with the language over the years.

Until next time.

[arena-talk]: https://www.youtube.com/watch?v=TZ5a3gCCZYo
[arena]: https://www.dgtlgrove.com/p/untangling-lifetimes-the-arena-allocator

[overview]: https://odin-lang.org/docs/overview/
[odinbook]: https://odinbook.com/
[Odin]: https://odin-lang.org/

+++
title = "🔱 Why Odin?"
description = "First impressions of the Odin programming language."
date = "2026-07-12"
keywords = ["Odin", "code", "programming", "C alternative", "data oriented design", "Joy of Programming"]
draft = true
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
* Nil pointers and the `new(int)` builtin
* Defer keyword (though end of scope)

The similarities are bound to draw comparison, but while Go strived for simplicity, Odin is even simpler. The things I found most intriguing in Go simply aren't in Odin, and with _no plans_ to add them. There are no language primitives for concurrency, and no built in green threads (channels, select, goroutines). Odin doesn't have duck typed interfaces, nor methods on any type. There are lambdas, but no closures. It's an imperative language through and through. 

Worst of all, Odin doesn't even have a cute mascot! But I think comparing Odin to Go is the wrong framing. 

## C alternative

Odin bills itself as a _C alternative for the Joy of Programming_. It's one of [many](https://c3-lang.org/) [languages](https://ziglang.org/) to sand down C's rough edges, while not becoming as complex as C++, Rust, or Swift. Each language will appeal to different people, but they seem to converge on the same set of core features. Allocators, packages instead of preprocessors, and data-oriented design.

### Manual memory management

I didn't go looking for manual memory management.

Garbage collection didn't prevent games like Minecraft (Java), Stardew Valley (C#), CrossCode (JavaScript), or Meg's Monster (Go) from being successful. Tiny Glade and (the) Gnorp Apologue are two of several games written in Rust. They fought the borrow checker and won.

That said, memory safety isn't the most critical factor for my use case -- small scope, single player entertainment (games).

#### Mutation xor sharing

In Odin, _you are the borrow checker._ 😅

I say that jokingly, but it's also true. The compiler won't stop you from mutating the world under your feet. Imagine an update function that runs on every entity, updating its position and state. It can also look at the state of the world, including all the entities contained within it.

```odin
update :: proc(entity: ^Entity, world: World) {
	// do update
}
```

See any problem with this design? What if we know this game play logic is single-threaded, any problems now?

If the entities interact, those interactions are order dependent. For example, does a monster dodge the bullet by being the first to move, or does the bullet move first?

A borrow checker would see the mutable and shared reference to the same world state and reject it. Maybe a better design would be to double buffer the world data (previous and current frame) or store up the writes to apply at the end. Or maybe entities should be split up (monsters, bullets) and resolved in a defined order. For some, being forced to find a better design is a good thing. Others value iteration over all else, quickly prototyping a rough implementation without fighting the compiler.

#### The low hanging fruit

Spatial memory bugs (e.g. buffer overflows) can be avoided with bounds checking, which Odin provides by default. Bounds check elimination appears to be manual (`#no_bounds_check`) right now, but it's starting from the right defaults. Odin also initializes memory to zero. These are easy wins for a new language.

#### Enter the arena

Temporal memory bugs (e.g. use after free) are more difficult, and do require some discipline. Arena allocators can help. 

For example, in a game loop, a `temp_allocator` can be used for any allocations that happen during the frame. At the end of the frame, that arena is cleared for reuse. This reduces calls to the kernel for heap allocations, improving performance. Perhaps more importantly, it groups together all the values with the same lifetime (a single frame). When applied broadly (the lifetime of a level, a frame, etc.), this approach can help reduce the likelihood of temporal memory bugs.

If you want a deep dive, check out Ryan Fleury's [talk][arena-talk] and [article][arena] on arena allocators.

#### Data structures

Odin includes some specialized data structures that don't relocate their data, making it safer to hold pointers into them. 

Fixed capacity dynamic arrays (`[dynamic; 100]int`) are a recent addition. They behave like a dynamic array (`append(&x, 123)`, etc.), but they can't grow beyond their initial capacity.

The [xar](https://pkg.odin-lang.org/core/container/xar/) package is like a dynamic array, but it grows in chunks instead of relocating the data. And other containers like [handle_map](https://pkg.odin-lang.org/core/container/handle_map/) can be layered on top when needed.
 
Though not provided directly by Odin, generational indexes can be used instead of long-lived pointers. They are easy to serialize to disk (save game) or the network. Imagine a monster in a game that is chasing another entity. Instead of a `^Entity` pointer, store an index (often called an ID) into the world's entity array. If the entity being chased is destroyed, the slot in the array could be repurposed for a new entity. A generation is a simple counter that is used to verify that the referenced entity is still the same one.

So there are many ways to reduce the risk of dangling pointers and the like.

#### Sanitizers

In addition to arena allocators, there are runtime tools. Odin's tracking allocator and ASAN (`-sanitize:address`) can help find memory bugs. But even with these tools, some memory bugs may slip through. Will good technique and test coverage save me? Time will tell.

### No preprocessor

It's par for the course that C alternatives don't carry forward C's preprocessor.

Instead of `#include` file inclusion and separate `*.h` header files, Odin has a package system similar to Go. One package per directory.

Odin also has conditional compilation with `when` or build tags (similar to Go) instead of `#ifdef`. Other C alternatives have far more compile-time features, Odin keeps it simple and minimal.

### Data-oriented design

Odin calls itself "The Data-Oriented Language for Sane Software Development" -- so what is data-oriented?

Programs are made up of data and transformations to that data. If you know your data and how it's accessed, and you understand the target hardware, then it's possible to write software that runs better on that hardware.

When I was a teenager, using a lookup table to avoid mathematical operations (like trigonometry) was a good idea. Today we have a lot more <abbr title="Random Access Memory">RAM</abbr> and it's somewhat faster. But CPUs got much, much faster. CPUs are so fast at math, that reading from main memory could take an order of magnitude longer than just recalculating the math. 

Since memory is relatively slow, CPUs have layers of progressively larger and slower caches (e.g., <abbr title="level 1">L1</abbr>, L2, L3). When data isn't in a cache (a cache miss), the CPU looks at the next one, and eventually main memory.

Today data-oriented design centres on economical use of memory (the fastest caches are small), and organizing data based on how it's accessed. 
There are [several](https://www.youtube.com/watch?v=WwkuAqObplU) [tricks](https://www.youtube.com/watch?v=IroPQ150F6c) to squeeze more data into your structs, but the feature unique to Odin and other C alternatives is called structure of arrays.

#### Structure of arrays

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
	// etc.
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

But even though we're only passing the data the physics system needs, the data is still laid out in memory one entity after another. That means fewer locations fit into the cache than if we had a separate `[10000]Location` array. The result in more cache misses and slower performance.

We could reorganize our code by hand, but Odin provides a `#soa` directive, which can modify the memory layout for us.

```odin
entities: #soa[10000]Entity
```

Effectively, those four characters changed our data layout in memory to a struct of arrays, like this:

```odin
EntitySoA :: struct {
	location: [10000]Location,
	health: [10000]int,
	// etc.
}
```

With no other code changes. By grouping together all the data that our physics system needs, we can take better advantage of the CPU cache.

## Linear Algebra

Odin doesn't support operator overloading, but it has built-in vectors, matrices, and quaternions. Impressive! It supports both column major and `#row_major` matrices. I need a math refresher before I dig into it myself.

In the meantime, I asked Claude Fable 5 to look into porting the source code from books on DirectX 11, [DirectX 12](https://github.com/nathany/d3d12book_2ed/tree/odin/odin_port), Vulkan, and Metal. There may be a few gaps in Odin's `math/linalg` vs. DirectXMath and GLM, but it seemed comparable to popular math libraries in other languages.

## Compile Times

In terms of developer experience, one thing Go got right is compile times.

Odin has no incremental compilation and it's backend is LLVM, so it must be slow? In my testing, it's actually pretty fast. Taking <300ms for a 15K line project. The projects I tested were Karl2D (~15K), Cat & Onion (~21K), and Odin Core (~230K). [RAD Linker][RAD] is bundled (`-linker:radlink`) for Windows and boosts performance.

|Platform|  LoC|Minimal  |Debug |
|--------|-----|---------|------|
|Zen 5 8c| ~15K|         |      |
|Zen 5 8c| ~21K|         |      |
|Zen 5 8c|~230K|         |      |
|M1 Max  | ~15K|~420ms   |~540ms|
|M1 Max  | ~21K|~900ms   |~1.2s |
|M1 Max  |~230K|         |      |

[Jakub's Odin compilation speed tips](https://jakubtomsu.github.io/posts/odin_comp_speed/) offers some advice on compiler flags.

[RAD]: https://github.com/EpicGames/raddebugger#the-rad-linker

### Hot Code Reloading

compile times + memory

## Vendor

Objective-C 
Windows COM
reference counted APIs

pro/con, workaround

Box2D

[bindgen](https://github.com/karl-zylinski/odin-c-bindgen)
calling the C compiler

In Odin, _you are the package manager._ 😅

## Stability


[Odin]: https://odin-lang.org/
[Odin 2027](https://www.youtube.com/watch?v=dLPAqXi9In0)


fairly stable

[Cat & Onion][CatOnion] on Itch

`core:os` changes that were [telegraphed](https://odin-lang.org/news/moving-towards-a-new-core-os/) well-ahead of time

hidpi

Karl Zylinski

[CatOnion]: https://zylinski.itch.io/cat-and-onion



 no test coverage tool, no built-in fuzzing.
[ols][]

## Conclusion

readability
pleasant


ergonomic affordances 

tagged unions, context system
 `or_else` and `or_return` for error handling

[overview][]

recommend
 [Understanding the Odin Programming Language][odinbook] by Karl Zylinski.
 I'm currently making my way through.
 Updated with new language features.

Manual memory management can also make <abbr title="Foreign Function Interface">FFI</abbr> (C <abbr title="Application Binary Interface">ABI</abbr>) and hot code reloading simpler.

[^1]: Just as Go takes inspiration from previous languages.

[arena-talk]: https://www.youtube.com/watch?v=TZ5a3gCCZYo
[arena]: https://www.dgtlgrove.com/p/untangling-lifetimes-the-arena-allocator

[overview]: https://odin-lang.org/docs/overview/
[odinbook]: https://odinbook.com/
[ols]: https://github.com/DanielGavin/ols

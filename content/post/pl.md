+++
title = "💻 System programming languages"
description = "Poking at C and the alternatives."
date = "2026-11-14"
keywords = ["Odin", "Zig", "Jai", "code", "programming"]
+++

Earlier this year, I posted my [preliminary thoughts on Odin](/why-odin). While I finished reading Karl Zylinski's [Odin book][], the Odin compiler [got noticeably faster][fastodin]. Odin isn't the only language I considered, and due to a bout of uncertainty, I continued evaluating the alternatives.

[Odin book]: https://odinbook.com/
[fastodin]: https://www.youtube.com/watch?v=fgSrcE8lmFs

### C

What could be more _handmade_ than choosing C and writing my own standard library (data structures, allocators, etc).

Odin doesn't yet support game consoles or even Windows ARM64, whereas <mark>C is everywhere.</mark> <abbr title="Simple DirectMedia Layer 3">SDL3</abbr> (C) even has an official fork for consoles.

### Modern C

C has continued to evolve over the last 10 years since Odin was started. So how close could Modern C get to Odin?

Clang 22 supports the upcoming [defer][] statement. Or for greater compatibility, there's
a macro trick that uses a `for` loop to run code before and after a block.

Another `for` loop trick makes [vector math readable][math] without operator overloading or macros.

As with unsigned integers, Odin's signed integers will wrap-around (two's complement). Clang also supports this with the `-fwrapv` flag. But C still suffers from 32-bit integer literals and Windows/Linux defining `long` and the `L` literal suffix differently. The `stdint` header helps a little:

```c
int64_t four_gigabytes = INT64_C(1) << 32;
```

I discovered that if you want warnings for signed/unsigned comparisons, `-Wall` isn't enough. The squiggles only show up with `-Wextra`. _Apparently all is a subset of everything._

### Use after free

When I tested a use-after-free bug, both C and Odin were silent by default, but address sanitizer (`-fsanitize=address`) with debug info (`-g` or `-debug`) caught it. Both provided line numbers for the _use,_ but only C provided accurate line numbers for the _allocation_ and _free._

Clang also has an `--analyze` flag that caught the use-after-free with static analysis, which covers code paths not under test. The output was very readable.

### Available ≠ portable

C is everywhere, but C is also different everywhere. Some platforms may be on older or different compilers or C runtimes. For example, `clang-cl` on Windows combines Clang with the Microsoft Universal C Runtime (UCRT), with the later limiting what _[can i use][C2y]_.

I'm starting to understand why Nic Barker's [Tips for C Programming][ctips] sticks with C99 instead of "Modern C".

With the right tools and flags, plain C doesn't seem too bad. But among other things, it's pretty helpful that bounds checking in Odin is opt-out rather than opt-in.

[defer]: https://gustedt.wordpress.com/2026/02/15/defer-available-in-gcc-and-clang/
[math]: https://lotusspring.substack.com/p/a-simple-c-trick-for-readable-vector
[C2y]: https://cppstat.dev/?tags=c
[ctips]: https://www.youtube.com/watch?v=9UIIMBqq1D4

### Zig

There are several things I like about Zig, and I've learned a few more details since I wrote my [Odin post](/why-odin).

### Explicit allocators

Since freeing memory is explicit, I generally like that Zig makes allocation explicit too. It feels like a natural pairing.

In Odin, dynamic arrays are built into the language, which is more concise than Zig's ArrayList. But as a consequence, it could be easy to forget the defer in code like this:

```odin
a: [dynamic]int
// defer delete(a) // oops
append(&a, 1, 2, 3)
```

There's a file-level `explicit-allocators` build tag in Odin that I thought provided a more Zig-like experience. Unfortunately, it only complains when an explicit allocator isn't passed to a function like `make([dynamic]int)`. The code above would still compile without error, and result in a memory leak.

### Use after free

When I tested a use-after-free bug in Zig, it provides a runtime error in the default build without address sanitizer. Odin's tracking allocator detects memory leaks but not use-after-free or double-free bugs, and it's not enabled by default like Zig.

Personally, I'm not overly concerned with needing to run ASan, and the tracking allocator is all user code that I could theoretically improve. But it's one place where Zig is more friendly to beginners than Odin.

These tests were with the general purpose heap allocator, even though I suspect the vast majority of memory allocation will use arenas. Use-after-reset and other memory bugs can still happen with a temporary arena allocator, so maybe the [arena allocator in Odin could be improved](https://github.com/odin-lang/Odin/discussions/7075) for debug builds.

### Integer comparisons

Type conversions in Odin are always explicit. A principled approach that's easy to remember.

Zig has an elegant way of handling unsigned and signed integer comparisons. The comparison `a > b` just works in Zig, whereas the equivalent in Odin is:

```odin
a: uint = 0
b: int = -1
if (b < 0 || a > uint(b)) {
	// true
}
```

Odin tends to use signed integers in more places (e.g. loop indexes, `len()`), so signed/unsigned comparisons may be less common. But Zig is still more user friendly in this regard.

### Jai

Jai _looks_ a bit like Odin (or vice versa). It clearly supports game consoles, given all the platforms that [Order of the Sinking Star][oss] released on. Raphael Luba mentioned game consoles on the [Wookash Podcast][wookash-raphael] too.

Since I'm not in the private beta for Jai, I don't know how it compares to Odin at a deeper level. The standout feature is compile time execution, which could be useful in certain situations (e.g. serialization). The [program visualization and memory debugging tools][jaitools] it enables are very impressive.

Right now we have no idea when/how Jai will be released. There could be a public binary-only release next year, possibly followed by an open source release. Today I decided to write an email requesting access to the Jai beta. We'll see what happens.

What I can gather from Raphael Luba's work on Jai and Sebastian Ahlman's [experience with Zig][Madrigal], is that compile time execution makes a solid debugging experience (on Windows) somewhat more challenging. A challenge that I trust both language teams will overcome in time.

[oss]: https://www.orderofthesinkingstar.com/
[wookash-raphael]: https://www.youtube.com/watch?v=sT-RfeF3Ado
[jaitools]: https://www.youtube.com/watch?v=IdpD5QIVOKQ
[Madrigal]: https://www.youtube.com/watch?v=HXpUShkr2VQ

### Decision fatigue

At some point I need to move past kicking the tires with tiny code snippets and build something real.

I was somewhat dismayed by the regressions that shipped in Odin's October release, but it has since improved. The December release of Odin is shaping up to be solid. Massive shout out to Jeroen van Rijn for all the hard work auditing the standard library to fix bugs and add more test cases.

Next up on my roadmap is learning some Win32 basics and then Direct3D.

Until next time.

+++
title = "Hello FFI"
description = "Foot guns at the labs."
date = "2025-07-12"
keywords = ["c", "cpp", "rust", "ffi", "foreign function interface", "long", "cross-platform"]
+++

This post is an exploration of the foreign function interface (FFI) between C and Rust, and one of the many foot guns that await those brave enough to straddle the boundary.

The C standard-library defines several functions for computing the absolute value of an integer:

```c
int abs(int n);
long labs(long n);
long long llabs(long long n);
```

Today we're going to pick on `labs` because it uses `long`, and there's something you may or may not know about `long` in C. From Rust's documentation on [c_long][]:

> This type will always be `i32` or `i64`.
> Most notably, many Linux-based systems assume an `i64`,
> but Windows assumes `i32`. [^1]

🤦🏼‍♂️[^2]

## Rust has our back, mostly

Now, there is no practical reason to call C from Rust to compute an absolute value, as Rust has perfectly good [abs][]. But humour me. And to make it interesting, let's try passing an i64 to a function that accepts a c_long:

```rust
use std::ffi::c_long;

unsafe extern "C" {
    safe fn labs(input: c_long) -> c_long;
}

fn main() {
    let num: i64 = -9876543210;
    println!("Absolute value of {num}: {}", labs(num));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_labs() {
        let result = labs(-9876543210);
        assert_eq!(result, 9876543210);
    }
}
```

On macOS, and presumably on Linux, this works perfectly fine because `c_long` and `i64` are both 64-bit signed integers on these platforms. Compile the same program on Windows for a [mismatched types error][error]:

```text
println!("Absolute value of {num}: {}", labs(num));
                                        ---- ^^^^ expected i32, found i64
                                        |
                                        arguments to this function are incorrect
```

The opposite situation is also true. If we were to call `labs` with an `i32`, then it would work on Windows (where `c_long` is 32-bits) but it fails to compile on macOS, and presumably Linux.

```rust
let num: i32 = -42;
println!("Absolute value of {num}: {}", labs(num));
```

The compiler errors are really great, but the only way to see them is to compile on multiple platforms.

Currently there are no clippy warnings to indicate that there could be a compiler error on another platform. I considered [suggesting it][clippy] to see what the Rust community thinks, but clippy isn't accepting new lint suggestions right now. Maybe later. 🤷🏼‍♂️

## It could be worse

Up until now, we've been exploring the "happy" path. 😅

The previous code uses `std::ffi::c_long`, so the compiler was able to help us out, even if only on the platforms where there was a type mismatch.

Imagine if someone were unaware of `c_long` and didn't realize that `long` means different things on different platforms. This is a very real possibility, as Rust is an attractive proposition to programmers coming from scripting languages. It's even in the motto:

> A language empowering **everyone** to build reliable and efficient software.

So what happens if we erroneously declare the `labs` function to accept and return an `i64`?

```rust
unsafe extern "C" {
    safe fn labs(input: i64) -> i64;
}
```

It continues to work fine on macOS or Linux, where C's `long` is 64-bits, but what about on Windows where `long` is 32-bits? Well, now it compiles. Rust doesn't know what types the C function actually takes, so getting it right is entirely up to us!

Now we get truncation at runtime on Windows -- and a failing test. Truncation from a 64-bit signed integer to a 32-bit signed integer is implementation-defined behaviour in C. It is considered "safe" by Rust's definition, but it results in a platform specific logic bug:

> Absolute value of -9876543210: 1286608618

😬

## The real trouble is yet to come

For completeness, let's explore what happens if we incorrectly declare `labs` to accept and return an `i32`:

```rust
unsafe extern "C" {
    safe fn labs(input: i32) -> i32;
}
```

In this case, Windows would work fine, since `c_long` is 32-bits there. On macOS or Linux, the absolute function expects 64-bits and no longer produces an absolute value:

> Absolute value of -42: -42

Though this result isn't guaranteed. What we have here is genuine undefined behaviour (UB). 🙀

The `labs` function on macOS or Linux is expecting 64-bits, but we only provide 32-bits. That means the upper 32-bits could be garbage left-over in CPU registers. The result is undefined. In this case, the function should not even be marked as `safe`. As it says in [The Rust Programming Language][rustbook] book:

> Marking a function as `safe` does not inherently make it safe! Instead, it is like a promise you are making to Rust that it *is* safe.

At the time of this writing, the upcoming third edition of The Rust Programming Language book has a [similar example][rustbook], except they use `abs` instead of `labs`. That function doesn't exhibit the same issues, because C's `int` happens to be 32-bits on Windows, macOS, and Linux. Still, I have [opened an issue][bookissue] to request a few minor tweaks, in hopes of making readers aware of `std::ffi::c_int` and friends.

By using `std::ffi::c_long` in the previous example, the Rust type properly matches the C type, the FFI is safe, and the Rust compiler can help us out.

## Takeaways

* Save yourself a world of hurt by using Rust code from Rust if you can (e.g. [abs][]).
* Be wary of C code that uses `long` or `unsigned long`. In this instance, the C `abs` and `llabs` functions are preferable to `labs` because the former always uses 32-bit integers and the latter always uses 64-bit integers on modern platforms.
* Get in the habit of using `std::ffi::c_int` and friends at the FFI boundary.
* Remember that `std::ffi::c_long` isn't the same as `i32` or `i64` or even `isize`. It's something different. Likewise for `c_ulong` for unsigned long.
* It's a good idea to compile and test on multiple platforms if you can. GitHub Actions are your friend.

If you want to play around with the examples, the source code for my [little experiment][experiment] is up on GitHub. There's also a [pure C experiment][cexperiment] where Visual Studio (MSVC) provides adequate warnings, but only at warning level 3 or greater. Rust's compile-time errors are certainly an improvement, but only if the FFI boundary is declared correctly.

I hope you found this exploration of C `long` interesting.

Until next time. 👋🏼

[abs]: https://doc.rust-lang.org/1.88.0/std/primitive.i64.html#method.abs
[error]: https://doc.rust-lang.org/error_codes/E0308.html
[experiment]: https://github.com/nathany/learn.rs/tree/main/hello_ffi
[cexperiment]: https://github.com/nathany/learn.rs/tree/main/hello_ffi_c
[rustbook]: https://doc.rust-lang.org/stable/book/ch20-01-unsafe-rust.html#using-extern-functions-to-call-external-code
[bookissue]: https://github.com/rust-lang/book/issues/4443
[clippy]: https://github.com/rust-lang/rust-clippy/issues
[c_long]: https://doc.rust-lang.org/1.88.0/std/ffi/type.c_long.html

[^1]: What I find perplexing is that it's not a difference in CPU architecture (x64 vs. arm64), nor is it compiler-specific (clang will produce warnings on Windows but not on macOS or vice versa). It was a platform choice.
[^2]: It's totally reasonable that Microsoft wanted `long` to mean 32-bits on both 64-bit and 32-bit Windows systems for backwards compatibility, and I'm sure Unix systems had good reasons for making `long` 64-bit on 64-bit systems. It's the combination of both that warrants a face palm.

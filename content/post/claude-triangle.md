+++
title = "🤖 Sudo Make Me A Triangle"
description = "Graphics Programming with Claude Sonnet 4."
date = "2025-07-14"
keywords = ["Claude", "agentic", "Zed", "Rust", "Vulkan", "DirectX", "Direct3D"]
+++

So I've been exploring graphics programming again 🫖, with [Claude Sonnet 4][Claude] doing the heavy-lifting.

The goal: build a Bunny Mark sprite benchmark in 🦀 Rust, while exploring various graphics APIs and Rust crates.

Here's what we've done so far:

* Render a blue background with [Ash][] and [Vulkan][] -- yeah, I didn't make it all the way to a triangle[^1] 😅
* Attempt to modularize the Vulkan code with Claude
* Attempt to switch from Ash to [Vulkano][], a higher-level safe wrapper for Ash, to compare the diff
* Start over with [Direct3D 11][d3d11] and the [windows][] crate -- [this time successfully][fmdx]
* Experiment with Kenny Kerr's Direct3D 12 [triangle sample for Rust][d3d12rs] while finding my way around the [PIX][] profiler/debugger
* Complete a fresh Vulkan 1.4 implementation of [Ferris Mark][fmvk] with Kyle Mayes' [vulkanalia][]

This post is an exploration of what I've learned along the way with regards to:

* 🦀 the Rust language and its ecosystem
* 🌋 Vulkan and ☢️ DirectX
* 🤖 Claude and the intersection between AI and graphics programming

[Ash]: https://github.com/ash-rs/ash
[Vulkan]: https://www.vulkan.org/
[Vulkano]: https://github.com/vulkano-rs/vulkano
[windows]: https://github.com/microsoft/windows-rs/
[d3d11]: https://learn.microsoft.com/en-us/windows/win32/direct3d11/atoc-dx-graphics-direct3d-11
[d3d12rs]: https://github.com/microsoft/windows-rs/tree/master/crates/samples/windows/direct3d12
[PIX]: https://devblogs.microsoft.com/pix/introduction/
[vulkanalia]: https://github.com/KyleMayes/vulkanalia

[fmdx]: https://github.com/nathany/ferris-mark-dx
[fmvk]: https://github.com/nathany/ferris-mark-vk

## Some background

The last time I rendered a triangle was with OpenGL in 2012, and before that writing a software rasterizer in the 1990s. So I'm familiar with some of the concepts and terminology, but I still have much to learn.

Before I got started, I watched several talks from [Vulkanised][]. In particular, I recommend [So You Want to Write a Vulkan Renderer in 2025][vktalk] by Charles Giessen ([slides][vktalk-slides]). 🌋

[Vulkanised]: https://www.youtube.com/@Vulkan
[vktalk]: https://www.youtube.com/watch?v=7CtjMfDdTdg
[vktalk-slides]: vulkan.org/user/pages/09.events/vulkanised-2025/T41-Charles-Giessen-LunarG.pdf

As far as Rust, I'm still learning that too. Though I've started to read every edition of [The Rust Programming Language][rustbook], and still have notes from 2019, I've never made it through all 600 pages. I leaned on conference talks and resources like [Rust by Example][rustbyexample]. 🦀

[rustbyexample]: https://doc.rust-lang.org/rust-by-example/
[rustbook]: https://doc.rust-lang.org/book/

In terms of "agentic programming", I had some previous experience with Claude for web development.

## My setup

Windows 11

changing fast

[Claude Sonnet 4][Claude]
[Zed][]




50, 150, 500
300 requests free with GitHub Copilot Pro for OSS Maintainers
Claude free

This will become important later.

[Zed]: https://zed.dev/
[Claude]: https://www.anthropic.com/claude



Claude Desktop

agentic
build the code, run it and and see the logs

if this were pair programming
letting Claude drive


## Vulkan vs. DirectX

If I were to make a little game from scratch (*not* an engine), which graphics API should I use with Rust? That was one of the questions I hoped to answer through this whole exercise.

Spending a day watching another programmer (Claude) struggle with making a small application provided me with some valuable experience before I sink weeks into learning a particular option.

There are tradeoffs everywhere. Here are some pros and cons of each, at least in my opinion (subject to change).

### Vulkan

Upside

* The Vulkan SDK logs validation warnings/errors to the console (`stdout`), which show up in my editor and are visible to Claude.
* The validation layers include options for best practices and performance optimizations.
* Vulkan caught synchronization errors and provided useful guidance, rarely triggering a crash.
* Khronos Group has made it a priority to make Vulkan easier to use, e.g. by simplifying APIs
* All the learning materials, SPIR-V becoming the standard, and cross-platform support

Downside

* Massive API surface and a seemingly endless number of extensions -- its a lot to navigate
* GLSL is the default choice, but it hasn't received much attention, and Slang is based on HLSL syntax
* Less commonly used for shipping Windows games, raising some concerns around compatibility. See the list of **unsupported graphics cards** for [Tiny Glade][]
* Rust open source ecosystem requires patience (more on that later)

[Vulkan SDK]: https://www.lunarg.com/vulkan-sdk/
[Tiny Glade]: https://store.steampowered.com/app/2198150/Tiny_Glade/

### DirectX 12

Upside

* The `windows` crate is well-supported and "does it all"
* PIX debugger provides profiling and debugging all-in-one, rather than separate tools
* Unity uses HLSL so there should be a lot of examples, and Slang is based on HLSL syntax
* Single-platform and focused

Downside

* Synchronization is tricky,
* Windows Debug Output may be great for Visual Studio but isn't as readily accessible in other editors as `stdout`. Though this should be surmountable with custom code using `OutputDebugString` or `ID3D12InfoQueue`.
* Limited to Windows and Xbox

### DirectX 11

Upside

* Harkening back to the simpler days when memory and synchronization were (mostly) managed

Downside

* Tied to an older, slower shader compiler (FXC)
* No support for PIX for debugging and profiling

Targeting OpenGL 3.3 may be a similar situation, but I haven't explored it much.

### What about WebGPU?

I have yet to do the same deep dive  in WebGPU, or more specifically the `wgpu` crate for Rust, but here's what I understand to be true.

Upside

* A simpler but still modern low-level API, as with Metal, but on more platforms
* It's used by Bevy, a fairly popular Rust game engine

Downside

* Debugging could be more difficult, given that it's a layer on top of DirectX, Vulkan, and Metal. E.g. calling Vulkan through `wgpu`, `wgpu-hal`, and `ash` makes correlating a validation layer error back to your app more difficult than if you used Ash directly and understood its API (which is fairly 1:1 with the Vulkan API).
* Far less bleeding edge than the APIs it's built on top of
* The fact that Firefox [still hasn't shipped][caniuse] with WebGPU enabled by default is a giant red flag for me

[caniuse]: https://caniuse.com/?search=webgpu

## Rust


## Claude Highlights

So far I haven't come across any tutorials on using Direct3D with Rust 🦀, and very few samples. But fortunately Claude can help provide a sample to my specifications, as well as help bridge the C++ vs. Rust divide when I have questions.

Especially handy for asking Claude to explain an issue

## Claude Challenges

### Taking on too much at once



aiming for
step by step

incentives

### Tangents

get into trouble
downgrades
doesn't ask

not like pair programming

### Not Invented Here

Crates
tools

don't want AI going wild with installing every unvetted crate, it also

fastrand custom pseudo-code generation
shaderc SPIR-V


[cargofix]: https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-extern.html

### Modularity

RAII
memory model





## Takeaways



summarizing problems encountered
that could be me


AI makes it easier to throwaway the first draft
not precious about it

[^1]: Must've forgot to use sudo. Btw, the title is a reference to [xkcd][] 149: sudo make me a sandwich

[xkcd]: https://xkcd.com/149/

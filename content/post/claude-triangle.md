+++
title = "🤖 Sudo Make Me A Triangle"
description = "Graphics Programming with Claude Sonnet 4."
date = "2025-07-14"
keywords = ["Claude", "agentic", "Zed", "Rust", "Vulkan", "DirectX", "Direct3D"]
+++

So I've been exploring graphics programming once again, 🫖 with [Claude Sonnet 4][Claude] doing the heavy-lifting so far.

The goal: build a Bunny Mark sprite benchmark in 🦀 Rust, while exploring various graphics APIs and Rust crates.

Here's what we've done so far:

* Render a blue background with [Ash][] and [Vulkan][] -- yeah, I didn't make it all the way to a triangle.[^1] 😅
* Attempt to modularize the Vulkan code with Claude.
* Attempt to switch from Ash to [Vulkano][], a higher-level safe wrapper for Ash, to compare the diff.
* Start over with [Direct3D 11][d3d11] and the [windows][] crate -- [this time successfully][fmdx]! 🎉
* Experiment with Kenny Kerr's Direct3D 12 [triangle sample for Rust][d3d12rs] while finding my way around the [PIX][] profiler/debugger.
* Complete a fresh Vulkan 1.4 implementation of [Ferris Mark][fmvk] with Kyle Mayes' [vulkanalia][].

[<img alt="Ferris Mark VK" class="full" src="/images/ferris-mark-vk.gif">][fmvk]

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

The last time I rendered a triangle was with OpenGL in 2012, and before that it was writing a software rasterizer in the 1990s. So I'm familiar with some of the concepts and terminology, but I still have *much* to learn.

Before getting started, I watched several talks from [Vulkanised][]. In particular, I recommend [So You Want to Write a Vulkan Renderer in 2025][vktalk] by Charles Giessen ([slides][vktalk-slides]). 🌋

[Vulkanised]: https://www.youtube.com/@Vulkan
[vktalk]: https://www.youtube.com/watch?v=7CtjMfDdTdg
[vktalk-slides]: vulkan.org/user/pages/09.events/vulkanised-2025/T41-Charles-Giessen-LunarG.pdf

As far as Rust, I'm still learning that too. Though I've started to read every edition of [The Rust Programming Language][rustbook], and still have notes from 2019, I've never made it through all 600 pages. 😢 I've been leaning on conference talks and resources like [Rust by Example][rustbyexample].

[rustbyexample]: https://doc.rust-lang.org/rust-by-example/
[rustbook]: https://doc.rust-lang.org/book/

In terms of "agentic programming", I had some previous experience with [Claude][] and [MCP][] for web development.

[MCP]: https://modelcontextprotocol.io/introduction

## My setup

* Windows 11
* [Zed][] code editor[^2]
* [Claude desktop][ClaudeDesktop] or [claude.ai][]

Zed is one of many "agentic" editors. It can scan through project files, consult documentation online, edit code,
build it, run it and see the logs. If we were pair programming, it would be like letting Claude drive. It runs in a loop and can correct mistakes when a build fails or do `println!` debugging

I'm currently using [Claude Sonnet 4][Claude] in Zed with:

* GitHub Copilot Pro for OSS Maintainers includes 300 requests/month for free
* Zed includes 50 requests/month for free, or a 14-day trial of 150/month, and currently 500/month for $20 USD

These requests are essentially the number of prompts I can write, and for context, it's pretty easy to burn through 50-100 requests in one day if Claude is driving.

On the other hand, if I just want to ask Claude a general question, I will likely use my free account directly with Anthropic. I may even use them simultaneously, asking a question in Claude desktop to better understand something, while Zed churns away on some code changes.

[Zed]: https://zed.dev/
[Claude]: https://www.anthropic.com/claude

[claude.ai]: https://claude.ai
[ClaudeDesktop]: https://claude.ai/download

## Vulkan vs. DirectX

If I were to make a little game from scratch (*not* an engine), which graphics API should I use with Rust? That was one of the questions I hoped to answer through this whole exercise.

Spending a day watching another programmer (Claude) struggle with making a small application provided me with some valuable experience before I sink weeks into learning one in depth.

There are tradeoffs everywhere. Here are some pros and cons of each, at least in my opinion (subject to change).

### Vulkan

**Upside**

* The [Vulkan SDK][] logs validation warnings/errors to the console (`stdout`), which show up in my editor and are visible to Claude. 🤖
* The validation layers can optionally suggest best practices and performance optimizations.
* Vulkan caught synchronization errors and provided useful guidance, rarely triggering a crash.
* Khronos Group has made it a priority to make Vulkan easier to use, e.g. by simplifying APIs.
* All the learning materials, SPIR-V becoming the standard, and cross-platform support.

**Downside**

* Massive API surface and a seemingly endless number of extensions -- its a lot to navigate.
* Less commonly used for shipping Windows games, raising some concerns around compatibility. E.g. see the list of **unsupported graphics cards** for [Tiny Glade][].

[Vulkan SDK]: https://www.lunarg.com/vulkan-sdk/
[Tiny Glade]: https://store.steampowered.com/app/2198150/Tiny_Glade/

### DirectX 12

**Upside**

* The `windows` crate is well-supported and "does it all" (or at least a lot).
* Unity also uses HLSL so there should be a lot of examples, and Slang is based on HLSL syntax.
* PIX debugger provides profiling and debugging all-in-one, rather than separate tools.
* Single-platform focus is inherently simpler.

**Downside**

The out-of-the box developer experience was less than ideal, at least in Zed or Visual Studio Code:

* Synchronization can be tricky to get right, and mistakes cause crashes. 💥 When running under a debugger, the breakpoint triggered by the panic didn't make the issue obvious, at least not to me.
* A "potential clear color optimization" was not visible in `stdout` nor the debuggers in Zed or Visual Studio Code (CodeLDDB). Seeing the warning required taking a capture in PIX.
* A "redundant root signature error" was likewise not visible without taking a capture in PIX, and additionally enabling Windows Developer Mode and running one of three different analysis steps for additional warnings: Run Warnings Analysis, Run Debug Layer, Run GPU Validation.

### DirectX 11

**Upside**

* Harkening back to the simpler days when memory and synchronization were (mostly) managed.

**Downside**

* Tied to an older, slower shader compiler (FXC), though still commonly used.
* No support for PIX for debugging and profiling.

### What about WebGPU?

I have yet to do the same deep dive  in WebGPU, or more specifically the `wgpu` crate for Rust, but here's what I understand to be true.

**Upside**

* A comparatively simple, but still modern low-level API. Kind've like Metal, but on more platforms.
* It's used in Bevy, a fairly popular Rust game engine.

**Downside**

* Debugging could be more difficult, given that it's a layer on top of DirectX, Vulkan, and Metal. E.g. calling Vulkan through `wgpu`, `wgpu-hal`, and `ash` makes correlating a validation layer error back to your app more difficult than if you used Ash directly and understood its API (which is fairly 1:1 with the Vulkan API).
* Far less bleeding edge than the APIs it's built on top of.
* The fact that Firefox [still hasn't shipped][caniuse] with WebGPU enabled by default is a giant red flag for me.

[caniuse]: https://caniuse.com/?search=webgpu

## Claude Highlights

As it turns out, quality error messages from the Rust compiler and Vulkan validation layers are good for humans and for AI. It's almost like automated tests, except they are written once and used by many different apps. Claude can be left to churn away, revising code until the build has no errors, the tests pass, and the enabled validation layers are warning-free. Or take a more conservative approach, and ask Claude to summarize the issues, explain a particular error, or suggest what would fix it.


So far I haven't come across any tutorials on using Direct3D with Rust 🦀, and very few samples. But fortunately Claude can help provide a sample to my specifications, as well as help bridge the C++ vs. Rust divide when I have questions.

Especially handy for asking Claude to explain an issue

toggle validation layers
tokens in context

scratching the surface

[RenderDoc](https://renderdoc.org/)

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


[cargofix]: https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-extern.html#migration

### Modularity

RAII
memory model





## Takeaways



summarizing problems encountered
that could be me


AI makes it easier to throwaway the first draft
not precious about it



[^1]: Must've forgot to use sudo. Btw, the title is a reference to [xkcd][] 149: sudo make me a sandwich
[^2]: Zed for Windows is [compiled from source][zedwin] while awaiting a beta release

[xkcd]: https://xkcd.com/149/
[zedwin]: https://github.com/zed-industries/zed/blob/main/docs/src/development/windows.md

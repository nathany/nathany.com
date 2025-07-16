+++
title = "🤖 Sudo Make Me A Triangle"
description = "Graphics Programming with Claude Sonnet 4."
date = "2025-07-15"
keywords = ["Claude", "agentic", "Zed", "Rust", "Vulkan", "DirectX", "Direct3D", "Bunny Mark"]
+++

I've been exploring graphics programming once again, with [Claude Sonnet 4][Claude] doing the heavy-lifting.

The goal: build a Bunny Mark benchmark while exploring various graphics APIs and 🦀 Rust crates.

[<img alt="Ferris Mark VK" class="full" src="/images/ferris-mark-vk.gif">][fmvk]

Bunny Mark is just a few steps beyond the classic triangle, requiring textured quads with alpha blending, clamping for pixel-perfect scaling, some light "physics" for motion and collisions, basic metrics gathering, and sprite batching to minimize draw calls. Easy enough, right? 😅

This post is an exploration of what I've learned along the way with regards to:

* 🌋 Vulkan and ☢️ DirectX
* 🤖 Claude and the intersection between AI and graphics programming
* 🦀 the Rust language and ecosystem

## Some background

The last time I rendered a triangle was with OpenGL in 2012, and before that writing a software rasterizer in the 1990s. So I'm familiar with some of the concepts and terminology, but I still have *much* to learn.

As far as Rust, I'm still learning that too. Though I've started to read every edition of [The Rust Programming Language][rustbook], and still have notes from 2019, I've never made it through all 600 pages. 😞 I've been leaning on conference talks and resources like [Rust by Example][rustbyexample].

Before getting started, I watched several talks from [Vulkanised][]. In particular, I recommend [So You Want to Write a Vulkan Renderer in 2025][vktalk] by Charles Giessen ([slides][vktalk-slides]). 🌋

[Vulkanised]: https://www.youtube.com/@Vulkan
[vktalk]: https://www.youtube.com/watch?v=7CtjMfDdTdg
[vktalk-slides]: vulkan.org/user/pages/09.events/vulkanised-2025/T41-Charles-Giessen-LunarG.pdf

[rustbyexample]: https://doc.rust-lang.org/rust-by-example/
[rustbook]: https://doc.rust-lang.org/book/

## What I learned about 🌋 Vulkan and ☢️ DirectX

Ahh, the age-old question -- which graphics API should I use? And which 🦀 Rust crate should I use for bindings? If only I had more experience with them, then I could make a better decision!💡

But if I sunk days or weeks into reading tutorials and learning one option, then the sunk cost fallacy could set in. Would I really want to spend weeks learning multiple graphics APIs before getting to the good part? Probably not.

Fortunately we have a better option these days. With Claude's help, I was able to try out three different APIs (Vulkan, DX11, DX12) and three different Vulkan crates in just a few days.

Here's what we accomplished:

* Render a blue background with [Ash][] and [Vulkan][] -- yeah, I didn't make it all the way to a triangle.[^1] 😅
* Attempt to modularize the Vulkan code with Claude.
* Attempt to switch from Ash to [Vulkano][], a higher-level safe wrapper for Ash, to compare the diff.
* Start over with [Direct3D 11][d3d11] and the [windows][] crate -- [this time successfully][fmdx]! 🎉
* Experiment with Kenny Kerr's Direct3D 12 [triangle sample for Rust][d3d12rs] while finding my way around the [PIX][] profiler/debugger.
* Complete a fresh Vulkan 1.4 implementation of [Ferris Mark][fmvk] with Kyle Mayes' [vulkanalia][].

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


Spending a few days watching another programmer (Claude) struggle with making a small application provided some valuable insights. Based on my experience so far, here are some pros and cons.

### Vulkan

**Upside**

* The [Vulkan SDK][] logs validation errors/warnings to the console (`stdout`), which show up in my editor and are visible to Claude. 🤖
* The validation layers can optionally suggest best practices and performance optimizations.
* Vulkan caught synchronization errors and provided useful guidance, rarely triggering a crash.
* Khronos Group has made it a priority to make Vulkan easier to use, e.g. by simplifying APIs.
* All the learning materials (including for Rust), SPIR-V becoming the standard, and cross-platform support.

**Downside**

* Massive API surface and a seemingly endless number of extensions -- it's a lot to navigate.
* Less commonly used for shipping Windows games, raising some concerns around compatibility. E.g. see the list of **unsupported graphics cards** for [Tiny Glade][].

[Vulkan SDK]: https://www.lunarg.com/vulkan-sdk/
[Tiny Glade]: https://store.steampowered.com/app/2198150/Tiny_Glade/

### DirectX 12

**Upside**

* Single-platform focus is inherently simpler.
* The `windows` crate is well-supported and "does it all" (or at least a lot).
* Unity uses HLSL so there should be a lot of examples, and Slang is based on HLSL syntax.
* PIX debugger provides profiling and debugging all-in-one, rather than separate tools.

**Downside**

The out-of-the box developer experience was less than ideal, at least in Zed or Visual Studio Code:

* Synchronization can be tricky to get right, and mistakes cause crashes. 💥 When running under a debugger, the breakpoint triggered by a panic didn't make the issue obvious, at least not to me.
* A "potential clear color optimization" was not visible in `stdout` nor the debuggers in Zed or Visual Studio Code (CodeLDDB). Seeing the warning required taking a capture in PIX.
* A "redundant root signature error" was likewise not visible without taking a capture in PIX. Additionally, it required enabling Windows Developer Mode and running one of three different analysis steps for additional warnings: Run Warnings Analysis, Run Debug Layer, and Run GPU Validation.

### DirectX 11

I haven't come across any tutorials on using Direct3D with Rust 🦀, and very few samples. But fortunately Claude can help bridge that gap.

**Upside**

* Harkening back to the simpler days when memory and synchronization were managed.
* Far less code to get started and less bookkeeping.
* DirectWrite for text and Direct2D for vector graphics if desired.

**Downside**

* Tied to an older, slower shader compiler (FXC), though still commonly used.
* PIX requires D3D 11on12, which gave me some trouble. 💥 Fortunately there are [other][RenderDoc] [alternatives][tracy] that I could try.
* Last updated 10 years ago with DirectX 11.4.

### Why not WebGPU?

I haven't tried out WebGPU, or more specifically the `wgpu` crate for Rust. While it sounds compelling, these are show-stoppers for me:

* Given that it's a layer on top of DirectX, Vulkan, and Metal, I expect debugging to be more difficult. E.g. calling Vulkan through `wgpu`, `wgpu-hal`, and `ash` makes correlating validation layer errors back to an app more difficult than using Ash directly and understanding its API (which is fairly 1:1 with the Vulkan API).
* At the time of this writing, Firefox hasn't yet shipped with [WebGPU enabled by default][caniuse], which uses `wgpu`.

[caniuse]: https://caniuse.com/?search=webgpu

## Working with 🤖 Claude

The informative Vulkan validation layers and Rust compiler errors may have been designed for humans, but they're also great for AI.

I'm using the [Zed][] code editor on Windows,[^2] one of several "agentic" coding options. It provides Claude with tools to scan through project files, consult documentation, edit code, build it, run it, and so forth. Claude runs in a loop and can examine `stdout`, so it can correct mistakes when a build fails, or even do `println!` debugging. 🤯

If we were pair programming, it would be like letting Claude drive. Claude can churn away on a task, revising code until the build has no errors and the enabled validation layers are warning-free.

Note: It's best not enable all the validation layers all the time, as that can eat through Claude's context window very quickly. Leaving the best practice and performance layers off until after the errors are fixed seems like a good approach.

I've hardly scratched the surface of what's possible when using AI for graphics programming. For example, [RenderDoc][] and [Tracy Profiler][tracy] both have APIs and could be integrated into an AI-augmented workflow for debugging, profiling, reviewing screenshots, etc.

But of course not everything is rainbows and unicorns. 🌈 🦄

### Taking on too much at once

When I'm programming, I tend to make many small changes and get into that test-driven (TDD) cycle of red, green, refactor. 🚦

Claude will happily churn out tons of code without trying it out until the very end. This can often lead to trouble -- I've watched Claude revert several minutes worth of work on multiple occasions.

Part of this is on me. I'm still learning the domain, so I don't know how much work my prompt entails. As I learn to work with Claude, I am asking not only for a plan, but also an estimate of the magnitude of changes. That way I can provide more guidance to break problems down.

Unfortunately the per request payment model *incentivizes asking for large changes.* Requests are essentially the number of prompts I can write, so back and forth conversations burn through more requests. 🔥 While I like the simplicity of knowing how many prompts I have left, I'm pretty limited in how many requests I can make:

* GitHub Copilot Pro for OSS Maintainers includes 300 requests/month for free.
* Zed includes 50 requests/month for free
  * or a 14-day trial with 150 requests
  * or 500/month for $20 USD.[^3]

For context, it's pretty easy to burn through 50-100 requests in one day if Claude is driving.

### Going on tangents

When Claude gets into trouble, it doesn't stop to think or ask for a second opinion.

Dependency resolution conflicts are a good example.

We were trying to switch from Ash to Vulkano while still keeping the modern Vulkan features like dynamic rendering. Claude was struggling, so when I found and shared an example, I thought it would help. Then Claude decided to downgrade all the dependencies based on the example code. 😅

Likewise, when we attempted to move from manual memory management to `vulkanalia-vma`, Claude ran into version conflicts and decided to downgrade `vulkanalia`.[^4]

These downgrades weren't requested and involved significant code changes for older APIs. It's easy enough to revert, but it wastes time and energy.

So programming with Claude is like pair programming in some ways, but in other ways it's not. Most significantly, at least in my experience, Claude *rarely* asks questions.

One of the reasons for [Claude Code][] not being an editor is the expectation that software developers will soon be further removed from the code. If that's based on Claude operating at a senior engineer level within the next year, then I guess that makes sense. But whatever the case, that direction is at odds with AI as a copilot or pair programmer.

[Claude Code]: https://www.anthropic.com/claude-code

### Not invented here

Claude is perfectly capable of adding new crates, reviewing the documentation and so forth. But looking for a package in the midst of solving another problem doesn't seem to be a *tool* in Claude's toolbelt.

When reviewing some code, I found several lines of custom pseudo-random number generation. Claude can easily answer the question, "which random number crate should we use?" and then proceed to install `fastrand` and switch the code to it.

While setting up a new project, Claude found that the GLSL shaders weren't compiling. Instead of adding the `shaderc` crate, it started writing SPIR-V bytecode by hand! 😅

> "Compilers? Where we're going, we don't need compilers."

Now, it's probably a good thing that Claude isn't adding every package imaginable to a project. That could cause its own set of problems.
But using battle-tested libraries instead of rolling everything from scratch is a best practice.

Another case of *not invented here* is being unaware of `cargo fix --edition` when asked to upgrade a project to Rust 2024. Instead Claude started making all the changes by hand, decided it was too complex, and figured it should roll its own script.

As a human programmer, I'll default to the solution that is the least amount of effort and the most reliable. Like using existing libraries or looking for tools to help with an upgrade. To do otherwise would require a very compelling reason. Conservation of energy is part of being human -- maybe not so much for AI?

[cargofix]: https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-extern.html#migration

### Modularity

If left to its own devices, Claude will happily write an entire program in a single file with a giant AppData structure. What ever happened to single responsibility principle and the like?

While working on my first Vulkan attempt (with Ash), I decided to address the "modularity problem" by asking Claude to break the code up into separate files for device, swapchain, etc. This was probably a mistake.

Being new to the domain, I don't know where to draw the boundaries in the best possible way. The guidance I provided may have been wrong or insufficient.

These low-level graphics APIs are already tricky enough. There's CPU memory and Rust's take on RAII, alongside GPU memory and all the timing and synchronization issues. There's going back and forth between whether to manually clean up GPU resources or to use Drop, which makes the order of fields in structures matter.

Based on my observations, I think trying to add structure to the code exacerbated these issues and made everything more difficult.

That's not to say that I don't want structure. Just that it will come in due time, once I've learned more and I'm working on a real project instead of a prototype. Will I ask Claude to write the code to create that structure? Right now, I'm thinking not, but we shall see.

## Conclusion

Overall I think this was a very beneficial experience.

Whenever the chime sounds in Zed, I look through the summary of what Claude accomplished. Having noticed Claude struggle at times, I added a line to the [.rules](https://zed.dev/docs/ai/rules) file to also summarize the problems encountered. Every dependency conflict, validation layer error, and fight with the Rust borrow checker is a reminder: **that could be me!**

These are all challenges I expect to face when I go to write something myself. But I take comfort in knowing that I can switch Zed from "Write" to "Ask" and request Claude's help with any problems that arise.

That makes tackling something as big and complex as graphics programming a little less scary.

🤖 ❤️ 🫖

[^1]: I must've forgot to use sudo. The title is a reference to [xkcd 149][xkcd]: sudo make me a sandwich.
[^2]: Zed for Windows is [compiled from source][zedwin] while awaiting a beta release. It's pretty rough.
[^3]: GitHub Copilot Pro+ includes 1500 requests/month for $39 USD, a much better deal than Zed Pro, I know. 🤷🏼‍♂️
[^4]: These dependency conflicts with `vulkanalia-vma` have been fixed in the [latest release](https://github.com/KyleMayes/vulkanalia/blob/master/ext/vma/CHANGELOG.md#030---2025-07-14).

[Zed]: https://zed.dev/
[Claude]: https://www.anthropic.com/claude

[xkcd]: https://xkcd.com/149/
[zedwin]: https://github.com/zed-industries/zed/blob/main/docs/src/development/windows.md

[tracy]: https://github.com/wolfpld/tracy
[RenderDoc]: https://renderdoc.org/
[rgp]: https://gpuopen.com/rgp/

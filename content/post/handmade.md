+++
title = "🧶 Handmade Games"
description = "On platforms, playtesting and open source."
date = "2026-11-15"
keywords = ["code", "programming", "handmade", "game development", "Windows", "Steam", "playtesting", "open source"]
+++

As I embark on a journey to learn game development from scratch, these are my thoughts on platform support, playtesting and open source. This smattering of topics all relate to what and how I'm planning to learn, build, document and share.

## Deep, not wide

These days much of software is written to be cross-platform. It's often lowest common denominator⚛ or more complex. Given that I'm a solo dev, I'd prefer to narrow my focus and really understand a single platform well.

My current plan is to target Windows 11, Windows 10 and SteamOS (via Proton). I have nothing against macOS and Linux -- and there's plenty to dislike about Windows. This is just the reality of where indie gamers play, according to the [Steam survey][].

I'm also planning to stick with Direct3D on Windows. That's despite my [earlier experiments](/claude-triangle) finding real merit in the Vulkan debug layers and quality of the Vulkan SDK.

Steam and the Steamworks SDK are also part of the platform I'm targeting. Even if I appreciate the missions of Good Old Games and Humble Bundle, Steam is where it's at.

If I'm building anything real, I will isolate platform code so that I can expand it later. But that expansion can come much, much later.

[Steam survey]: https://store.steampowered.com/hwsurvey/Steam-Hardware-Software-Survey-Welcome-to-Steam

## Playtesting

Instead of making web builds for Itch.io to gather feedback on early prototypes, I like the idea of in person playtesting. I got the idea at a local game developer meetup.

Logan Gilmour brought his Steam Deck with an early version of [Rebounder][], allowing a number of people to try his game. Not only did he receive feedback, he was able to observe people playing. Like a proper UX test!

And I suspect that the risk of copycats may be lower when meeting people in person or through private Steam Playtests.

[Rebounder]: https://store.steampowered.com/app/3794520/Rebounder/

## Marketing

Sharing early prototypes online isn't just for user feedback, but also a form of marketing. So what will I do about that? I don't quite know yet.

Witness the death of my social media presence: 🪦

- January 2008 - January 2023 -- Twitter
- March 2013 - December 2023 -- Facebook
- January 2015 - December 2023 -- Instagram
- August 2011 - August 2026 -- Reddit

This is fine. 🔥

But maybe trying to build a social media presence from zero isn't the best idea anyway. _How To Market A Game_ suggests that online self-promotion only brings in a trickle of wishlists, unless you already have a huge following.

It's far more effective to find people who have a huge following, and ask them to try your game. Cold calling hundreds of people is very uncomfortable. But until I actually make a game, I'm not going to worry about it.

## Code sharing

Maintaining open source is hard. I have first hand experience from taking over maintenance of fsnotify for Go. Despite asking for help and generously providing commit access, I always felt overwhelmed by the issues and pull requests. Like a second job. Fortunately that is behind me now, because managing open source projects has only gotten more challenging.

While I am happy to contribute to open source projects where I can, I have no plans to create open source libraries on my own. Instead, my approach will be to write articles with supplementary example code.

## Upcoming

Now that I have established a direction, you should have a reasonable idea of what to expect from future blog posts.

To start, I'm planning to delve into some old school Win32 APIs. Yup, traveling back in time to the late 90s, and then wrapping that up in a [modern C alternative](/why-odin). I'm thinking about anything that could be useful for developing games and game tools on the platform.

Interspersed with that, I'll be learning Direct3D 11 & 12 (bindless), and refreshing my linear algebra knowledge. I may also write a post on my toolchain and how to get setup. And if I make any progress in my quest to learn art and music, I'll be sure to share that too.

You also know what I won't be covering. No web builds, no free-to-play mobile monetization schemes, no trying to support every platform and no more of [my AI ramblings](/claude-triangle).[^1]

So, speaking of the 90s, if any of this sounds interesting to you, feel free to add my feed to your RSS reader.

Thanks.

[^1]: [Listen to Anton][LLMephants] for an actually thought provoking and fun take on <mark>LLMephants</mark>. 🐘

[LLMephants]: https://www.youtube.com/watch?v=mf4doUWkZz4

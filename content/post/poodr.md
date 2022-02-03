+++
title = "📕 Reviewing Practical Object-Oriented Design"
date = "2013-01-10"
revised = "2022-01-31"
description = "Sandi Metz wrote a book on Object-Oriented Design. It is well worth the read."
keywords = ["ruby", "book review", "Object Oriented Design", "monolithic", "change", "abstract", "duck typing", "oop"]
+++

Object-oriented programming is like a comfortable old hat. Classes, inheritance, polymorphism -- I learned all that 20 years ago -- with C++. What more is there to know about OO?

As it turns out, **quite a lot.**

<cite>[Practical Object-Oriented Design][poodr]</cite> is a <mark>must read</mark> for any Rubyist. My copy is full of highlights, but I'll focus on a few key takeaways.

## Change

Who hasn't experienced the big "monolithic" app? A *seemingly* small change causes ripples throughout the code base. The tests are broken more often than they are helpful. We tell the customer that "it wasn't designed to support that." Productivity and moral are down. What's the solution?

In software, **change is inevitable.** We can't predict *how* it will change, but we know it will.

What if we could <mark>arrange our code</mark> to be more amenable to change? That would be worth learning.

> "Design is more the art of preserving changeability than it is the act of achieving perfection."

[Sandi Metz][metz] sets us out on a journey towards changeability. She guides us through a number of **OO design principles**, when and why they are valuable. Dedicated chapters cover inheritance, composition, duck typing and mixins, with tips to choose among them. The goal throughout is to increase productivity and reduce costs.

## Dependencies

Objects will have dependencies -- they need to talk to each other. The key to avoid "[complect][]" code is to <mark>choose dependencies wisely</mark>.

> "Applications that are easy to change consist of classes that are easy to reuse. Reusable classes are pluggable units of well-defined behavior that have few entanglements."

Dependencies can include the name of a class or method, the order of arguments, or the requirement to call `super`. Start by minimizing dependencies that aren't necessary.

Then consider which direction dependencies should go. <mark>Depend on things that change less often.</mark>

## Trust

Procedural programs operate by performing a series of steps, whereas object-oriented programs are about <mark>sending messages</mark>.

When one object tells another to perform a series of steps, <mark>it knows too much</mark>! To minimize dependencies, an object needs to ask for what it wants, and **trust** that the  receiver takes the necessary steps. It doesn't need to know the details.

> "The distinction between a message that asks for what the sender wants and a message that tells the receiver how to behave may seem subtle but the consequences are significant."

## Ducks

Rather than depending on a concrete `Class`, consider relying on a duck type that implements the necessary message. Depending on a "duck-like" thing is much more flexible.

> "Good design naturally progresses toward small independent objects that rely on abstractions... Abstractions are wonderfully flexible design components but the improvements they provide come at one slight cost: While each individual abstraction might be easy to understand, there is no single place in the code that makes obvious the behavior of the whole."

Think about the duck types being used, and use tests to document them.

## Test

The final chapter is on *designing* tests, and is well worth the entry price alone.

> "Well-designed code is easy to change, refactoring is how you change from one design to the next, and tests free you to refactor with impunity."

Sandi shows how to avoid tight coupling between tests and production code, while maintaining insight into production code failures.

She also explains why not everything should be tested, and what should be:

> "Incoming messages should be tested for the state they return. Outgoing command messages should be tested to ensure they get sent. Outgoing query messages should not be tested."

## Code

For a book that touts <mark>exemplary code</mark>, it might come as a surprise that not every code example can be considered exemplary. On occasion, Sandi *purposely* drags the reader through the consequences of not designing for change.

Each chapter begins with a bicycle-themed example. The example is altered as the chapter progresses -- new requirements are introduced, issues are identified, code is refactored.

Walking through the process is incredibly informative, much more so than only seeing the final result.

## Finalize

I'm really glad to have read [POODR][]. Sandi's writing is eminently practical, giving the reader an OO toolbox to work with, and plenty of sound advice. The small, focused examples really help drive home the concepts.

At ~240 pages, no words are wasted. If you're still not convinced, you can get a flavour for the book by watching <cite>[Less - The Path to Better Design][talk]</cite> from Øredev and <cite>[The Magic Tricks of Testing][talk2]</cite> from RubyConf.

[metz]: https://twitter.com/sandimetz

[poodr]: https://www.poodr.com/

[talk]: https://vimeo.com/53154357

[complect]: https://www.infoq.com/presentations/Simple-Made-Easy

[talk2]: https://www.youtube.com/watch?v=URSWYvyc42M

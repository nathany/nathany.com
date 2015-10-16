+++
title = "Go Object Oriented Design"
date = "2013-01-14"
revised = "2014-08-18"
summary = "Composition not inheritance, polymorphism through interfaces, and packages for namespacing."
keywords = ["golang", "OOP", "Object Oriented Design", "Go", "composition", "interfaces", "types", "values"]
+++

Go has <mark>types and values</mark> rather than classes and objects. So can a language without classes or objects be object-oriented?

While Go may not fit the typical mold of an OOP language, it does provide many of the same features, albeit in a slightly different way:

* methods <mark>on any type</mark> we define, with no boxing or unboxing
* automatic message delegation via <mark>embedding</mark>
* polymorphism via <mark>interfaces</mark>
* namespacing via <mark>exports</mark>

There is [no inheritance][composition] in Go, so leave those *is-a* relationships at the door. To write Go, we need to think about OO design in terms of **composition**.

> "Use of classical inheritance is always optional; every problem that it solves can be solved another way." - [Sandi Metz][poodr]

## Composition by Example

Having recently [read][] through [Practical Object-Oriented Programming in Ruby][poodr], I decided to [translate][] the examples to Go.

Chapter 6 presents a simple problem. A mechanic needs to know which spare parts to bring on a bike trip, depending on which bikes have been rented. The problem can be solved using classical inheritance, where `MountainBike` and `RoadBike` are specializations of a `Bicycle` base class. Chapter 8 reworks the same example to <mark>use composition instead</mark>. I'm quite happy with how well this version [translated to Go][GitHub]. Let's take a look.

### Packages

```go
package main

import "fmt"
```

Packages provide a namespace. The `main()` function of the `main` package is where a program begins. The `fmt` package provides string formatting functions.


### Types

```go
type Part struct {
    Name        string
    Description string
    NeedsSpare  bool
}
```

We define a new type named Part. This structure is very much like a C struct.

```go
type Parts []Part
```

The Parts type is a *slice* of Part values. Slices are variable-length arrays, which are more common in Go than their fixed-length brethren.

### Methods

We can declare methods on any user-defined type, so Parts can have <mark>all the behavior of slices, plus our own custom behavior.</mark>

```go
func (parts Parts) Spares() (spares Parts) {
    for _, part := range parts {
        if part.NeedsSpare {
            spares = append(spares, part)
        }
    }
    return spares
}
```

A method declaration in Go is just like a function, except it has an <mark>explicit receiver</mark>, declared immediately after `func`. This function also takes advantage of named return variables, pre-initializing spares for us.

The method body is fairly straightforward. We iterate over parts, ignoring the index position (`_`), filtering the parts to return. The `append` [builtin][] may need to allocate and return a larger slice, as we didn't preallocate its capacity.

This code isn't nearly as elegant as `select` in Ruby. A functional filter [is possible in Go][filter], but it isn't [builtin][].

### Embedding

```go
type Bicycle struct {
    Size string
    Parts
}
```

Bicycle is *composed of* a Size and Parts. By not specifying a named field for Parts, we make use of [embedding][]. This provides *automatic delegation* with no further ceremony, eg. `bike.Spares()` and `bike.Parts.Spares()` are equivalent.

If we were to add a `Spares()` method to Bicycle, it would take precedence, but we could still reference the embedded `Parts.Spares()`. This may *feel* like inheritance, but <mark>embedding does **not** provide polymorphism.</mark> The receiver for methods on Parts will always be of type Parts, even when delegated through Bicycle.

Patterns used with classical inheritance, like the template method pattern, aren't suitable for embedding. It's far better to think in terms of composition & delegation, as we have here.


### Composite Literals

```go
var (
    RoadBikeParts = Parts{
        {"chain", "10-speed", true},
        {"tire_size", "23", true},
        {"tape_color", "red", true},
    }

    MountainBikeParts = Parts{
        {"chain", "10-speed", true},
        {"tire_size", "2.1", true},
        {"front_shock", "Manitou", false},
        {"rear_shock", "Fox", true},
    }

    RecumbentBikeParts = Parts{
        {"chain", "9-speed", true},
        {"tire_size", "28", true},
        {"flag", "tall and orange", true},
    }
)
```

Go provides a nice syntax for initializing values, called [composite literals][]. Being able to initialize a struct with an array-like syntax made the PartsFactory from the Ruby example feel unnecessary.

```go
func main() {
    roadBike := Bicycle{Size: "L", Parts: RoadBikeParts}
    mountainBike := Bicycle{Size: "L", Parts: MountainBikeParts}
    recumbentBike := Bicycle{Size: "L", Parts: RecumbentBikeParts}
```

Composite literals can also use a `field: value` syntax, in which all fields are optional.

The short declaration operator (`:=`) uses <mark>type inference</mark> to initialize roadBike, etc. with the Bicycle type.

### Output

```go
    fmt.Println(roadBike.Spares())
    fmt.Println(mountainBike.Spares())
    fmt.Println(recumbentBike.Spares())
```

We print the the result of calling Spares in the default format:

```
[{chain 10-speed true} {tire_size 23 true} {tape_color red true}]
[{chain 10-speed true} {tire_size 2.1 true} {rear_shock Fox true}]
[{chain 9-speed true} {tire_size 28 true} {flag tall and orange true}]
```

### Combining Parts

```go
    comboParts := Parts{}
    comboParts = append(comboParts, mountainBike.Parts...)
    comboParts = append(comboParts, roadBike.Parts...)
    comboParts = append(comboParts, recumbentBike.Parts...)

    fmt.Println(len(comboParts), comboParts[9:])
    fmt.Println(comboParts.Spares())
}
```

Parts behaves like a slice. Getting the length, slicing the slice, or combining multiple slices all works as usual. 

It would seem that the equivalent solution in Ruby is to subclass Array, but unfortunately Ruby "misplaces" the spares method when two Parts are concatenated (update: Steve Klabnik [goes into detail](http://words.steveklabnik.com/beware-subclassing-ruby-core-classes)).

> "...in a perfect object-oriented language this solution would be exactly correct. Unfortunately, the Ruby language has not quite achieved perfection..." - [Sandi Metz][poodr]

## Interfaces

Polymorphism in Go is provided by interfaces. They are <mark>satisfied implicitly</mark>, unlike Java or C#, so interfaces can be defined for code we don't own.

Compared to duck typing, <mark>interfaces are statically checked</mark> and documented through their declaration, rather than through writing a series of `respond_to?` tests.

> "It is impossible to create an abstraction unknowingly or by accident; in statically typed languages defining an interface is _always_ intentional." - [Sandi Metz][poodr]

For a simple example, let's say we didn't want to print the NeedsSpare flag of Part. We could write a String method as such:

```go
func (part Part) String() string {
    return fmt.Sprintf("%s: %s", part.Name, part.Description)
}
```

Then the calls to `Println` above would output this instead:

```
[chain: 10-speed tire_size: 23 tape_color: red]
[chain: 10-speed tire_size: 2.1 rear_shock: Fox]
[chain: 9-speed tire_size: 28 flag: tall and orange]
```

This works because we have satisfied the Stringer interface, which the `fmt` package makes use of. It is defined as:

```go
type Stringer interface {
    String() string
}
```

Interface types can be used in the same places as other types. Variables and arguments can take a Stringer, which accepts anything that implements the `String() string` method signature.

## Exports

Go uses packages for namespacing. Exported identifiers begin with a capital letter. To make an identifier internal to a package, we start it with a lowercase letter:

```go
type Part struct {
    name        string
    description string
    needsSpare  bool
}
```

Then we could export setter and getter methods:

```go
func (part Part) Name() string {
    return part.name
}

func (part *Part) SetName(name string) {
    part.name = name
}
```

It's easy to determine what is using the public API vs. internal fields or methods. Just look at the case of the identifier (eg. `part.Name()` vs. `part.name`).

Notice that we don't prefix [getters][] with Get (eg. `GetName`). Getters aren't strictly necessary either, especially with strings. When the need arises, we can always change the Name field to use a custom type that satisfies the Stringer interface.

### Finding Some Privacy

Internal names (`lowerCase`) can be accessed from anywhere in the same package, even if the package contains multiple structs across multiple files. If you find this unsettling, packages can also be as small as you need.

It is good practice to use the *(more stable)* public API when possible, even from within the same class in classical languages. Go's use of capitalization
makes it easy to see where this is the case.

## For Great GOOD

Composition, embedding and interfaces provide powerful tools for Object-Oriented Design in Go.

While Idiomatic Go requires a change in thinking, I am pleasantly surprised with how simple and concise Go code can be when playing to its strengths.

*Comment on [Go+][], [Hacker News][HN2], [reddit][], [LinkedIn][], or the [Go Nuts mailing list][gonuts].*

> "So few people realize that classes and inheritance are mostly historic accidents and not real needs for good OOD." - Javier Guerra via Go+

> "This is excellent stuff. It helps who looks for correspondences at least to get started. Some people will inevitably look for OO analogies when learning Go (like I did!), but the official docs avoid them like the plague." - Rodrigo Moraes via Go+

> "Seconding +Rodrigo Moraes here, excellent stuff. I think this would have accelerated my own learning curve, where I've kept looking for classical OO approaches. Thanks for the writeup." - Levi Cook via Go+ and [Twitter](https://twitter.com/levicook/status/291238998867861504)

> "Great article, really enjoyed it! Well structured and example code seems to be good. Will be going over this again tomorrow and adding some of the tricks I wasn't aware of to my toolbox." - codygman via [HN][]

> "This article was great. I come from the land of C#(and Python, js) and this really cleared up a lot of questions I had about how OO works in Go." - TinyGoats via reddit

> "Great post! Having also read POODR, it's great to see how well Go fares in terms of concise-ness and expressiveness against a language like ruby." - Benjamin Moss via LinkedIn

> "Yes, indeed, good post" - Alexander Zhaunerchyk via LinkedIn

> "Enjoyed this one. Still trying to wrap my head around some of it." - Sammy Moshe via LinkedIn

> "A great introduction to the Go language from @nathany: "Go Object Oriented Design" - Pat Shaughnessy via [Twitter](https://twitter.com/pat_shaughnessy/status/290856086695718912)

> "There is an awesome article written by Nathan Youngman which I highly recommend every beginner should read. It really put many details into perspective for me." - Alejandro Gaviria via [Personal Ramblings](http://mikebeale.blogspot.ch/2012/07/dumping-php-for-go.html)

> "Your article is a great introduction to Go. I sure could have benefited from reading it before throwing myself in!" - Andrew Mackenzie-Ross via [mackross.net][mackross]

Related:

* [Is Go An Object Oriented Language?](http://spf13.com/post/is-go-object-oriented) by Steve Francia
* [Go is a great OO language](https://www.youtube.com/watch?v=HqZQBmNVhBw) by John Cinnamond (video, 4 minutes)
* [Go for Rubyists](https://blog.engineyard.com/2014/intro-to-go-rubyists) by Adrian Zankich


[LinkedIn]: http://lnkd.in/mxNfUb
[Go+]: https://plus.google.com/104313268939103200754/posts/Q59rppGdyUR
[HN]: http://news.ycombinator.com/item?id=5058678
[HN2]: https://news.ycombinator.com/item?id=6392545
[reddit]: http://www.reddit.com/r/golang/comments/16lli8/go_object_oriented_design/
[gonuts]: https://groups.google.com/d/topic/golang-nuts/OWINbSIe5hc/discussion

[read]: /poodr
[poodr]: http://www.poodr.info/
[composition]: http://talks.golang.org/2012/splash.article#TOC_15.

[translate]: https://github.com/nathany/go-poodr/
[GitHub]: https://github.com/nathany/go-poodr/blob/master/chapter8/parts3.go

[embedding]: http://golang.org/doc/effective_go.html#embedding
[builtin]: http://golang.org/pkg/builtin/
[composite literals]: http://golang.org/doc/effective_go.html#composite_literals
[getters]: http://golang.org/doc/effective_go.html#Getters

[filter]: https://gobyexample.com/collection-functions
[mackross]: http://mackross.net/objc/2013/07/23/objective-c-lessons-from-go/

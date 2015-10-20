+++
title = "Get ready, get set, Go"
date = "2015-10-19"
keywords = ["golang", "book", "Manning", "learn"]
description = "An excerpt from Learn Go, a beginner's guide to Go, that I'm writing with Manning Publications."
+++

[Learn Go]: https://manning.com/books/learn-go?a_aid=nathany&a_bid=53f68821
[playground]: https://play.golang.org
[playground.go]: https://play.golang.org
[mars.go]: https://play.golang.org/p/NVt8w6GhPx
[travel.go]: https://play.golang.org/p/WwaBM472vC
[rand.go]: https://play.golang.org/p/EYbLe8uaqO
[loop.go]: https://play.golang.org/p/Rvgb78U8D6
[if.go]: https://play.golang.org/p/XUHfCMpb2S
[switch.go]: https://play.golang.org/p/MPFnfrwNzj
[fmt.go]: https://play.golang.org/p/v4n7eJGd2J
[tickets.go]: https://play.golang.org/p/oluEimZNj0

The following article is an excerpt from [Learn Go][], a book I'm writing with Manning Publications. All illustrations are by [Olga Shalakhina](https://twitter.com/OlgaShalakhina), based on the Go gopher designed by [Ren&eacute;e French](https://twitter.com/reneefrench).

## Introducing the Go Playground
The quickest way to get started with Go is to navigate to [play.golang.org][playground]. The Go Playground enables you to edit, run, and experiment with Go without needing to install anything. When you click the **[Run]** button, the Playground will compile and execute your code on Google servers and display the result.

<figure>
    <img alt="The Go Playground" class="full" src="/images/playground.png">
    <figcaption>The Go Playground</figcaption>
</figure>

The Go Playground does have some limitations. For example, the only way you can save your work is by clicking the **[Share]** button and keeping a list of bookmarks. Most gophers prefer to use a text editor and the command line running on their own computer, but you can become comfortable with Go with just your web browser.

## Packages and functions
When you visit the Go Playground, you will see the following code, which is as good a starting point as any.

<a name="playground.go"></a>
```go
package main // #1

import "fmt" // #2

func main() { // #3
    fmt.Println("Hello, playground") // #4
}
```
Listing 1. Hello, playground: [playground.go][]

1. Declare the package the following code belongs to
2. Make the `fmt` (format) package available for use
3. Declare a function named main
4. Print *Hello, playground* to the screen

Though short, the previous listing introduces three keywords: `package`, `import`, and `func`. Each keyword is reserved for a special purpose.

The `package` keyword declares the package this code belongs to, in this case a package named `main`. All code in Go is organized into _packages_. Go provides a standard library comprised of packages for math, compression, cryptography, manipulating images, and more. Each package corresponds to a single idea. The next line uses the `import` keyword to specify which packages this code will use.

<img alt="Hello World gopher" class="left" src="/images/learn-go-hello-world.svg">

Packages contain any number of useful functions, for example, the `math` package provides functions like `Sin`, `Cos`, `Tan`, and `Sqrt` (square root). The `fmt` package provides functions for _formatted_ input and output. Displaying text to the screen is a frequent operation, so this package name is abbreviated as `fmt`.

The `func` keyword declares a function, in this case a function named `main`. The body of each function is enclosed in curly braces `{}`, so Go knows where each function begins and ends.

<img alt="A game board" class="right" src="/images/learn-go-start-somewhere.svg">
Every program needs to start somewhere. When you run a program written in Go, it starts at the `main` function in the `main` package. Without `main`, the Go compiler will report an error, because it doesn't know where the program will start.


To print a _line_ of text, you can use the `Println` function. `Println` is prefixed with `fmt` followed by a dot because it is provided by the `fmt` package. Every time you use a function from an imported package, the function is prefixed with the package name and a dot. When you read code written in Go, it is immediately clear which package each function came from.

When you run the program in the Go Playground, you see the text _Hello, playground_. The text to be displayed is enclosed in `"quotes"`. You know punctuation is important in English; a missing comma could change the meaning of a sentence. Go relies heavily on punctuation, like braces and quotes, to understand what you write.

#### Experiment
Make the following changes to the code in the Go Playground:

* Change the text printed to the screen by modifying what appears between quotes.
* Try printing text in Chinese, Japanese, Russian, or Spanish. Go supports characters of every language.

If you get stuck, you can refresh your browser to get back to the first example.

## Performing calculations

<img alt="Overweight gopher" class="right" height="240" src="/images/learn-go-plump.svg">

There are days when I think it would be nice to be younger and weigh a little less. In this regard, Mars has a lot to offer. It takes 687 earth days for Mars to travel around the sun, and a lower gravitational force means everything weighs approximately 38% of what it does on Earth.


The following program helped me calculate how young and light I would be if I lived on Mars. Type and run it in the Go Playground.

<a name="mars.go"></a>
```go
// My weight loss program. // #1
package main

import "fmt"

// main is the function where it all begins. // #1
func main() {
    fmt.Print("My weight on the surface of Mars is ")
    fmt.Print(210.0 * 0.3783) // #2
    fmt.Print(" lbs, and I would be ")
    fmt.Print(38 * 365 / 687) // #3
    fmt.Print(" years old.")
}
```

Listing 2. Hello Mars: [mars.go][]

1. A comment for human readers
2. Print *79.443*
3. Print *20*

This code begins with a comment. When Go sees a double slash, it ignores everything until the end of the line. Computer programming is all about communication. Code communicates your instructions to a computer, and when written well, it communicates your intentions to other people. Comments are just for us.

The previous listing calls the `Print` function several times to display a sentence on a single line. As you saw in [Listing 1](#playground.go), text is placed between double quotes. This program also displays the result of mathematical expressions.

#### Experiment
Before you make travel plans, use Go to find out a little more about life on Mars:

* How much would you weigh on Mars? How old would you be? Replace my age (38) and weight (210.0) with your own. Try family members, pets, and friends.

    <i class="fa fa-sticky-note-o fa-2x fa-pull-left fa-border" title="Note"></i> [Listing 2](#mars.go) displays weight in pounds, but the unit doesn't impact the weight calculation. Whichever unit you use, the weight on Mars is 37.83% of the provided weight. On the other hand, mass is 100% the same.

* Did you notice that your age on Mars is displayed as a whole number while your weight has a decimal? What happens if you specify that an Earth year has precisely 365.2425 days?
* What happens if you use the `Println` function instead of `Print`?
* To display text, numbers, and mathematical expressions, you can pass the `Print` function a list of arguments separated by commas:

    `fmt.Print("I am ", 38*365/687, " years old on Mars.")`

    Modify [Listing 2](#mars.go) to display the same output with only one call to the `Print` function.


<i class="fa fa-lightbulb-o fa-2x fa-pull-left fa-border" title="Tip"></i> After modifying your code, click the **[Format]** button in the Go Playground. It will automatically reformat the indentation and spacing of your code without changing what it does.

## Constants and variables
Now that I see the benefit of going to Mars, my next question is how long the trip will take. Traveling at the speed of light would really be ideal. Light travels at a _constant_ speed in the vacuum of space, which makes the math easy. On the other hand, the distance between Earth and Mars _varies_ significantly, depending on where each planet is in its orbit around the sun.

The following listing introduces two new keywords, `const` and `var` for declaring constants and variables respectively.

<a name="travel.go"></a>
```go
// How long does it take to get to Mars?
package main

import "fmt"

func main() {
    const lightSpeed = 299792 // km/s
    var distance = 56000000   // km

    fmt.Println(distance/lightSpeed, "seconds") // #1

    distance = 401000000
    fmt.Println(distance/lightSpeed, "seconds") // #2
}
```

Listing 3. Traveling at the speed of light: [travel.go][]

1. Print *186 seconds*
2. Print *1337 seconds*

The first calculation is based on Mars and Earth being nearby, with `distance` declared and assigned an initial value of 56,000,000 km. Then the `distance` variable is assigned a new value of 401,000,000 km, with the planets on opposite sides of the sun.

The `lightSpeed` constant cannot be changed. If you try to assign it a new value, the Go compiler will report the error "cannot assign to lightSpeed".

<i class="fa fa-lightbulb-o fa-2x fa-pull-left fa-border" title="Tip"></i> Variables must be declared before they are used. Go will report an error if you assign to a variable that hasn't been declared with `var`, for example `speed = 16`. This can help catch mistakes, like accidentally assigning a value to `distant` when you intend to use `distance`.

#### Experiment
Type [Listing 3](#travel.go) into the Go Playground and click **[Run]**. Light speed is pretty convenient; I don't hear anyone asking "are we there yet?"

Unfortunately these calculations aren't the most realistic. Plotting a course directly through the sun could be problematic, and while traveling at light speed would be nice, the fastest spaceships today only manage 16 km/s. You can bring this program down to Earth with these changes:

* Declare a new `speed` variable and use it in place of `lightSpeed` to calculate the trip duration at 16 km/s.
* Print the trip's duration as a number of days instead of seconds.

    <i class="fa fa-lightbulb-o fa-2x fa-pull-left" title="Tip"></i> There are 86400 seconds in one Earth day.

* Mars and Earth will be 57,600,000 km apart in July 2018. Calculate the trip duration for this launch window.

## Faking it with random numbers
<img alt="A traveling gopher" class="right" src="/images/learn-go-travel.svg">
Finding an affordable ticket to Mars could be a challenge. If only there was a ticket aggregator that listed tickets on every spaceline, but a Google search turned up nothing. Looks like an opportunity!

I don't have real ticket data to build a ticket aggregator, but some random numbers will do for an initial prototype.

The `Intn` function in the `rand` package will generate a pseudo-random whole number. Passing 10 to `Intn` returns a number from 0-9. The following example displays two random numbers between 1-10.


<a name="rand.go"></a>
```go
package main

import ( // #1
    "fmt"
    "math/rand" // #2
)

func main() {
    var num = rand.Intn(10) + 1
    fmt.Println(num)

    num = rand.Intn(10) + 1
    fmt.Println(num)
}
```
Listing 4. Random numbers: [rand.go][]

1. Import multiple packages with parenthesis
2. math/rand is the import path for the rand package

<i class="fa fa-sticky-note-o fa-2x fa-pull-left fa-border" title="Note"></i> Every time you run the program, the same two pseudo-random numbers are displayed. Time stands still in the Go Playground and results are cached, but these numbers are good enough for our purposes.

#### Experiment

In the next few years, imagine that some spaceships are able to travel at 30 km/s, but slower ships are still in service. Write a program that generates a random speed from 16-30.

## Repetition with for loops
Rather than type the same code multiple times, as in [Listing 4](#rand.go), Go provides the `for` keyword for repeating the same code. A `for` loop can be used to generate 10 random numbers. Later on, a `for` loop will be used to generate 10 random tickets.

<a name="loop.go"></a>
```go
package main

import (
    "fmt"
    "math/rand"
)

func main() {
    var count = 0

    for count < 10 { // #1
        var num = rand.Intn(10) + 1
        fmt.Println(num)

        count = count + 1 // #2
    }
}
```
Listing 5. Loop it: [loop.go][]

1. Repeat the code between {} while count is less than 10
2. Increment count, otherwise it will loop forever

#### Experiment
* Write a program that counts down from 10 and then displays `"Liftoff!"`
* Make your countdown program more realistic by pausing for one second after each number. To do this, the `time` package provides a function called `Sleep`.

    `time.Sleep(time.Second)`

<i class="fa fa-lightbulb-o fa-2x fa-pull-left fa-border" title="Tip"></i> When using a new package, like `time`, it must be listed as an `import`. The Go Playground can do this for you. Ensure the Imports checkbox is checked and then click the **[Format]** button. The Go Playground will determine which packages are being used and add their import paths for you.

## Making comparisons with if and switch
A ticket aggregator needs to list tickets from multiple spacelines. For this prototype, each ticket will have a random spaceline, which can be generated by using a random number and an `if` statement.

<a name="if.go"></a>
```go
package main

import (
    "fmt"
    "math/rand"
)

func main() {
    var num = rand.Intn(3) // #1

    if num == 0 { // #2
        fmt.Println("Space Adventures")
    } else if num == 1 { // #3
        fmt.Println("SpaceX")
    } else { // #4
        fmt.Println("Virgin Galactic")
    }
}
```
Listing 6. Comparing numbers: [if.go][]

1. Generate a random number from 0-2
2. If the random num is equal to 0
3. Otherwise, if num is equal to 1
4. Or, if anything else

<i class="fa fa-lightbulb-o fa-2x fa-pull-left" title="Tip"></i> Go reports an error if you accidentally use assignment (`=`) when equality (`==`) is intended.

#### Experiment
When typing [Listing 6](#if.go) into the Go Playground, be aware that the curly braces `{}` must be placed as shown.

* Modify the declaration of `num` to initialize it with the values 0, 1, or 2 rather than a random number.
* Generate 10 random spacelines by combining [Listing 6](#if.go) with the loop from [Listing 5](#loop.go).

When comparing the same value for equality, Go provides the slightly cleaner `switch` statement. The following code can replace the body of the main function in [Listing 6](#if.go).

<a name="switch.go"></a>
```go
switch rand.Intn(3) {
case 0:
    fmt.Println("Space Adventures")
case 1:
    fmt.Println("SpaceX")
case 2:
    fmt.Println("Virgin Galactic")
default:
    fmt.Println("This was not foreseen")
}
```
Listing 7. The switch statement: [switch.go][]

#### Experiment
Type [Listing 7](#switch.go) into the body of the `main` function of the Go Playground. Be sure to import both `fmt` and `math/rand` as in [Listing 6](#if.go).

* Expand the case statement with additional spacelines, whether real or fictional. Be sure to update the call to `Intn` with the total number of spacelines.

* The `case` keyword can evaluate a comma separated list of values. You can use this feature to place a higher weight on select spacelines. For example:

```go
case 0, 1, 2:
    fmt.Println("Eagle 5")
```

## Formatted print
To format tickets nicely, the `Printf` function gives more control over output than `Print` or `Println`, but first a simple example.

<a name="fmt.go"></a>
```go
var weight = 210.0 * 0.3783
var age = 38 * 365 / 687

fmt.Printf("My weight on the surface of Mars is %v lbs,", weight)
fmt.Printf(" and I would be %v years old.\n", age)
```
Listing 8. Printf: [fmt.go][]

The first argument to `Printf` is text containing the _format verb_ `%v`. The `%v` is substituted for the _value_ of the `weight` variable, and likewise for `age`.

The `Println` function automatically moves to the next line, but `Printf` and `Print` do not. Whenever you want to move to the next line, place `\n` in the text.

If multiple format verbs are specified, the Printf function will substitute multiple variables in order:

```go
fmt.Printf("weight %v, age %v\n", weight, age)
```

Being able to substitute variables anywhere in a sentence is great, but `Printf` will even let you customize how values are displayed. The `%4v` verb pads the value to a width of 4 characters, useful for aligning text:

```go
fmt.Printf("$%4v\n", 94)  // #1
fmt.Printf("$%4v\n", 100) // #2
```
1. Print &nbsp;&nbsp;94
2. Print 100

<i class="fa fa-lightbulb-o fa-2x fa-pull-left" title="Tip"></i> See the [online documentation](https://golang.org/pkg/fmt/) for other format verbs.


## Putting it all together: a ticket generator
Random numbers, loops, comparisons, and formatted print: you have everything you need to generate a list of tickets. The following program uses a tabular format with a nice header to make it extra fancy.

<a name="tickets.go"></a>
```go
package main

import (
    "fmt"
    "math/rand"
)

func main() {
    fmt.Println("Spaceline Company Days Round-trip Price")
    fmt.Println("=======================================")

    var distance = 57600000
    var count = 0

    for count < 10 {
        var speed = rand.Intn(15) + 16          // 16-30 km/s
        var duration = distance / speed / 86400 // days
        var price = 20.0 + speed                // $ millions

        switch rand.Intn(3) {
        case 0:
            fmt.Print("Space Adventures  ")
        case 1:
            fmt.Print("SpaceX            ")
        case 2:
            fmt.Print("Virgin Galactic   ")
        }

        fmt.Printf("%4v ", duration)

        if rand.Intn(2) == 1 {
            fmt.Print("Round-trip ")
            price = price * 2
        } else {
            fmt.Print("One-way    ")
        }

        fmt.Printf("$%4v", price)
        fmt.Println()

        count = count + 1
    }
}
```
Listing 9. Tickets: [tickets.go][]


When you run [Listing 9](#tickets.go) in the Go Playground, the output will look something like this:

```text
Spaceline Company Days Round-trip Price
=======================================
Space Adventures    24 Round-trip $  94
SpaceX              22 One-way    $  50
Virgin Galactic     25 One-way    $  46
Virgin Galactic     41 Round-trip $  72
Virgin Galactic     23 One-way    $  48
Space Adventures    22 Round-trip $ 100
Virgin Galactic     37 Round-trip $  76
Virgin Galactic     30 One-way    $  42
SpaceX              23 Round-trip $  96
Space Adventures    22 Round-trip $  98
```

#### Experiment

Add a departure date column with each ticket randomly displaying one of the dates in [Table 1](#mars-distance). The `duration` calculation should be based on the corresponding distance.

<a name="mars-distance"></a>

Date             | Distance (km)
-----------------|--------------
May 22, 2016     | 75,300,000
July 27, 2018    | 57,600,000
October 13, 2020 | 62,100,000

Table 1. The distance from Earth to Mars

## Summary

This article introduced to the structure of a basic Go program. From there you built up a spaceline ticket generator using the Go Playground with variables, pseudo-random numbers, loops and conditions. Along the way, you:

* Used the standard library to print text and numbers to the screen and to generate pseudo-random numbers.
* Declared constants and variables and assigned new values to variables.
* Used mathematical expressions to calculate ages, weights, durations, and fictional ticket prices.
* Became familiar with Go's syntax for branching and repetition with `if`, `switch`, and `for`.
* Used 11 Go keywords out of a total of 25: `package`, `import`, `func`, `const`, `var`, `for`, `if`, `else`, `switch`, `case`, and `default`.

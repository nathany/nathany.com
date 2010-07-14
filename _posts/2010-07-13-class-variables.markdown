---
layout: default
title: "Language semantics: class variables"
---

# {{ page.title }}

It wasn't until I was reading David Black's "[The Well Grounded Rubyist][black]" that I learned how Ruby @@class variables are not really class variables at all. Apparently they are global to the class hierarchy. Changing a value in the subclass impacts the base classes. Generally speaking, globals and global-like things are bad.

On the other hand, @instance variables, when defined outside of a method body, are considered "class instance variables" because *classes are objects* in Ruby and (implicit) self is pointing at the class at that time. Unfortunately these class instance variables can only be accessed from class methods.

While looking through the code for DHH's abandoned `ssl_requirement` plugin, I discovered `read_inheritable_attribute` and [related methods][inherit] in Rails core. I can't say I really understood it myself, but it is described in [Class and Instance Variables In Ruby][nunemaker] by John Nunemaker.

All of this seemed quite bizarre. It didn't seem like any other language I had experience with. I sought out some reasoning behind this language design in "[The Ruby Programming Language][matz]", co-authored by "Yukihiro \`Matz\` Matsumoto" himself, but all I found was:

>"One of the most important advantages of class instance variables over class variables has to do with the confusing behavior of class variables when subclassing an existing class."

>"This is a strong argument for the use of class instance variables instead of class variables."

To confirm my suspicion that these oddities were specific to Ruby, I decided to dust off the Java compiler. Finding Java fairly straight-forward, I tried to level the playing field by experimenting with a sibling dynamic language. This is what I found in Python.

## Python

In Python you define a class variable by not prepending it with `self`:

  {% highlight python %}
  class Polygon(object):
    sides = 8
  {% endhighlight %}

Access the class variable using the class name:

  {% highlight python %}
  print(Polygon.sides) # 8
  {% endhighlight %}

If you create an instance, the class variable is accessible from it as well:

  {% highlight python %}
  p1 = Polygon()
  print(p1.sides)   # 8
  {% endhighlight %}

Changes to the class variable are visible from the instance, but changing the instance variable will create a new variable that shadows the class variable.

  {% highlight python %}
  Polygon.sides = 4
  print(p1.sides)  # 4

  p1.sides = 5
  print(p1.sides) # 5

  Polygon.sides = 8
  print(Polygon.sides) # 8
  print(p1.sides) # 5
  {% endhighlight %}

Similarly, defining a subclass that redefines the class variable will shadow the base class.

  {% highlight python %}
  class Triangle(Polygon):
    sides = 3;

  print(Triangle.sides) # 3
  Polygon.sides = 5
  print(Triangle.sides) # 3

  t1 = Triangle()
  print(t1.sides) # 3
  {% endhighlight %}

On the other hand, if the the class variable isn't set, it looks further up the hierarchy.

  {% highlight python %}
  class Octogon(Polygon):
    pass

  print(Octogon.sides)  # 5 = Polygon.sides at present

  Polygon.sides = 6
  print(Octogon.sides)  # 6
  {% endhighlight %}

Until, as you might expect, you set a class variable for the subclass.

  {% highlight python %}
  Octogon.sides = 8
  Polygon.sides = 7
  print(Octogon.sides)  # 8
  {% endhighlight %}

## Python vs. Java

In Java you can't have an instance variable and class variable with the same name. Accessing the class variable through the object is equivalent to accessing it through the class.

  {% highlight java %}
  class Polygon {
    static int sides = 8;
  }

  Polygon p1 = new Polygon();
  p1.sides = 4; // in Java this is equivalent to Polygon.sides = 4;
  {% endhighlight %}

This is not the same as Python, where `p1.sides = 4` would create a new instance variable with no affect on the value of Polygon.sides or any other object. 

So Python behaves a little differently due to its nature as a dynamic language where variables aren't declared upfront, but it still makes sense, in my mind.

## End thoughts

I can't say I really understand the ~230 lines of [inheritable_attributes.rb][inherit], but based on the description, it seems to implement the kind of shadowing that Python comes with out-of-the-box.

So it seems, **Ruby is weirdly designed, but flexible enough that we can patch it ourselves.**

While doing a [language comparison][gist] last year, I found that Python strings can be treated as a collection of characters. This is not the case in Ruby, but when asked to improve upon my script, @wycats simply tweaked String for the purposes of the script.

Hm.

[nunemaker]: http://railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
[inherit]: http://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/class/inheritable_attributes.rb
[gist]: http://gist.github.com/313605#file_gistfile4.rb
[black]: http://www.manning.com/black2/
[matz]: http://oreilly.com/catalog/9780596516178
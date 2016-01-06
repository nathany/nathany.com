+++
title = "Language Semantics: Class Variables"
date = "2010-07-13"
revised = "2012-12-17"
description = "Ruby `@@class` *hierarchy* variables are unlike Java and Python."
keywords = ["rubyquirks"]
legacy = true
+++

While reading David Black's _[The Well Grounded Rubyist][black]_, I found that Ruby class `@@variables` are not really class variables at all! Apparently they are global to the class hierarchy. Changing a value in the subclass impacts the base classes. Generally speaking, globals and global-like things are _bad._

~~~ruby
class Polygon
  @@sides = 8

  def self.sides
    @@sides
  end
end

class Triangle < Polygon
  @@sides = 3
end

puts Polygon.sides  # => 3
~~~

On the other hand, instance `@variables`, when defined outside a method body, are considered "class instance variables" because *classes are objects* in Ruby and (implicit) self is pointing at the class at that time. Unfortunately these class instance variables can only be accessed from class methods.

While looking through the code for DHH's abandoned `ssl_requirement` plugin, I discovered `read_inheritable_attribute` and related methods in ActiveSupport. John Nunemaker does a better job describing this in [Class and Instance Variables In Ruby][nunemaker].

All of this felt quite bizarre. It wasn't like any other language I had experience with. I sought out the reasoning behind this language design in _[The Ruby Programming Language][matz],_ co-authored by "Yukihiro \`Matz\` Matsumoto" himself, but all I found was:

>"One of the most important advantages of class instance variables over class variables has to do with the confusing behavior of class variables when subclassing an existing class."

>"This is a strong argument for the use of class instance variables instead of class variables."

To confirm my suspicion that these oddities are specific to Ruby, and not just something I had overlooked, I decided to dust off the Java compiler.

## Java

Java class variables are defined with the `static` keyword:

~~~java
class Polygon {
  static int sides = 8;
}

Polygon p1 = new Polygon();
~~~

In Java, accessing the (static) class variable through the object is equivalent to accessing it through the class. You can't have an instance variable and class variable with the same name.

~~~java
// in Java these are equivalent:
Polygon.sides = 4;
p1.sides = 4;
~~~

If a static class variable exists on a subclass, it is a separate value that *shadows* the base class.

~~~java
class Triangle extends Polygon {
  static int sides = 3;
}

System.out.println(Triangle.sides);   // 3
Triangle t1 = new Triangle();
~~~

This is much different from Ruby class `@@variables`, where one value is shared between Polygon, Triangle, and all their instances.

If a Java subclass doesn't define the static instance variable, we end up accessing the value defined in the base class.

~~~java
class Octogon extends Polygon {
}

System.out.println(Octogon.sides);   // same as Polygon.sides
~~~

Java seems fairly straight-forward, but it is a static language where variables must be declared upfront. To level the playing field, I experimented with Python, a sibling dynamic language.

## Python

In Python you define a class variable by not prepending it with `self`:

~~~python
class Polygon(object):
  sides = 8
~~~

Access the class variable using the class name:

~~~python
print(Polygon.sides) # 8
~~~

If you create an instance, the class variable is visible from it as well:

~~~python
p1 = Polygon()
print(p1.sides)   # 8
~~~

Changes to the class variable are visible from the instance, but changing the instance variable will create a new variable that shadows the class variable.

~~~python
Polygon.sides = 4
print(p1.sides)  # 4

p1.sides = 5
print(p1.sides) # 5

Polygon.sides = 8
print(Polygon.sides) # 8
print(p1.sides) # 5
~~~

Redefining a class variable in a subclass will shadow the base class.

~~~python
class Triangle(Polygon):
  sides = 3

print(Triangle.sides) # 3
Polygon.sides = 5
print(Triangle.sides) # 3

t1 = Triangle()
print(t1.sides) # 3
~~~

On the other hand, if the the class variable isn't set, it looks further up the hierarchy.

~~~python
class Octogon(Polygon):
  pass

print(Octogon.sides)  # 5 = Polygon.sides at present

Polygon.sides = 6
print(Octogon.sides)  # 6
~~~

Until, as you might expect, you set a class variable for the subclass.

~~~python
Octogon.sides = 8
Polygon.sides = 7
print(Octogon.sides)  # 8
~~~

So Python behaves a little differently than Java, due to being a dynamic language where you can create variables on the fly. Instance variables shadow class variables of the same name, so it's best to always refer to class variables as `ClassName.variable`. Makes sense.

## ActiveSupport

If we want behavior similar to Python, we can use [class_attribute][], which replaced `inheritable_attributes` in Rails 3 (released after the initial writing of this article).

~~~ruby
require 'active_support/core_ext/class/attribute'

class Polygon
  class_attribute :sides
end

class Triangle < Polygon
end

Polygon.sides = 8
Triangle.sides = 3

puts Polygon.sides, Triangle.sides  # => 8, 3
~~~

## End thoughts

As with Smalltalk, classes _are_ objects in Ruby. Instance `@variables` defined inside the class body are different than instance `@variables` defined inside methods. Ruby's object model can be _surprising_ to programmers like myself, who learned object-orientation through C++/Java.

Nearly every Ruby book I've read says **don't use** class `@@variables`, which are also an artifact of Ruby's Smalltalk heritage. Pat Shaughnessy takes a detailed look in his article _["Ruby, Smalltalk and Class Variables"][pat]._

[Matz admits][interview] that Ruby may have adopted a "little bit too much… Perl" (eg. global regexp variables). Maybe Ruby adopted _a little too much_ Smalltalk in this case.

Fortunately, Ruby's Lisp heritage allows the savvy Rubyist to extend Ruby's semantics, whether adding [class attributes][class_attribute], [iterating over characters in a string][gist], or [implementing Python-style decorators][decorators].

Perhaps one day we'll see _Ruby 3.0_ remove the misfeatures that trip up newcomers. Until then, do like you do in JavaScript, and use the [good parts][good_parts].

[nunemaker]: http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
[gist]: https://gist.github.com/313605#file-gistfile4-rb
[black]: http://www.manning.com/black2/
[matz]: http://shop.oreilly.com/product/9780596516178.do
[class_attribute]: http://api.rubyonrails.org/classes/Class.html#method-i-class_attribute
[good_parts]: http://shop.oreilly.com/product/9780596517748.do
[decorators]: http://yehudakatz.com/2009/07/11/python-decorators-in-ruby/
[pat]: http://patshaughnessy.net/2012/12/17/ruby-smalltalk-and-class-variables
[interview]: http://fredwu.me/post/36493181321/an-interview-with-yukihiro-matz-matsumoto

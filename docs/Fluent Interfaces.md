# Introduction

A fluent interface is a design pattern in object-oriented programming where method calls are chained together in a way that reads like a natural language sentence, making the code more readable and expressive.  Each method call returns the object itself, allowing another method to be called on it.  The use case is much like a "Domain Specific Language", but with the added benefit that you can leverage your existing language, as opposed to writing a custom interpreter.  This concept is also often used in conjunction with the builder patter, allowing complex object to be built up step-by-step in a legible manner.

# A Bad Example

Let's take a simple object as an example:

```
Point = { "x": 0, "y": 0 }

Point.init = function(x, y)
	self.x = x
	self.y = y
end function

Point.str = function()
	return "(" + self.x + ", " + self.y + ")"
end function
```

What if you wanted to do some math on the object?  Like get an inverted normalized vector between 2 points?  There are a couple of ways to do this:

```
aPnt = new Point
aPnt.init(3, 5)

bPnt = new Point
bPnt.init(-3, 13)

deltaX = aPnt.x - bPnt.x
deltaY = aPnt.y - bPnt.y
distance = sqrt(deltaX ^ 2 + deltaY ^ 2)

nPnt = new Point
nPnt.init(-deltaX / distance, -deltaY / distance)


print "aPnt=" + aPnt.str
print "bPnt=" + bPnt.str
print "nPnt=" + nPnt.str
```

This "works", but it's a little hard to look at and not immediately obvious what it does.  I always try to write my code with the idea in mind that,
3 months from now, I'll have no idea what that idiot author was thinking when he wrote this.



Explain the concept of method chaining
Show how fluent interfaces make code more readable and expressive
Provide examples of fluent interfaces in different programming languages

# A Good Example

This is what I want to be able to write to print out some inverted normalized points:

```
aPnt = (new Point).init(3, 5)
bPnt = (new Point).init(-3, 13)
nPnt = aPnt.subtract(bPnt).normalized.inverted

print "aPnt=" + aPnt
print "bPnt=" + bPnt
print "nPnt=" + nPnt
```

After you've written out how you want the code to look, you can work backwards to figure out what functions you need.

Having the `init` function return a self reference allows you to compress object initialization into a single line:

```
Point.init = function(x, y)
	self.x = x
	self.y = y
	return self
end function
```

Something that I like to do with simple objects like this is to return a new object rather than modifying the internal state of the existing object.
Bonus: This supports the concept of "Functional Programming".

```
Point.subtract = function(pnt)
	return (new Point).init(self.x - pnt.x, self.y - pnt.y)
end function
```

Normalizing a point actually takes 3 steps, all of which can be defined using that same pattern of returning a new object each time,
then calling new next step off the result of the previous step.

```
Point.length = function()
	return sqrt(self.x ^ 2 + self.y ^ 2)
end function

Point.divide = function(n)
	return (new Point).init(self.x / n, self.y / n)
end function

Point.normalized = function()
	return self.divide(self.length)
end function
```

Inverting a point is also technically a 2 step process:

```
Point.multiply = function(n)
	return (new Point).init(n * self.x, n * self.y)
end function

Point.inverted = function()
	return self.multiply(-1)
end function
```

# Summary

In summary, that's a lot of boiler-plate code.

This design pattern let's you shift the complexity away from your business logic and hopefully increase,
but you're never really going to make the complexity go away.

# Examples

* [rect](https://github.com/treytomes/micro-hack/blob/develop/src/rect.ms)
* [point](https://github.com/treytomes/micro-hack/blob/develop/src/point.ms)
* [colorUtil](https://github.com/treytomes/micro-hack/blob/develop/src/util/colorUtil.ms)

# References

* [Fluent Interface](https://en.wikipedia.org/wiki/Fluent_interface)
* [Domain Specific Language](https://en.wikipedia.org/wiki/Domain-specific_language)
* [Builder Pattern](https://en.wikipedia.org/wiki/Builder_pattern)
* [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming)

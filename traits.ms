////
// Weird experiment to see what Rust-style traits might look like in MiniScript.
////

import "listUtil"
import "stringUtil"

PartialEq = {}
PartialEq.eq = function(other)
    return refEquals(self, other)
end function

////

Display = {}
Display.fmt = function(f="")
    if f.len == 0 then
        return str(self)
    end if
    return f.fill(self)
end function

////

Point = {}

Point.init = function(x, y)
	self.x = x
	self.y = y
	return self
end function

Point.make = function(x, y)
    return (new Point).init(x, y)
end function

////

// And now, to implement the PartialEq and Display traits on Point.

map.typeName = function()
    value = self
    if value.hasIndex("__isa") then value = value.__isa

    index = globals.values.indexOf(value)
    key = globals.indexes[index]
    return key
end function

map.implement = function(type)
    // We need to cache the typeName, as things start going sideways as soon as we start modifying `self`.
    typeName = self.typeName

    self += type
    // `_implements`, not `__implements`, as the double-underscore is reserved for the system.
    if not self.hasIndex("_implements") then
        self._implements = []
    end if
    self._implements.push(type)

    globals[typeName] = self

    return self
end function

map.implements = function(type)
    if self isa type then
        return true
    end if

    if self.hasIndex("_implements") and self._implements.contains(type) then
        return true
    end if

    // I'm keeping this duck-typing loop as a fallback.  For now.
    for k in type.indexes()
        if not self.__isa.indexes.contains(k) then
            return false
        end if
    end for

    return true
end function

// Actually, if you do some smarty-smart things with the `globals`, reassigning the original type is no longer required.
Point.implement(PartialEq)

// Example of overriding default trait behavior. 
// `impl Display for Point`
PointDisplay = new Display
PointDisplay.fmt = function(f="")
    if f.len == 0 then
        f = "({x}, {y})"
    end if
    return super.fmt(f)
end function
Point.implement(PointDisplay)

p = Point.make(10, 12)

// The problem here, is that `p isa Point` is true, but `p isa Display` is false.

print("Built-in type-check:")
print("Is Point? {0}".fill([ p isa Point ]))
print("Is Display? {0}".fill([ p isa Display ]))
print("Is PartialEq? {0}".fill([ p isa PartialEq ]))
print("=====")

// An alternative approach: does `p.__isa.indexes` contain everything from `Display.indexes`?

print("With `implements`:")
print("Is Point? {0}".fill([ p.implements(Point) ]))
print("Is Display? {0}".fill([ p.implements(Display) ]))
print("Is PartialEq? {0}".fill([ p.implements(PartialEq) ]))
print("=====")

print(p.fmt("x={x}, y={y}"))
print(p.fmt()) // The overridden Display for Point will allow this to be rendered properly. 
print(p.fmt("({x}, {y})"))
print("=====")

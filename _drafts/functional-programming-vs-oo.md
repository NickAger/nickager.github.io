# Fucntional programming vs OO

Difference between object oriented programming and functional programming

https://skillsmatter.com/skillscasts/6120-functional-programming-design-patterns-with-scott-wlaschin at 25:30

* "Object-oriented programming is behaviour oriented; data is just encapsulted behind the behaviour"
* "Functional programming data and behaviour are completely separate"
* Advantage of functional programming is that you can create new kinds of behaviour for the data very easily and the data is immutable
* In functional programming because types don't have any behaviour they can be composed. Types that can be glued together to make new types == "algebraic types".
* You can think of "algebraic types" as composable types.
* Product types eg: Set of people x set of dates = birthdays eg Haskell: data Point = Point Float Float deriving (Show) / Swift structs (and classes)
[called product types as the set of possible values is the set of the possible values represented by the first type cross product the set of the possible values in the second type]
* Sum types (descriminated unions "choice types") Haskell: data Shape = Circle Float Float Float | Rectangle Float Float Float Float deriving (Show)

* Difference between alegraic types (functional types) and OO types is that alegbraic types are closed eg if you have a sum type with three "choices" you can add a
fourth choice, but all your code will break.
* Whereas if you had an OO approach with subclasses you can add another subclass without breaking any code.
* The flip side is that on the behaviour side, if in the alegbraic data types case I want to add a new function its easy - I add a new function - in the OO design
* I'd have to add the new method to each of the subclasses and the base class. ala "expression problem"
* The functional approach is great if you have a fix set of options and you want to add new behaviour easily. The OO - inheritence - model is great if you want
to have an unlimited set of choices (you don't know what the choices are in advance) and you don't mind making it hard to change the behviour.
* In OO model changing the behaviour breaks things / in the functional model changing the choices breaks things.
* In most real domains - eg payment methods, adding a new payment method shouldn't be as simple as adding a new class, rather you'd want your code to break eg
how do I do refunds, how do I report payments etc. eg in the functional model when you change the choices all your code will break - but often that is a good thing
* Functional approach: Operate on data structure as a whole rather than piecemeal


from [A Small Adventure In Functors](http://okigiveup.net/a-small-adventure-in-functors/):

> Functional programming is more than being able to pass functions as arguments; it's about treating behavior the same way as data structures, in fact turning functions into structures that we can reason about as we do with data.

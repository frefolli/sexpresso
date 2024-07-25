# Sexpresso

Sexpresso is c++ centric [s-expression](https://en.wikipedia.org/wiki/S-expression) parser library. It uses value types and
move semantics and thus manages to completely avoid calling new/delete, so it's probably
free from memory leaks!

Sexpresso aims to be very simple, nodes are parsed either as s-expressions or strings, even
a number would be parsed a string, so if you expect a node to be a number, please convert the
string to a number!

## Installing

### Arch Linux

Inside the `tags` section of this page there's a PKGBUILD which is linked to the latest version. Download it and `makepkg -si` against it.

### Other Environments

Download a copy of the project via Zip or via Git. Then an usual `make && sudo make install` is sufficient. By default the installer puts libraries and headers inside `/usr/local/`. If you wish to install it in another directory the usage of $DESTDIR$ it's implemented and recommended.

## How to use

### Parsing

```c++
auto parsetree = sexpresso::parse(mysexpr);
```

This code will parse the **std::string** in mysexpr and return a Sexp struct value.
There are two main things you can do with this value you can:

1. Turn it back to a string with **parsetree.toString()**
2. Query it using **parsetree.getChildByPath("path/to/node")**

Number 2 might be slightly confusing, how does it follow the path? Well if you've ever used lisp,
you know that the /command/ in an s-expression is the first element. The same thing here determines
where it goes looking for values. For example if you have an s-expression such as

```lisp
(my-values (sweet baby jesus) (hi mom) just-a-thing)
```

You can query it like:

```c++
auto sub = parsetree.getChildByPath("my-values/sweet");
```

and

```c++
auto sub = parsetree.getChildByPath("my-values/hi");
```

Note that you get the sexpr node that *contains* the value you
were looking for as its first value. The sexpr then simply holds an **std::vector** of all the sub-values.
However, it might not always use the vector, if it's simply a string value like **just-a-thing** in the
above example, then the vector will be empty, and you need to access the string value instead.

```c++
if(sub->isSexp()) {
  std::cout << sub->value.sexpr[1];
} else {
  std::cout << sub->value.str;
}

// or

switch(sub->kind) {
case sexpresso::SexpValueKind::SEXP:
  std::cout << sub->value.sexpr[1];
  break;
case sexpresso::SexpValueKind::STRING:
  std::cout << sub->value.str;
}
```

Sexpresso provides a comfortable way to iterate only over the "arguments of a s-expression.
For example if we have an s-expression like **(hi 1 2 3)** then the arguments are **1**, **2** and **3**.
If we've parsed and stored that s-expression in a variable called **hi**, we iterate over its arguments
like this:

```c++
for(auto&& arg : hi.arguments()) {
  // ..
}

// or 
for(auto&& it = hi.arguments().begin(); it != hi.arguments().end(); ++it) {
  // ..
}
```

You can also check if the arguments are empty and how many there are with the **empty** and **size** methods
of the **SexpArgumentIterator** class.

*WARNING* Be *REALLY* careful that your query result does not exceed the lifetime of
the parse tree:

```c++
Sexp* sub;
{
auto sexp = sexpresso::parse(mysexpr);
sub = sexp.getChildByPath("my-values/just-a-thing")
} // sexp gets destroyed here
cout << sub.toString(); // BAD!
```

### Serializing
Sexp structs have an **addChild** method that takes a Sexp method. Furthermore, Sexp has a constructor
that takes a std::string, so this should make it really easy to build your own Sexp objects from code that
you can serialize with **toString**.

```c++
auto myvalues = sexpresso::Sexp{"my-values"};

auto sweet = sexpresso::Sexp{"sweet"};
sweet.addChild("baby");
sweet.addChild("jesus");

auto hi = sexpresso::Sexp{"hi"};
hi.addChild("mom");

auto justathing = sexpresso::Sexp{"just-a-thing"};

auto myvaluesholder = sexpresso::Sexp{};
myvaluesholder.addChild(std::move(myvalues));
myvaluesholder.addChild(std::move(sweet));
myvaluesholder.addChild(std::move(hi));
myvaluesholder.addChild(std::move(justathing));

auto sexp = sexpresso::Sexp{};
sexp.addChild(myvaluesholder);

// sexp should now hold the same s-expression we wrote in text earlier
std::cout << sexp.toString();
```

#### Important

The outermost s-expression does not get surrounded by paretheses when calling toString, as it treats a string
as being implicitly surrounded by parentheses. This is so that you can have multiple s-expressions in the "root"
of your code, and serialization goes back to text the same way it came in. That's why we have the **sexp**
in the above code example. If we simply called **toString** on **myvaluesholder** we would get

```lisp
my-values (sweet baby jesus) (hi mom) just-a-thing
```

instead of

```lisp
(my-values (sweet baby jesus) (hi mom) just-a-thing)
```

Cool? Cool.

### S-expression primer

Confused? I mean what *iiiis* an s-expression?

s-expressions come from the lisp family of programming languages, it is an
incredibly simple notation for *lists*, however, since these lists can be nested
it also means that they are great for representing hierarchies as well, which makes
it an excellent replacement for XML or JSON.

The notation is simply to surround the elements, separated by whitespace in parentheses,
like this:

```lisp
(here we have an s-expression)
```

What you see here is a list of 5 symbols: **here**, **we**, **have**, **an** and **s-expression**.
Like I said you can also put s-expressions inside s-expressions to create hierarchies:

```lisp
(my-objects 
  (object-a (name "isak andersson") 
            (countries swe uk)) 
  (object-b (name "joe bain")
            (countries uk)))
```

And as you could see earlier in the [[How to use]] section you can query this hierachy easily with
this library. Say that this s-expression is stored in a variable called **objs**, you can query it like this:

```c++
auto joe = objs.getChildByPath("my-objects/object-b/name");
````

## FAQ

### Why should I use s-expressions

because they are more elegant and simple than XML or JSON. Much less work required to parse. And they look nice! (subjective)

## Contributing

This library forked from a public domain library (CC0). Succeding in refactoring it's processes, it's relicensed by the Maintainer under a Free license, specifically GPLv3.

## Future direction

I put here the orignal developer "last" will

- Make it a header-only library instead perhaps?

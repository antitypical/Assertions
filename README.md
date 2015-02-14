# Assertions

This is a Swift µframework providing simple, flexible assertions for XCTest in Swift.


## Use

Assert that an optional array is equal to another array:

```swift
let array: [Int]? = [1, 2, 3]
assert(maybeAnArray(), ==, [1, 2, 3])
```

If you tried to use `XCTAssertEqual`, you’d have to unwrap the optional first:

```swift
XCTAssertEqual(array, [1, 2, 3])
// => error: value of optional type '[Int]?' not unwrapped; did you mean to use '!' or '?'?
```

This works great with optionals of other types, too:

```swift
let string: String? = "hello"
assert(string, ==, "hello")
```

Here, too, `XCTAssertEqual` would force you to unwrap the optional:

```swift
XCTAssertEqual(string, "hello")
// => error: cannot find an overload for 'XCTAssertEqual' that accepts an argument list of type '(String?, String)'
```

You can also pass in methods:

```swift
let set: Set<Int>? = Set([1, 2, 3])
assert(set, Set.contains, 3)
```

And you can use the predicate form for any other test you might want to write:

```swift
let string: String? = ""
assert(string, { $0.isEmpty })
```

These last two are approximately equivalent to using Swift’s optional chaining, but you might find them handy.


## Integration

1. Add this repo as a submodule in e.g. `External/Assertions`:
  
        git submodule add https://github.com/robrix/Assertions.git External/Assertions
2. Drag `Assertions.xcodeproj` into your `.xcworkspace`/`.xcodeproj`.
3. Add `Assertions.framework` to your test target’s `Link Binary With Libraries` build phase.

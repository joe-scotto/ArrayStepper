# ArrayStepper (WIP - Releasing soon...)

![Untitled]()
###image here

A simple SwiftUI component for stepping through the contents of an array. Features long press gestures to increment or decrement the selected value along with a list view of all available values for selection. Very similar to [TextFieldStepper](https://github.com/joe-scotto/textfieldstepper.git) sharing both similar functionality and styling.

# Contents

1. [Platforms](#platforms)
2. [Usage](#usage)
3. [Advanced](#advanced)
4. [Uniqueness](#uniqueness)
5. [Selected](#selected)
6. [Appending](#appending)
7. [Customizing](#customizing)
8. [Sections](#sections)
9. [Parameters](#parameters)
10. [Styling](#styling)
11. [SwiftUI](#swiftui)
12. [License](#license)

# Platforms

Tested on iOS 16.0 but should work on both iOS and iPadOS 15 and up.

# Usage

Creating a basic `ArrayStepper` is simple. Refer to [advanced](#Advanced) and [sections](#Sections) for other ways of creating an `ArrayStepper`.

```swift
struct ContentView: View {
    @StateObject private var values = ArrayStepperValues(
        selected: "Joe",
        values: [
            "Tim",
            "Joe",
            "James"
        ]
    )

    var body: some View {
        ArrayStepper(
            values: values,
            label: "Person"
        )
    }
}
```

# Advanced

By default, `ArrayStepper` can accept anything that conforms to `Equatable`. This should be fine in most cases but there may be times where you want to pass in more complex types such as custom structs. This is where the `display` parameter becomes necessary in order to define what value to show. By default if this parameter is not defined and a struct is passed, `ArrayStepper` will just print out the entire object.

```swift
struct Person {
    var name: String
    var age: Int?
}

struct ContentView: View {
    @StateObject private var values = ArrayStepperValues(
        selected: Person(name: "Joe", age: 23),
        values: [
            Person(name: "Tim", age: 20),
            Person(name: "Joe", age: 23),
            Person(name: "James", age: nil)
        ]
    )

    var body: some View {
        ArrayStepper(
            values: values,
            display: { $0.name },
            label: "Person"
        )
    }
}
```

# Uniqueness

In order to combat issues with multiple values that are the same, `ArrayStepper` uses a custom type `ASValue` to convert everything into a unique value. This is a complexity of `O(n)` as each value has to manually be cast to this custom type. In most situations this shouldn't slow anything down but if you want to skip this cast, you can just pass everything in as `ASValue`. Keep in mind if you create the `ArrayStepper` this way, your selected value must be stored as variable in order to ensure the ID matches in the `values` array.

```swift
    @StateObject private var values: ArrayStepperValues<ASValue<String>>

    init() {
        let selected = ASValue(item: "Joe")
        self.values = ArrayStepperValues(
            selected: selected
            values: [
                ASValue(item: "Tim"),
                selected,
                ASValue(item: "James")
            ]
        )
    }

    var body: some View {
        ArrayStepper(
            values: values,
            label: "Person"
        )
    }

```

# Selected

`ArrayStepper` tries setting the selected values to the first index of `ArrayStepperValues.selected` in `ArrayStepperValues.values`. If this value is not found, `ArrayStepper` will throw a `fatalError()` by default, however there are three ways that can be set to handle this:

1. **.Fail** - Throws a `fatalError()` if the `selected` is not found in `values` and is the default setting.
2. **.First** - Sets the `selected` to the first value found in `values`.
3. **.Append** - Appends `selected` to `values` and sets `selected` to the last element in `values`.

In order to access the value of `selected` you need to access `selected.item` as all values are cast to `ASValue`, refer to [uniqueness](#Uniqueness) for more.

# Appending

You can do any number of operations on `ArrayStepperValues.values` as you would expect for an array. The only restriction is that values must be passed as `ASValue` since after you create the `ArrayStepper` all values are converted to this type. Also keep in mind that `ArrayStepper` still follows the setting for [selected](#selected).

```swift
    @StateObject private var values = ArrayStepperValues(
        selected: "Joe",
        values: [
            "Tim",
            "Joe",
            "James"
        ]
    )

    var body: some View {
        ArrayStepper(
            values: values,
            label: "Person"
        )

        Button("Add Person", action: {
            values.values.append(ASValue(item: "Joe"))
        })
    }
```

# Customizing

Although the defaults should be fine for most situations, there are cases where they won't be. `ArrayStepper` has two ways of changing the default [parameters](#parameters).

1. If you just want to modify a single component, you can directly pass in the parameter name and value.

    ```swift
    struct ContentView: View {
        @StateObject private var values = ArrayStepperValues(
            selected: "Joe",
            values: [
                "Tim",
                "Joe",
                "James"
            ]
        )

        var body: some View {
            ArrayStepper(
                values: values,
                label: "Person",
                disabledColor: .black
            )
        }
    }
    ```

2. If you want to modify multiple at once, use `ArrayStepperConfig`. You can either pass a different one into each instance of the component or create a single one and make it available globally as a sort of default.

    ```swift
    struct ContentView: View {
        @StateObject private var values = ArrayStepperValues(
            selected: "Joe",
            values: [
                "Tim",
                "Joe",
                "James"
            ]
        )

        let config = ArrayStepperConfig(
            label: "Person",
            disabledColor: .black
        )

        var body: some View {
            ArrayStepper(
                values: values,
                config: config
            )
        }
    }
    ```

# Sections

If you have multiple groups of data, you can use an array of `ASSection`, yes, **ASS**-ection, to create difference sections in the list.

```swift
struct ContentView: View {
    @StateObject private var values = ArrayStepperValues(
        selected: Person(name: "Joe", age: 23),
        sections: [
            ASSection(
                header: "Siblings",
                items: [
                    Person(name: "Joe", age: 23),
                    Person(name: "Tim", age: 20)
                ]
            ),
            ASSection(
                header: "Parents",
                items: [
                    Person(name: "Joe", age: nil),
                    Person(name: "James", age: nil)
                ]
            )
        ]
    )

    var body: some View {
        ArrayStepper(
            sections: $sections,
            display: { "\($0.name): \($0.age ?? 0)" },
            label: "Person"
        )
    }
}
```

# Parameters

Below are the parameters available on both `ArrayStepper` and `ArrayStepperConfig`.

| Parameter      | Type              | Default                                            | Note                                                            |
| -------------- | ----------------- | -------------------------------------------------- | --------------------------------------------------------------- |
| label          | String            | “”                                                 | Label to show under value.                                      |
| incrementSpeed | Double            | 0.25                                               | How many seconds before the button action is ran while holding. |
| decrementImage | ArrayStepperImage | ArrayStepperImage(systemName: "minus.circle.fill") | Image for decrement button.                                     |
| incrementImage | ArrayStepperImage | ArrayStepperImage(systemName: "plus.circle.fill")  | Image for increment button.                                     |
| disabledColor  | Color             | Color(UIColor.lightGray)                           | Color of disabled button.                                       |
| labelOpacity   | Double            | 1.0                                                | Opacity of label under value.                                   |
| labelColor     | Color             | .primary                                           | Color of label under value.                                     |
| valueColor     | Color             | .primary                                           | Color of value.                                                 |

# Styling

Below are the default colors and images that `ArrayStepper` uses. In addition to this, when a button is disabled it will use `Color(UIColor.lightGray)` which can be overridden with the `disabledColor` parameter. You can also specify the label opacity and color with `labelOpacity` and `labelColor`. If you want to change the color of the main value, use `valueColor`.

| Button          | Color        | Image             |
| --------------- | ------------ | ----------------- |
| decrementButton | .accentColor | minus.circle.fill |
| incrementButton | .accentColor | plus.circle.fill  |

You can override the default images by creating an instance of `ArrayStepperImage` and passing that to the corresponding parameter on either `ArrayStepper` or `ArrayStepperConfig`. There are two methods of instantiating `ArrayStepperImage`. Currently there is no method to just change the color, you must provide an image as well.

1. If you’re just using a system named image, you can use the `systemName` parameter.
    ```swift
    let image = ArrayStepperImage(systemName: "circle.fill")
    ```
2. If you're using a custom image, directly pass an `Image`.
    ```swift
    let image = ArrayStepperImage(image: Image(systemName: "circle.fill")
    ```

# SwiftUI

In Xcode 14 you may get a SwiftUI warning that reads the following:

> [SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior.

There is some speculation whether or not this is an actual error or a bug but from all my testing, nothing seems to be out of the ordinary. Just keep this in mind if you get unexpected results.

# License

MIT License

Copyright (c) 2022 Joe Scotto

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

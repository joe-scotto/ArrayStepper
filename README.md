# ArrayStepper
![Untitled](https://user-images.githubusercontent.com/8194147/184554947-383ae35d-4c3e-4b37-bbfe-d4f06cef1c66.gif)
A simple SwiftUI component for stepping through the contents of an array. This package is very similar to [TextFieldStepper](https://github.com/joe-scotto/textfieldstepper.git) sharing both similar functionality (except for arrays) and styling. `ArrayStepper` also features long press gestures for incrementing or decrementing the value.

# Platforms
Tested on iOS 16.0 but should work on both iOS and iPadOS 15 and up.

# Usage
Creating an `ArrayStepper` is simple. 
``` swift
struct ContentView: View {
    @State private var selected = "Joe"
    @State private var values = [
        "Joe",
        "Tommy",
        "Kandy"
    ]

    var body: some View {
        ArrayStepper(
            selected: $selected,
            values: $values,
            label: "Person"
        )
    }
}
```

# Advanced
By default, `ArrayStepper` can accept anything that conforms to `Equatable`. This should be fine in most cases but there may be times where you want to pass in more complex types such as custom structs. This is where the `display` parameter becomes necessary in order to define what value to show. 

``` swift 
struct Person {
    var name: String
    var age: Int?
}

struct ContentView: View {
    @State private var selected = Person(name: "Joe", age: 23)
    @State private var values = [
        Person(name: "Joe", age: 23),
        Person(name: "Tommy", age: 20),
        Person(name: "Kandy", age: nil)
    ]

    var body: some View {
        ArrayStepper(
            selected: $selected,
            values: $values,
            display: { $0.name },
            label: "Person"
        )
    }
}
```

# Uniqueness
Data arrays passed into `ArrayStepper` are expected to be unique, meaning, no values repeat. It would defeat the purpose of this component could let you select one of multiple that are all the same. `ArrayStepper` uses `firstIndex(of: )` to find the value within the array.

- 

# Customizing
The defaults should be fine for most situations but there are certainly cases where they won't be. There are two methods that will allow you to change these [parameters](#parameters).

1. If you just want to modify a single component, you can directly pass in the parameter name and value.
    ``` swift
    struct ContentView: View {
        @State private var selected = "Joe"
        @State private var values = [
            "Joe",
            "Tommy",
            "Kandy"
        ]

        var body: some View {
            ArrayStepper(
                selected: $selected, 
                values: $values, 
                label: "Person",
                disabledColor: .black
            )
        }
    }
    ```

2. If you want to modify multiple at once, use `ArrayStepperConfig`. You can either pass a different one into each instance of the component or create a single one and make it available globally as a sort of default.
    ``` swift
    struct ContentView: View {
        @State private var selected = "Joe"
        @State private var values = [
            "Joe",
            "Tommy",
            "Kandy"
        ]

        let config = ArrayStepperConfig(
            label: "Person",
            disabledColor: .black
        )

        var body: some View {
            ArrayStepper(selected: $selected, values: $values, config: config)
        }
    }
    ```
    
# Parameters
Below are the parameters available on both `ArrayStepper` and `ArrayStepperConfig`.

| Parameter            | Type                  | Default                                                                        | Note                                                                |
|----------------------|-----------------------|--------------------------------------------------------------------------------|---------------------------------------------------------------------|
| label                | String                | “”                                                                             | Label to show under value.                                          |
| incrementSpeed       | Double                | 0.25                                                                           | How many seconds before the button action is ran.                   |
| decrementImage       | ArrayStepperImage     | ArrayStepperImage(systemName: "minus.circle.fill")                             | Image for decrement button.                                         |
| incrementImage       | ArrayStepperImage     | ArrayStepperImage(systemName: "plus.circle.fill")                              | Image for increment button.                                         |
| disabledColor        | Color                 | Color(UIColor.lightGray)                                                       | Color of disabled button.                                           |
| labelOpacity         | Double                | 1.0                                                                            | Opacity of label under value.                                       |
| labelColor           | Color                 | .primary                                                                       | Color of label under value.                                         |
| valueColor           | Color                 | .primary                                                                       | Color of value.                                                     |

# Styling
Below are the default colors and images that `ArrayStepper` uses. In addition to this, when a button is disabled it will use `Color(UIColor.lightGray)` which can be overridden with the `disabledColor` parameter. You can also specify the label opacity and color with `labelOpacity` and `labelColor`. If you want to change the color of the main value, use `valueColor`.

| Button          | Color                 | Image                 |
|-----------------|-----------------------|-----------------------|
| decrementButton | .accentColor          | minus.circle.fill     |
| incrementButton | .accentColor          | plus.circle.fill      |

You can override the default images by creating an instance of `ArrayStepperImage` and passing that to the corresponding parameter on either `ArrayStepper` or `ArrayStepperConfig`. There are two methods of instantiating `ArrayStepperImage`. Currently there is no method to just change the color, you must provide an image as well.

1. If you’re just using a system named image, you can use the `systemName` parameter. 
    ``` swift 
    let image = ArrayStepperImage(systemName: "circle.fill")
    ```
    
2. If you're using a custom image, directly pass an `Image`.
    ``` swift 
    let image = ArrayStepperImage(image: Image(systemName: "circle.fill")
    ```

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

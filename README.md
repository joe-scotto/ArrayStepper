# ArrayStepper
A simple SwiftUI component for stepping through the contents of an array. This package is very similar to [TextFieldStepper](https://github.com/joe-scotto/textfieldstepper.git) and shares it's styling.

# Platforms
Tested on iOS 16.0 but should work on both iOS and iPadOS 15 and up.

# Usage
Creating a `ArrayStepper` is simple. 
``` swift
struct ContentView: View {
    @State private var selected = "Joe"
    @State private var values = [
        "Joe",
        "Tommy",
        "Kandy",
        
    ]

    var body: some View {
        ArrayStepper(
            selected: $butter, 
            unit: "oz", 
            label: "Person"
        )
    }
}
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

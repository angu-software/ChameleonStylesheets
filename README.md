# ChameleonStylesheets

[![CI Status](http://img.shields.io/travis/dreyhomedev/ChameleonStylesheets.svg?style=flat)](https://travis-ci.org/dreyhomedev/ChameleonStylesheets)
[![Version](https://img.shields.io/cocoapods/v/ChameleonStylesheets.svg?style=flat)](http://cocoapods.org/pods/ChameleonStylesheets)
[![License](https://img.shields.io/cocoapods/l/ChameleonStylesheets.svg?style=flat)](http://cocoapods.org/pods/ChameleonStylesheets)
[![Platform](https://img.shields.io/cocoapods/p/ChameleonStylesheets.svg?style=flat)](http://cocoapods.org/pods/ChameleonStylesheets)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ChameleonStylesheets is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ChameleonStylesheets"
```

## Chameleon.stylesheet specification

A chameleon stylesheet contains information about sizes colors and fonts to use in an app for styling.


```
{
  "chameleon_stylesheet": "1.0", <-- version of compatible chameleonStylesheet
  "sizes": {
    "small": "8",
    "medium": "10",
    "large": "14"
  },
  "colors": {
    "red": "#ff0000", <-- rgb-color in hex notation
    "green": "[0,255,0]", <-- rgb-color in decimal notation
    "blue": "#0000ffaa" <-- rgba-color in hex notation (equal to rgba with decimal notation [0,0,255,170])
  },
  "fonts": {
    "main": {
      "name": "system",
      "size": "12",
      "color": "#ffffff"
    },
    "title": {
      "name": "ArialMT",
      "size": "sref:large", <-- size reference to large
      "color": "cref:red" <-- color reference to red
    },
    "subtitle": {
      "name": "fref:title", <-- font reference to title.name
      "size": "sref:medium",
      "color": "cref:green"
    }
  }
}
```

### References

It is possible to also referencing previously defined values within the stylesheet. There are tree types of references: size references, color references and font references.

### Valid values

#### Sizes

* only numeric values
* size references (sref)

#### colors

* decimal rgb(a)
* hex rgb(a)
* color references (cref)

#### fonts

* font references for name,size and color
* valid values for size
* valid values for color

### Additions

* color reference with adding alpha
* ~iphone/~ipad/@1x/@2x/@3x spezifiers

## Author

dreyhomedev, mailguenni@gmail.com

## License

ChameleonStylesheets is available under the MIT license. See the LICENSE file for more info.

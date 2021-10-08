# EasyAttributer

[![CI Status](https://img.shields.io/travis/Sadegh/EasyAttributer.svg?style=flat)](https://travis-ci.org/Sadegh/EasyAttributer)
[![Version](https://img.shields.io/cocoapods/v/EasyAttributer.svg?style=flat)](https://cocoapods.org/pods/EasyAttributer)
[![License](https://img.shields.io/cocoapods/l/EasyAttributer.svg?style=flat)](https://cocoapods.org/pods/EasyAttributer)
[![Platform](https://img.shields.io/cocoapods/p/EasyAttributer.svg?style=flat)](https://cocoapods.org/pods/EasyAttributer)

Easy Attributer is a library that generates attributed string by matched regexes.

This is how EasyAttributer works: 
![](https://github.com/sadeghgoo/EasyAttributer/blob/master/EasyAttributer_Introduction.gif)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Documention](#documention)

## Features
- [x] Support custom regex.
- [x] Thread safe.
- [x] High performance.
- [x] **Easy to use**

## Requirements
- iOS 11.0+
- Swift 5.0+

## Installation
### Cocoapod
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website.

You can install Cocoapods with the following command:
```
$ gem install cocoapods
```
To integrate MagicTimer into your Xcode project using CocoaPods, specify it in your `Podfile`.
```ruby
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target <'Your target name'> do
    pod 'EasyAttributer'
end

```

## Basic usage
*Before anything review project UnitTests and example*
1. Create instance of `EasyAttributer`.
2. Pass your custom regexes to `EasyAttributer` instance.
3. Call `transform(:_)` method.
4. Finish :)


## Documention 
### `EasyAttributer`
EasyAttributer is a type that accepts an array of 'ESRegexBehavior' and transforms it into your custom attributed string.
```swift
public struct EasyAttributer
```

### `transform(:_)`
Return the none-mutable attributed string and attributes your regex matches.
  - Parameters:
    - text: text that transformer searches for regex patterns.
    - matchAttribute: A callback that calls on every match. Use this to attribute to your matches.
```swift
public func transform(text: String, attribute matchAttribute: @escaping (ESTextResult) -> [NSAttributedString.Key : Any]) throws -> NSAttributedString?
```

### `EsRegexBehavior`
A regex behavior type. Create your regex by conforming to this protocol.
```swift
public protocol ESRegexBehavior
```

## Author

sadeq, sadeqbitarafan@gmail.com

## License

EasyAttributer is available under the MIT license. See the LICENSE file for more info.

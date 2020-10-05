# LoggingKit

[![CI Status](https://img.shields.io/travis/Martin Vasilev/LoggingKit.svg?style=flat)](https://travis-ci.org/Martin Vasilev/LoggingKit)
[![Version](https://img.shields.io/cocoapods/v/SFLoggingKit.svg?style=flat)](https://cocoapods.org/pods/LoggingKit)
[![License](https://img.shields.io/cocoapods/l/SFLoggingKit.svg?style=flat)](https://cocoapods.org/pods/LoggingKit)
[![Platform](https://img.shields.io/cocoapods/p/SFLoggingKit.svg?style=flat)](https://cocoapods.org/pods/LoggingKit)

## If you like SFLoggingKit, give it a ★ at the top right of this page.

* **[Overview](#overview)**
* [Preview Samples](#preview-samples) 
* **[Requirements](#requirements)**
* **[Installation](#installation)**
* [CocoaPods](#cocoapods)
* **[Usage](#usage)**
* [With default configurations](#with-default-configurations)
* [With custom configurations](#with-custom-configurations)
* [Authors](#authors)
* [Thank You](#thank-you)
* [License](#license)

## Preview Samples

TBD

## Requirements
- [x] Xcode 11.
- [x] Swift 5.
- [x] iOS 10 or higher

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```bash
$ gem install cocoapods
```

To integrate SFLoggingKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

...

pod 'SFLoggingKit'
```

Then, run the following command:

```bash
$ pod install
```
## Usage

```swift
import SFLoggingKit
```

### With default configurations

```swift
let defaultLogger = SFLogger()

...

defaultLogger.debug("Log Message")
```

### Advanced

TBD

**That's it.**

## Authors

Aleksandar Gyuzelov, aleksandar.gyuzelov@scalefocus.com
Martin Vasilev, martin.vasilev@upnetix.com


## Thank You

A special thank you to everyone that will [contributed](https://github.com/aguzelov/SFLoggingKit/graphs/contributors) to this library to make it better. Your support is appreciated!

## License

SFLoggingKit is available under the MIT license. See the LICENSE file for more info.

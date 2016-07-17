# TTGNotificationGuard

[![CI Status](http://img.shields.io/travis/zekunyan/TTGNotificationGuard.svg?style=flat)](https://travis-ci.org/zekunyan/TTGNotificationGuard)
[![Version](https://img.shields.io/cocoapods/v/TTGNotificationGuard.svg?style=flat)](http://cocoapods.org/pods/TTGNotificationGuard)
[![License](https://img.shields.io/cocoapods/l/TTGNotificationGuard.svg?style=flat)](http://cocoapods.org/pods/TTGNotificationGuard)
[![Platform](https://img.shields.io/cocoapods/p/TTGNotificationGuard.svg?style=flat)](http://cocoapods.org/pods/TTGNotificationGuard)

## What
Auto remove the observer from NSNotificationCenter after the oberser dealloc, base on [TTGDeallocTaskHelper](https://github.com/zekunyan/TTGDeallocTaskHelper).

## Requirements
iOS 6 and later.

## Installation

TTGNotificationGuard is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TTGNotificationGuard"
```

## Usage
1. TTGNotificationGuard is default off, so you must turn it on first.
```
#import "NSNotificationCenter+TTGNotificationGuard.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable the TTGNotificationGuard
    [NSNotificationCenter ttg_setTTGNotificationGuardEnable:YES];
    return YES;
}
```

2. No more need to do. Just start coding as usual :)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

zekunyan, zekunyan@163.com

## License

TTGNotificationGuard is available under the MIT license. See the LICENSE file for more info.

## ZGUIWebViewCache for UIWebView

ZGUIWebViewCache is a tool that help users to realize Application cache.You can choose what you want to cache.

If you use WKWebView,please see this(it will show later).  

This is the catalog：   
![catalog](https://raw.githubusercontent.com/ScottZg/ZGUIWebViewCache/master/catalog.png)

Setup Instructions
------------------


[CocoaPods](http://cocoapods.org)
------------------

Install with CocoaPods by adding the following to your `Podfile`:
```ruby
pod 'ZGUIWebViewCache'
```
Manually
------------------

Add ZGWebCache folder to your project


How to use
------------------
1. ```objective-c #import "ZGUIWebViewCache.h"``` at AppDelegate.m
2. Writing like the fllows:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ZGUIWebViewCache sharedWebViewCache] initWebCacheWithCacheTypes:@[@(CacheTypeJS),@(CacheTypeImage)]];
    return YES;
}

```
CacheTypes are as Fllows:

```objective-c
typedef NS_ENUM(NSInteger,CacheType) {    
    CacheTypeImage = 4,
    CacheTypeJS,
    CacheTypeCSS,
    CacheTypeHTML
};
```
you can choose what you want cache to cache。  
3. clear cache
you can use

```objective-c
[[ZGUIWebViewCache sharedWebViewCache] clearCacheWithInvalidDays:7];
```
seven represent the day that cache lives time.   
This method you can call at```objective-c - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions```

You can also use:

```objective-c
- (void)clearZGCache;
```

For Example,Personal Center Button's click and send this message.

If you want to see the log,just call:
```objective-c
[[ZGUIWebViewCache sharedWebViewCache] setDebugModel:YES];
```
Default is NO.
MIT License
-----------
    Copyright (c) 2017 Zhanggui

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


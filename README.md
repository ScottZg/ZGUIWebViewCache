## ZGUIWebViewCache for UIWebView

ZGUIWebViewCache is a tools that help users to realize Application cache.You can choose what you want to cache.

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
1. ```#import "ZGUIWebViewCache.h"``` at AppDelegate.m
2. Writing like the fllows:

```
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

```
[[ZGUIWebViewCache sharedWebViewCache] clearCacheWithInvalidDays:7];
```
seven represent the day that cache lives time.This method you can call at```- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions```

You can also use:

```
- (void)clearZGCache;
```

For Example,Personal Center Button's click and send this message.

If you want to see the log,just call:
```
[[ZGUIWebViewCache sharedWebViewCache] setDebugModel:YES];
```
Default is NO.

//
//  ZGURLProtocol.m
//  ZGUIWebViewCache
//
//  Created by zhanggui on 2017/11/20.
//  Copyright © 2017年 zhanggui. All rights reserved.
//

#import "ZGURLProtocol.h"
#import "ZGCacheModel.h"
#import "ZGUIWebViewCache.h"
static NSString * const ZGURLProtocolKey = @"zgPKey";

@interface ZGURLProtocol()<NSURLConnectionDataDelegate>

/**
 请求的数据
 */
@property (nonatomic,strong)NSMutableData *responseData;

/**
 请求链接类
 */
@property (nonatomic,strong)NSURLConnection *connection;

@property (nonatomic,strong)NSString *responseMIMEType;
@end

@implementation ZGURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *scheme = [[request URL] scheme];
    
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {  //只缓存http和https的请求
        NSString *str = request.URL.path;
        //这里现在只是判断了图片 + js
        if ([self cacheTypeWithStr:str] && ![NSURLProtocol propertyForKey:ZGURLProtocolKey inRequest:request]) {
            return YES;
        }
    }
    return NO;
}
+ (BOOL)cacheTypeWithStr:(NSString *)str {
    if ([[[ZGUIWebViewCache sharedWebViewCache] cacheArr] containsObject:@(CacheTypeJS)] && [str hasSuffix:@".js"]) {
        return YES;
    }
    if ([[[ZGUIWebViewCache sharedWebViewCache] cacheArr] containsObject:@(CacheTypeImage)] && [self ifImageType:str]) {
        return YES;
    }
    if ([[[ZGUIWebViewCache sharedWebViewCache] cacheArr] containsObject:@(CacheTypeCSS)] && [str hasSuffix:@".css"]) {
        return YES;
    }
    if ([[[ZGUIWebViewCache sharedWebViewCache] cacheArr] containsObject:@(CacheTypeHTML)] && [str hasSuffix:@".html"]) {
        return YES;
    }
    return NO;
}
/**
 判断是否值js

 @param urlStr 资源地址，这里暂时只判断了一下js四种格式
 @return YES表示是js，NO表示不是js
 */
+ (BOOL)ifJSType:(NSString *)urlStr {
    if ([urlStr hasSuffix:@".js"]) {
        return YES;
    }
    return NO;
}
/**
 判断将要请求的资源是否是图片

 @param urlStr 资源地址，这里暂时只判断了一下png/jpg/gif/jpeg四种格式
 @return YES表示是图片，NO表示不是图片
 */
+ (BOOL)ifImageType:(NSString *)urlStr {
    if ([urlStr hasSuffix:@".png"] ||
        [urlStr hasSuffix:@".jpg"] ||
        [urlStr hasSuffix:@".gif"] ||
        [urlStr hasSuffix:@".jpeg"]) {
        return YES;
    }
    return NO;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    //这里可以进行重定向操作，重写request，
    return request;
}
//这里请求是否的等价于缓存
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}
//开始请求
- (void)startLoading {
    NSMutableURLRequest *mutableRequest = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:ZGURLProtocolKey inRequest:mutableRequest];
    ZGCacheModel *model = [[ZGUIWebViewCache sharedWebViewCache] getCacheDataByKey:self.request.URL.absoluteString];
    
    if (model.data && model.MIMEType) {
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:model.MIMEType expectedContentLength:model.data.length textEncodingName:nil];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
        [self.client URLProtocol:self didLoadData:model.data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    self.connection = [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
}
- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
    self.responseMIMEType = response.MIMEType;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    ZGCacheModel *model = [ZGCacheModel new];
    model.data = self.responseData;
    model.MIMEType = self.responseMIMEType;
    [self setMiType:model.MIMEType withKey:[self.request.URL path]];//userdefault存储MIMEtype
    
    
    [[ZGUIWebViewCache sharedWebViewCache] setCacheWithKey:self.request.URL.absoluteString value:model];
  
    [self.client URLProtocolDidFinishLoading:self];
}
/**
 将类型和key存储到一个字典里面，然后
 
 @param mimeType mime类型
 @param urlKey url的key
 */
- (void)setMiType:(NSString *)mimeType withKey:(NSString *)urlKey {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:URLMIMETYPE];
    
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [muDic setValue:mimeType forKey:urlKey];
    [[NSUserDefaults standardUserDefaults] setObject:muDic forKey:URLMIMETYPE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

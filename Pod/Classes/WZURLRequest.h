//
//  WZURLRequest.h
//  Pods
//
//  Created by Wenqi Zhou on 12/29/15.
//
//

#import <Foundation/Foundation.h>

enum
{
    WZHTTPRequestMethodGet = 0,
    WZHTTPRequestMethodPost = 1,
    WZHTTPRequestMethodPut = 2,
    WZHTTPRequestMethodDelete = 3,
    WZHTTPRequestMethodTypeSkip
};
typedef NSInteger WZHTTPRequestMethodType;


@interface WZURLRequest : NSObject

+ (void)setAPIBaseURL:(NSString *)urlString;
+ (void)setAESKey:(NSString *)key;
+ (NSMutableURLRequest *)createRequestWithURLString:(NSString *)urlString body:(NSDictionary *)body method:(WZHTTPRequestMethodType)method;
+ (NSMutableData *)AESEncrypt:(NSString *)jsonString;
+ (uint32_t)crc32:(NSData *)input;
@end

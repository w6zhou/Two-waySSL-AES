//
//  WZURLRequest.h
//  Pods
//
//  Created by Wenqi Zhou on 12/29/15.
//
//

#import <Foundation/Foundation.h>

typedef enum WZHTTPRequestMethodType
{
    WZHTTPRequestMethodGet = 0,
    WZHTTPRequestMethodPost = 1,
    WZHTTPRequestMethodPut = 2,
    WZHTTPRequestMethodDelete = 3,
    WZHTTPRequestMethodTypeSkip
}WZHTTPRequestMethodType;

enum AESHandleType
{
    AESHandleType_Encrypt,
    AESHandleType_Decrypt
};

@interface WZURLRequest : NSObject

+ (void)setAPIBaseURL:(NSString *)urlString;
+ (void)setAESKey:(NSString *)key;
+ (void)setIV:(NSString *)iv;
+ (NSMutableURLRequest *)createRequestWithURLString:(NSString *)urlString body:(NSDictionary *)body method:(WZHTTPRequestMethodType)method;
+ (NSDictionary *)AESDecrypt:(NSData *)data;

@end

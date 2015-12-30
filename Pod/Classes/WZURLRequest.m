//
//  WZURLRequest.m
//  Pods
//
//  Created by Wenqi Zhou on 12/29/15.
//
//

#import "WZURLRequest.h"

#define TIME_OUT 8.0f

static NSString *baseURLString = @"";

@implementation WZURLRequest

+ (void)setAPIBaseURL:(NSString *)urlString{
    baseURLString = urlString;
}

+ (NSMutableURLRequest *)createRequestWithURLString:(NSString *)urlString body:(NSDictionary *)body method:(WZHTTPRequestMethodType)method
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURLString, urlString]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIME_OUT];
    switch (method) {
        case WZHTTPRequestMethodTypeSkip:
            break;
        default:
        case WZHTTPRequestMethodGet:
            [request setHTTPMethod:@"GET"];
            break;
        case WZHTTPRequestMethodPost:
            [request setHTTPMethod:@"POST"];
            break;
        case WZHTTPRequestMethodPut:
            [request setHTTPMethod:@"PUT"];
            break;
        case WZHTTPRequestMethodDelete:
            [request setHTTPMethod:@"DELETE"];
            break;
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSString *jsonString = nil;
    if (body) {
        // convert request dictionary to JSON data
        NSData *data = nil;
        NSError *error = nil;
        @try {
            data = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"Caught %@ while create JSON data (%@)", [exception name], [exception reason]);
        }
        
        //json to string
        if (data) {
            jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"JSON data is empty");
        }
        
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

@end

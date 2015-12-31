//
//  AppDelegate.m
//  Two-waySSL-AES
//
//  Created by Wenqi Zhou on 12/28/15.
//  Copyright © 2015 Wenqi Zhou. All rights reserved.
//

#import "AppDelegate.h"
#import <Two-waySSL-AES/WZNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1. step one: get AES Key
    [WZURLRequest setAPIBaseURL:@"https://54.223.243.129:10088/api"];
    NSMutableURLRequest *request = [WZURLRequest createRequestWithURLString:@"/connect" body:@{@"message_type":@2} method:WZHTTPRequestMethodPost];
    [request setValue:@"100000" forHTTPHeaderField:@"User-Uin"];
    [request setValue:[@"1." stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"Client-Version"];
    [request setValue:@"iOS" forHTTPHeaderField:@"Req-From"];
    [request setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]].stringValue forHTTPHeaderField:@"Req-Time"];
    [request setValue:[[UIDevice currentDevice] name] forHTTPHeaderField:@"Req-Name"];
    WZHTTPRequestOperation *operation = [[WZHTTPRequestOperation alloc]initWithRequest:request withPolicy:AFSSLPinningModeCertificate];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(WZHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"response: %@", responseObject);
        
        NSNumber* returnCode = [responseObject objectForKey:@"ret"];
        if ([returnCode intValue] == 0) {
            //2. step two:set AES key
            [WZURLRequest setAESKey:[responseObject objectForKey:@"key"]];
            [WZURLRequest setIV:[responseObject objectForKey:@"iv"]];
            
            //3. encrypt request and decrypt response
            [self testPhoneVerification];
        }
    } failure:^(WZHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"fail:%@",error.localizedDescription);
    }];
    [operation start];
    return YES;
}

- (void)testPhoneVerification
{
    [WZURLRequest setAPIBaseURL:@"http://54.223.243.129:10086/api"];
    NSMutableURLRequest *request = [WZURLRequest createRequestWithURLString:@"/user/getverificationcode" body:@{ @"phone" : @"18682150226" } method:WZHTTPRequestMethodPost];
#warning - please set message type to 2
    [request setValue:@"100000" forHTTPHeaderField:@"User-Uin"];
    [request setValue:@"2" forHTTPHeaderField:@"Message-Type"];
    [request setValue:[@"1." stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"Client-Version"];
    [request setValue:@"iOS" forHTTPHeaderField:@"Req-From"];
    [request setValue:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]].stringValue forHTTPHeaderField:@"Req-Time"];
    [request setValue:[[UIDevice currentDevice] name] forHTTPHeaderField:@"Req-Name"];
    WZHTTPRequestOperation *operation = [[WZHTTPRequestOperation alloc]initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(WZHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        // 4. Decrypt to get JSON if message type is 2, else use check ERROR
        NSDictionary *headers = operation.response.allHeaderFields;
        if ([[headers objectForKey:@"Message-Type"] isEqualToString:@"2"]) {
            NSDictionary *json = [WZURLRequest AESDecrypt:responseObject];
        } else if ([[headers objectForKey:@"ret"] isEqualToString:@"-110"]) {
            //重新执行第一步
        } else {
            //其他错误
            NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@", response);
        }
    } failure:^(WZHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"fail:%@",error.localizedDescription);
    }];
    [operation start];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

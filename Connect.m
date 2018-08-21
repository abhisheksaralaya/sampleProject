//
//  Connect.m
//  sampleProject
//
//  Created by Abhishek on 08/08/18.
//  Copyright © 2016 Emax. All rights reserved.
//

#import "Connect.h"


#define CONNECTION_ERROR 0
#define SESSION_ERROR 403
#define AUTHENTICATION_SUCCESS 200
#define AUTHENTICATION_FAILED 401


#define ONLINE 0
#define SANJAY 1
#define SHARATH 2
#define SUJAN 3
#define RANI 4

@interface Connect()
{
    int requestCount;
    
    BOOL redirectToLogin;
    BOOL authenticated;
    int authenticationCode;
    
    NSData *authData;
    NSURLResponse *authResponse;
    NSError *authError;
}
@end

@implementation Connect

- (int)appRunMode {
    return ONLINE;
}

- (NSMutableURLRequest *)requestForURL:(NSString *)urlString postString:(NSString *)postString {
    NSData *data=[NSData dataWithBytes:[postString UTF8String] length:[postString length]];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [request setValue:@"application/json;odata=verbose" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    return request;
}

- (void)requestNewWithURL:(NSString *)url postString:(NSString *)postString completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler{
    requestCount++;
    NSMutableURLRequest *request = [self requestForURL:url postString:postString];
    NSURLSessionTask* sessionTaskNew = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        
        NSLog(@"**************************** -- Start -- *****************************");
        NSLog(@"URL ===================> %@", url);
        NSLog(@"PostString ============> %@", postString);
        if (error) {
            NSLog(@"Error==================> %@", error);
        }
        if (resp) {
            NSLog(@"Status Code ===========> %li", resp.statusCode);
            if (resp.statusCode == 200 || resp.statusCode == 201) {
                NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"DataDict ===============> %@", dataDict);
                if([dataDict objectForKey:@"errorPage"]){
                    NSLog(@"1222");
                }
            }
        }
        
        if (resp.statusCode == 403) {
                [self authenticate:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
                    if (!error && (resp.statusCode == 200 || resp.statusCode == 201)) {
                        [self requestNewWithURL:url postString:postString completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            completionHandler(data, response ,error);
                        }];
                    } else {
                        completionHandler(data, response ,error);
                    }
                }];
            
        } else {
            requestCount--;
            completionHandler(data, response ,error);
        }
        NSLog(@"***************************** -- End -- ******************************");
    }];
    [sessionTaskNew resume];
}

- (void)authenticate:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
    if (redirectToLogin) {
        requestCount--;
        if (requestCount == 0) {
            redirectToLogin = NO;
            authenticated = NO;
        }
        return;
    }
    
    if (authenticated) {
        handler(authData, authResponse, authError);
        requestCount--;
        if (requestCount == 0) {
            authenticated = NO;
            authData = nil;
            authResponse = nil;
            authError = nil;
        }
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            NSString *signinid = [[NSUserDefaults standardUserDefaults] objectForKey:@"signinid"];
            NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
//            NSString *urlString = [self wsURL:[NSString stringWithFormat:@"app-sales/signin?signinid=%@&password=%@", signinid, password]];
            NSString *deviceId= [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            
            NSString *postString = [NSString stringWithFormat:@"{\"signinid\":\"%@\",\"password\":\"%@\",\"empDeviceId\":\"%@\"}", signinid, password, deviceId];
            
//            NSMutableURLRequest *request = [self requestForURL:urlString postString:postString];
//            NSURLSessionTask *session = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
//                NSLog(@"auth 2 ============ %@", resp);
//                requestCount--;
//                if (resp.statusCode == 401) {
//                    redirectToLogin = YES;
//                }
//                authenticated = YES;
//                authData = data;
//                authResponse = response;
//                authError = error;
//                handler(data, response, error);
////                dispatch_semaphore_signal(semaphore);
//
//            }];
//            [session resume];
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
}

@end

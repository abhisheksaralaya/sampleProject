//
//  Connect.h
//  sampleProject
//
//  Created by Abhishek on 08/08/18.
//  Copyright © 2016 Emax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface Connect : NSObject{
    NSURLSessionTask *sessionTask;
}


- (void)requestNewWithURL:(NSString *)url postString:(NSString*)postString completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end

//
//  ServiceManager.m
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/13/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//


#import "ServiceManager.h"
#import "Model.h"

@implementation ServiceManger

-(NSArray *)requestWithURL:(NSURL *)url {
    @try {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error: nil];
        
        for (NSDictionary *singleJson in json) {
            NSLog(@"%@", [singleJson valueForKey:@"title"]);
        }
        
        return json;
    } @catch (NSException *exception) {
        NSLog(@"error in fetching");
    } @finally {
//        NSLog(@"done");
    }
    return [[NSArray alloc] init];
}

@end

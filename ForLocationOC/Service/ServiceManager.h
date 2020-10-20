//
//  ServiceManager.h
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/14/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "Art"

@interface ServiceManger : NSObject

-(NSArray *)requestWithURL:(NSURL *)url;

@end

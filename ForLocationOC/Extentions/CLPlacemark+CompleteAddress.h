//
//  CLPlacemark+CompleteAddress.h
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/14/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CLPlacemark (CompleteAddress)

-(NSString *)completeAddress;
-(NSString *)importantInfo;
-(NSString *)phoneNumber;

@end

NS_ASSUME_NONNULL_END

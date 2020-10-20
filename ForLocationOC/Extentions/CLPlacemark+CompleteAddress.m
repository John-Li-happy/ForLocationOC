//
//  CLPlacemark+CompleteAddress.m
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/14/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import "CLPlacemark+CompleteAddress.h"

@implementation CLPlacemark (CompleteAddress)

-(NSString *)completeAddress {
    
    NSMutableString *address = [[NSMutableString alloc] init];
    [address appendString:self.name];
    [address appendString:self.postalCode];
    [address appendString:self.administrativeArea];
    return address;
}

-(NSString *)importantInfo {
    NSMutableString *importantInfo = [[NSMutableString alloc]init];
//    [importantInfo appendString:self.name];
    [importantInfo appendString:self.name];
    return importantInfo;
}

-(NSString *)phoneNumber {
    NSMutableString *postAddress = [[NSMutableString alloc]init];
    [postAddress appendString:self.locality];
    return postAddress;
}

@end

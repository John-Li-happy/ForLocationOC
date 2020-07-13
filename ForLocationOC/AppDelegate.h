//
//  AppDelegate.h
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/13/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


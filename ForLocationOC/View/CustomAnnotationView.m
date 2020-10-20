//
//  CustomAnnotationView.m
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/15/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAnnotationView.h"

@implementation CustomAnnotationView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil) {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if (!isInside) {
        for (UIView *view in self.subviews) {
            isInside = CGRectContainsPoint(view.frame, point);
            if (isInside) {
                break;
            }
        }
    }
    return isInside;
}
@end

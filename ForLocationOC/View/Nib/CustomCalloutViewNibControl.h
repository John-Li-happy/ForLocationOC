//
//  CustomCalloutViewNibControl.h
//  ForLocationOC
//
//  Created by Zhaoyang Li on 7/15/20.
//  Copyright © 2020 Zhaoyang Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutViewNibControl: UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headShotImageView;
@property (weak, nonatomic) IBOutlet UIButton *bestLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

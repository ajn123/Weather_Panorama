//
//  TwiiterCell.h
//  Weather
//
//  Created by Ajs mac on 12/14/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwiiterCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *MainLabel;
@property (nonatomic, strong) IBOutlet UIImageView  *ImageView;
@property (nonatomic, strong) IBOutlet UILabel      *detailLabel;

@end
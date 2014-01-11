//
//  TwitterViewController.h
//  Weather
//
//  Created by Ajs mac on 11/27/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *statuses;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;

@end
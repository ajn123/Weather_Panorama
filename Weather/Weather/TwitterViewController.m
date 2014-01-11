//
//  TwitterViewController.m
//  Weather
//
//  Created by Ajs mac on 11/27/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//
    
#import "TwitterViewController.h"
#import "STTwitter.h"
#import "TwitterWebViewController.h"
#import "TwiiterCell.h"

@interface TwitterViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end


NSString *consumerKeyTextField;
NSString *consumerSecretTextField;


    
@implementation TwitterViewController


    
- (void)viewDidLoad
{
        [super viewDidLoad];
    
        // Twitter Authorization tokens.
        consumerKeyTextField = @"gGkAgcBCttM7vcIzsMF4rg";
        consumerSecretTextField = @"2QdxoGUTI93aLQudQ5Dl2aVNFmIbHXuzju1BS2S8q0A";
        
        [self getTwitter:nil];
}
    
- (void)didReceiveMemoryWarning
{
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

//Set the authoizing to access the desired API account
- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
        
        [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
            NSLog(@"-- screenName: %@", screenName);
        } errorBlock:^(NSError *error) {
        }];
}
    

///Gets the current weather channel tweets
-(void) getTwitter:ID{

    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
   
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
    } errorBlock:^(NSError *error) {
  
    }];
    

    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:consumerKeyTextField
                                                 consumerSecret:consumerSecretTextField];
   
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
      
        [[UIApplication sharedApplication] openURL:url];
        
    } oauthCallback:@"myapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                    }];
    [_twitter getUserTimelineWithScreenName:@"weatherchannel"
                                      count:50
                               successBlock:^(NSArray *statuses) {
                                   self.statuses = statuses;
                                   
                                   [self.tableView reloadData];
                                   
                               } errorBlock:^(NSError *error) {
                               }];
    
  
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.statuses count];
}
    
- (TwiiterCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       
        
        TwiiterCell *cell =(TwiiterCell *) [tableView dequeueReusableCellWithIdentifier:@"STTwitterTVCellIdentifier"];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"STTwitterTVCellIdentifier"];
        }
        
        NSDictionary *status = [self.statuses objectAtIndex:indexPath.row];
        
        
        NSString *text = [status valueForKey:@"text"];
        NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
        NSString *dateString = [status valueForKey:@"created_at"];
        cell.ImageView.image = [UIImage imageNamed:@"twitter"];
        cell.MainLabel.text = text;
        cell.detailLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
        
        return cell;
}




//Tapping a cell display the weather channel web site
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self performSegueWithIdentifier:@"TwitterWeb" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"TwitterWeb"]) {
        
    }
}

    
    @end
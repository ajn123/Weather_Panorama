//
//  WeatherViewController.m
//  Weather
//
//  Created by Ajs mac on 11/25/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//


#import "WeatherViewController.h"
#import "AddWeatherViewController.h"
#import "WeatherWebViewController.h"
#import "AppDelegate.h"

@interface WeatherViewController ()

@property (nonatomic, strong) NSMutableDictionary *favoriteWeatherToDo;
@property (nonatomic, strong) NSMutableArray *weatherConditions;

@property (nonatomic, strong) NSMutableArray *downStreamPassArray;


- (void)addWeatherToDo:(id)sender;

@end


@implementation WeatherViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    
    // Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.favoriteWeatherToDo = appDelegate.weatherToDo;
    
   
    // Set up the Edit system button on the left of the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addWeatherToDo:)];
    
    // Set up the Add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSMutableArray *sortedNames = (NSMutableArray *)[[self.favoriteWeatherToDo allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.weatherConditions = sortedNames;
    
    self.downStreamPassArray = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}



- (void)addWeatherToDo:(id)sender
{
  
    [self performSegueWithIdentifier:@"AddWeather" sender:self];
}




- (void)addWeatherViewController:(AddWeatherViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        NSString *nameEntered = [controller.weatherName.text lowercaseString];
        
        NSString *ToDoNameEntered = [controller.toDoName.text lowercaseString];
        
        if ([self.weatherConditions containsObject:nameEntered]) {
            
            NSMutableArray *weatherNameEntered = [self.favoriteWeatherToDo objectForKey:nameEntered];
            
            [weatherNameEntered addObject:ToDoNameEntered];
            
            [self.favoriteWeatherToDo setValue:weatherNameEntered forKey:nameEntered];
            
        }
        else {
            NSMutableArray *toDoElementNameEntered = [NSMutableArray arrayWithObject:ToDoNameEntered];
            
            [self.favoriteWeatherToDo setObject:toDoElementNameEntered forKey:nameEntered];
        }
        
        NSMutableArray *sortedNames = (NSMutableArray *)[[self.favoriteWeatherToDo allKeys]
                                                                sortedArrayUsingSelector:@selector(compare:)];
        
        self.weatherConditions = sortedNames;
        
        [self.weatherTableView reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource Protocol Methods

/*
We are implementing a Grouped table view style. In the storyboard file,
select the Table View. Under the Attributes Inspector, set the Style attribute to Grouped.
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.weatherConditions count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *markedWeather = [self.weatherConditions objectAtIndex:section];
    NSMutableArray *cities = [self.favoriteWeatherToDo objectForKey:markedWeather];
    return [cities count];
}


// Set the table view section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.weatherConditions objectAtIndex:section];
}


// Set the table view section footer
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footer = [[NSString alloc] initWithFormat:@"My Favorite Things to do when it is %@", [self.weatherConditions objectAtIndex:section]];
    return footer;
}


// Customize the appearance of the table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherTableView"];
    
    // Configure the cell
    NSUInteger rowNumber = [indexPath row];

    cell.imageView.image = [UIImage imageNamed:@"favoriteIcon.png"];
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"Favorite Thing to Do #%d", rowNumber+1];

    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// This is the method invoked when the user taps the Delete button in the Edit mode
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {  // Handle the Delete action
        
        NSString *SelectionToDelete = [self.weatherConditions objectAtIndex:[indexPath section]];
        NSMutableArray *currentSelection= [self.favoriteWeatherToDo objectForKey:SelectionToDelete];
        NSString *IndividualToDelete = [currentSelection objectAtIndex:[indexPath row]];
        
        [currentSelection removeObject:IndividualToDelete];
        
        if ([currentSelection count] == 0) {
            [self.favoriteWeatherToDo removeObjectForKey:SelectionToDelete];
            
            NSMutableArray *sortedNames = (NSMutableArray *)[[self.favoriteWeatherToDo allKeys]
                                                                    sortedArrayUsingSelector:@selector(compare:)];
            self.weatherConditions = sortedNames;
        }
        else {
            [self.favoriteWeatherToDo setValue:currentSelection forKey:SelectionToDelete];
        }
        
      [self.weatherTableView reloadData];
    }
}


//Allows the user to move their favorites
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *weather = [self.weatherConditions objectAtIndex:[fromIndexPath section]];
    NSMutableArray *weatherToDo = [self.favoriteWeatherToDo objectForKey:weather];
    
    NSUInteger rowNumberFrom = fromIndexPath.row;
    NSUInteger rowNumberTo = toIndexPath.row;
    
    NSString *weatherToMoveFrom = [weatherToDo objectAtIndex:rowNumberFrom];
    NSString *weatherToMoveTo = [weatherToDo objectAtIndex:rowNumberTo];
    

    [weatherToDo replaceObjectAtIndex:rowNumberTo withObject:weatherToMoveFrom];
    [weatherToDo replaceObjectAtIndex:rowNumberFrom withObject:weatherToMoveTo];
    
    [self.favoriteWeatherToDo setObject:weatherToDo forKey:weather];
    
    //Need the table to update so it does not mess up.
    [self.weatherTableView reloadData];
   
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//Takes the user to the correctly selected website.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedByName = [self.weatherConditions objectAtIndex:[indexPath section]];
    NSMutableArray *SelectedGroup = [self.favoriteWeatherToDo objectForKey:selectedByName];
    NSString *selectedName = [SelectedGroup objectAtIndex:[indexPath row]];
    
    [self.downStreamPassArray insertObject:selectedName atIndex:0];
    [self.downStreamPassArray insertObject:selectedByName atIndex:1];
    
    [self performSegueWithIdentifier:@"WeatherWeb" sender:self];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




//User can move rows inbetween group
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSString *weatherFrom = [self.weatherConditions objectAtIndex:[sourceIndexPath section]];
    NSString *WeatherTo = [self.weatherConditions objectAtIndex:[proposedDestinationIndexPath section]];
    
    //User tried to move outside of group
    if (weatherFrom != WeatherTo) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Move Not Allowed"
                              message:@"Order Activities according to your liking only within the same  weather pattern!"
                              delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        return sourceIndexPath;
    }
    else {
        return proposedDestinationIndexPath;
    }
}



// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueIdentifier = [segue identifier];
    
    if ([segueIdentifier isEqualToString:@"AddWeather"]) {
        
        // Obtain the object reference of the destination view controller
        AddWeatherViewController *addViewController = [segue destinationViewController];
        
       addViewController.delegate = self;
        
    } else if ([segueIdentifier isEqualToString:@"WeatherWeb"]) {
        
        // Obtain the object reference of the destination view controller
        WeatherWebViewController *WebViewController = [segue destinationViewController];
        
       WebViewController.data = self.downStreamPassArray;
    }
}

@end
//
//  WhatToWearViewController.m
//  Weather
//
//  Created by Ajs mac on 12/13/13.
//  Copyright (c) 2013 Alex Norton. All rights reserved.
//

#import "WhatToWearViewController.h"
#import "WebsiteViewController.h"


@interface WhatToWearViewController()

/*
 When a table view row is expanded, new rows are inserted after it into the table view.
 When a table view row is shrunk, the rows expanded under it are deleted.
 
 These insertions and deletions will change to table view content. We define
 tableViewContent as a changeable array to hold the current rows of the table view.
 */
@property (strong, nonatomic) NSMutableArray *tableViewContent;

@property (strong, nonatomic) NSString *urlOfWebsite;

@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) NSIndexPath *selectedIndexPrevious;

@end


static BOOL weatherElementSeleted = NO;
static int selectedRowNumber;


@implementation WhatToWearViewController

- (void)viewDidLoad {
    
    // filePath is declared as a local variable of character string type
    NSString *filePath;   // File path to the plist file in the application's main bundle (project folder)
    
    //---------------------------------------------------------------------------------------------------
   filePath = [[NSBundle mainBundle] pathForResource:@"WeatherLinks" ofType:@"plist"];
    
    self.WeatherLinksDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    self.weatherConditionsArray  = [[self.WeatherLinksDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //---------------------------------------------------------------------------------------------------
    
    filePath = [[NSBundle mainBundle] pathForResource:@"WeatherLogos" ofType:@"plist"];
    
    self.weatherToElemenetsDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    //---------------------------------------------------------------------------------------------------
    
    filePath = [[NSBundle mainBundle] pathForResource:@"weatherClothes" ofType:@"plist"];
    
    self.toDoElements = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    //---------------------------------------------------------------------------------------------------
    self.tableViewContent = [[NSMutableArray alloc] init];
    
    [self.tableViewContent addObjectsFromArray:self.weatherConditionsArray];
    
    [super viewDidLoad];   // Inform super
}


// Prepare the view before it appears to the user.
-(void)viewWillAppear:(BOOL)animated
{
    if (weatherElementSeleted) {
        
        UITableViewCell *peviousCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPrevious];
        peviousCell.textLabel.textColor = [UIColor blackColor];
        UITableViewCell *currentCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndex];
        currentCell.textLabel.textColor = [UIColor blueColor];
        // Set the selected row to the saved selected index and position it to appear in the middle of the table view
        [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source Methods

// Asks the data source to return the number of sections in the table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

// Asks the data source to return the number of rows in a section, the number of which is given
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewContent count];
}

// Asks the data source to return a cell to insert in a particular table view location
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];          // Identify the row number
    
    // Obtain the object reference of the UITableViewCell object instantiated with respect to
    // the identifier TableViewCellReuseID
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseID"];
    
    NSString *rowName = [self.tableViewContent objectAtIndex:rowNumber];
    cell.textLabel.text = rowName;
    
    cell.indentationWidth = 10.0;         // 10.0 points is the default value
    
    if ([self.weatherConditionsArray containsObject:rowName]) {        // Level=0
        
        cell.indentationLevel = 0;
        
        NSString *imageWeatherName = [self.weatherToElemenetsDict objectForKey:rowName];
        cell.imageView.image = [UIImage imageNamed:imageWeatherName];
        
    } else if ([rowName isEqualToString:@"Men"] ) {
        
        cell.indentationLevel = 1;
        cell.imageView.image = [UIImage imageNamed:@"MenIcon"];
        
    } else if ([rowName isEqualToString:@"Women"] ) {
        
        cell.indentationLevel = 1;
        cell.imageView.image = [UIImage imageNamed:@"WomenIcon"];
        
    } else {   // Level=2
        
        cell.indentationLevel = 2;
        
        // Row name = image name for Level 2
        cell.imageView.image = [UIImage imageNamed:rowName];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.numberOfLines = 2;       // Set the number of lines to be displayed in each table row (cell) to 2
    cell.textLabel.lineBreakMode = 0;       // Set the line break mode to 0 so that the text wraps around on the next line
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];   // Set the row name text to use system font of size 14 pts
    
    int indentationLevel = (int)cell.indentationLevel;
    
    if (weatherElementSeleted && selectedRowNumber == indexPath.row) {
        cell.textLabel.textColor = [UIColor blueColor];     // Set the row name color to blue to indicate its selection
    } else {
        cell.textLabel.textColor = [UIColor blackColor];    // Set the row name color to black otherwise
    }
    
    switch (indentationLevel) {
        case 0:
            // Set level 1 row background color to Lavendar (#E6E6FA)
            cell.backgroundColor = [UIColor colorWithRed:230.0/255.0f green:230.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
            break;
            
        case 1:
            // Set level 2 row background color to Ivory (#FFFFF0)
            cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
            break;
            
        case 2:
            // Set level 3 row background color to PeachPuff (#FFDAB9)
            cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:185.0f/255.0f alpha:1.0f];
            break;
            
        default:
            break;
    }
    
    NSString *rowName = cell.textLabel.text;
    
    if ([self.toDoElements containsObject:rowName]) {  // Show the right arrow icon as disclosure indicator
        
        UIImage *rightArrow = [UIImage imageNamed:@"RightArrow"];
        // Set the cell's accessory view to show the RightArrow image
        cell.accessoryView = [[UIImageView alloc] initWithImage:rightArrow];
        
    } else {  // Show the down arrow icon to indicate that the row has child rows
        
        UIImage *downArrow = [UIImage imageNamed:@"DownArrow"];
        // Set the cell's accessory view to show the DownArrow image
        cell.accessoryView = [[UIImageView alloc] initWithImage:downArrow];
    }
    
    // Set the cell's selected background view
    UIView *cellBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = cellBackgroundView;
}


#pragma mark - Table View Delegate Methods

// Tells the delegate (=self) that the row specified under indexPath is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger rowNumber = [indexPath row];
    NSString *nameOfSelectedRow = [self.tableViewContent objectAtIndex:rowNumber];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    int indentationLevelSelected = (int)cell.indentationLevel;
    
    switch (indentationLevelSelected) {
            
        case 0:
        {
            weatherElementSeleted = NO;
            
            if (rowNumber == [self.tableViewContent count] - 1 || [self.weatherConditionsArray containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {
                // Expand the row
                
                self.WeatherLogosDict = [self.WeatherLinksDict objectForKey:nameOfSelectedRow];
                
                NSArray *typesOfClothes = [[self.WeatherLogosDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                int count = (int)[typesOfClothes count];
                for (int i=0; i < count; i++) {
                    
                    [self.tableViewContent insertObject:[typesOfClothes objectAtIndex:i] atIndex:++rowNumber];
                }
                
                [tableView reloadData];
                
            } else {    // Shrink the row
                while (![self.weatherConditionsArray containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {
                    
                    [self.tableViewContent removeObjectAtIndex:rowNumber+1];
                    if (rowNumber+1 > [self.tableViewContent count] - 1) break;
                }
                
                [tableView reloadData];
            }
        }
            break;
            
        case 1:
        {
            weatherElementSeleted = NO;
            
            if (rowNumber == [self.tableViewContent count]-1) {
                
                for (int j = (int)rowNumber-1; j >= 0; j--) {
                    
                    NSString *previousRowName = [self.tableViewContent objectAtIndex:j];
                    
                    if ([self.weatherConditionsArray containsObject:previousRowName]) {
                        
                        NSString *typeOfWeatherSelectedRow = previousRowName;
                        
                        self.WeatherLogosDict = [self.WeatherLinksDict objectForKey:typeOfWeatherSelectedRow];
                        
                        self.URLDicts = [self.WeatherLogosDict objectForKey:nameOfSelectedRow];
                        
                        NSArray *weatherNameInThisCategory = [[self.URLDicts allKeys] sortedArrayUsingSelector:@selector(compare:)];
                        
                        int count = (int)[weatherNameInThisCategory count];
                        for (int k=0; k < count; k++) {
                            
                            [self.tableViewContent insertObject:[weatherNameInThisCategory objectAtIndex:k] atIndex:++rowNumber];
                        }
                        
                        [tableView reloadData];
                        
                        break;
                    }
                }
                
            } else if ([self.toDoElements containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {  // Shrink the selected weather category row
                
                if ([nameOfSelectedRow isEqualToString:@"Men"]) {
                    
                    while (![[self.tableViewContent objectAtIndex:rowNumber+1] isEqualToString:@"Women"]) {
                        
                        
                        [self.tableViewContent removeObjectAtIndex:rowNumber+1];
                        if (rowNumber+1 > [self.tableViewContent count] - 1) break;
                    }
                    
                } else {
                    
                    while (![self.weatherConditionsArray containsObject:[self.tableViewContent objectAtIndex:rowNumber+1]]) {
                        
                        
                        [self.tableViewContent removeObjectAtIndex:rowNumber+1];
                        if (rowNumber+1 > [self.tableViewContent count] - 1) break;
                    }
                }
                
                [tableView reloadData];
                
            } else {
                
                for (int j = (int)rowNumber-1; j >= 0; j--) {
                    
                    NSString *previousRowName = [self.tableViewContent objectAtIndex:j];
                    
                    
                    if ([self.weatherConditionsArray containsObject:previousRowName]) {
                        
                        NSString *weatherNameOfSelectedRow = previousRowName;
                        
                        self.WeatherLogosDict = [self.WeatherLinksDict objectForKey:weatherNameOfSelectedRow];
                        
                        self.URLDicts = [self.WeatherLogosDict objectForKey:nameOfSelectedRow];
                        
                        NSArray *selectedWeatherElementsInCondition  = [[self.URLDicts allKeys] sortedArrayUsingSelector:@selector(compare:)];
                        
                        int count = (int)[selectedWeatherElementsInCondition count];
                        for (int k=0; k < count; k++) {
                            
                            [self.tableViewContent insertObject:[selectedWeatherElementsInCondition objectAtIndex:k] atIndex:++rowNumber];
                        }
                        
                        [tableView reloadData];
                        
                        break;
                    }
                }
            }
        }
            break;
            
        case 2:
        {
            weatherElementSeleted = YES;
            
            self.selectedIndexPrevious = self.selectedIndex;
            
            self.selectedIndex = indexPath;
            selectedRowNumber = (int)indexPath.row;
            
            BOOL weatherRowIdentified = NO;
            
            NSString *weatherSelectedRow;
            
            for (int n = (int)rowNumber-1; n >= 0; n--) {
                
                NSString *previousRowName = [self.tableViewContent objectAtIndex:n];
                
                if ([previousRowName isEqualToString:@"Men"] || [previousRowName isEqualToString:@"Women"]) {
                    
                    if (!weatherRowIdentified) {
                        weatherSelectedRow = [[NSString alloc] initWithString:previousRowName];
                        weatherRowIdentified = YES;
                    }
                    
                } else if ([self.weatherConditionsArray containsObject:previousRowName]) {
                    
                    NSString *weatherSelectedRowsToPick = previousRowName;
                    
                    self.WeatherLogosDict = [self.WeatherLinksDict objectForKey:weatherSelectedRowsToPick];
                    
                    self.URLDicts = [self.WeatherLogosDict objectForKey:weatherSelectedRow];
                    
                    self.urlOfWebsite = [self.URLDicts objectForKey:nameOfSelectedRow];
                    
                    // Perform the segue named Website
                    [self performSegueWithIdentifier:@"Website" sender:self];
                    
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}

// This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
// You never call this method. It is invoked by the system.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Website"]) {
        
       WebsiteViewController *websiteViewController = [segue destinationViewController];
        
        websiteViewController.websiteURL = self.urlOfWebsite;
    }
}

@end
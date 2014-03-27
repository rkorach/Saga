//
//  SGFeedTableViewController.m
//  Saga
//
//  Created by Raphaël Korach on 21/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGFeedTableViewController.h"

@interface SGFeedTableViewController () <UITableViewDataSource>
@property (strong,nonatomic) NSArray *photos;

@end

@implementation SGFeedTableViewController

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)fetchPhotos
{
    // get the sagas to display from parse
    // it should be an array of dictionnaries
    NSArray *photos = @[@{@"SAid":@1, @"GAid":@13},@{@"SAid":@2, @"GAid":@111},@{@"SAid":@3, @"GAid":@0},@{@"SAid":@4, @"GAid":@2},@{@"SAid":@5, @"GAid":@0}];
    self.photos = photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // adapt cell height depending on the cell
    // (saga cells have the info below, sa cells don't)
    float cellHeight = (![[self.photos[indexPath.row] valueForKey:@"GAid"] isEqual: @0]) ? 355.0 : 315.0;
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the correct cell sample
    NSString *CellIdentifier = (![[self.photos[indexPath.row] valueForKey:@"GAid"] isEqual: @0]) ? @"SagaCell" : @"SaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

//
//  SGProfileViewController.m
//  Saga
//
//  Created by Raphaël Korach on 24/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGProfileViewController.h"
#import "ECSlidingViewController/ECSlidingViewController.h"
#import "SGMenuViewController.h"

@interface SGProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) NSArray *photos;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@end

@implementation SGProfileViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchPhotos];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Profile Feed Cell"];
    
    /* hamburger menu code */    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[SGMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    /* end hamburger menu code */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPhotos
{
    // get the sagas to display from parse
    // it should be an array of dictionnaries
    NSArray *photos = @[@{@"SAid":@1, @"GAid":@13},@{@"SAid":@2, @"GAid":@111},@{@"SAid":@3, @"GAid":@0},@{@"SAid":@4, @"GAid":@2},@{@"SAid":@5, @"GAid":@0}];
    self.photos = photos;
    [self.collectionView reloadData];
}

- (IBAction)touchMenuButton {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Profile Feed Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(100, 100);
    retval.height += 35;
    retval.width += 35;
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}
@end

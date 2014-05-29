//
//  MTViewController.m
//  Assignment PhotoGrid
//
//  Created by Michael Tirenin on 5/27/14.
//  Copyright (c) 2014 Michael Tirenin. All rights reserved.
//

#import "MTViewController.h"
#import "MTPhotoCell.h"
#import "MTFLowLayout.h"

@interface MTViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;


@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MTFLowLayout *layout = [[MTFLowLayout alloc] init];
    
    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.collectionView addGestureRecognizer:pinchRecognizer];
    
//    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    [self.collectionView addGestureRecognizer:longPressRecognizer];
    
    _photos = [@[@"ronmueck01", @"ronmueck02", @"ronmueck03", @"ronmueck04", @"ronmueck05", @"ronmueck06", @"ronmueck07", @"ronmueck08", @"ronmueck09", @"ronmueck10", @"ronmueck11", @"ronmueck12", @"ronmueck13", @"ronmueck14", @"ronmueck15", @"ronmueck16", @"ronmueck17", @"ronmueck18", @"ronmueck19", @"ronmueck20", @"ronmueck21", @"ronmueck22", @"ronmueck23", @"ronmueck24", @"ronmueck25", @"ronmueck26", @"ronmueck27", @"ronmueck28", @"ronmueck29", @"ronmueck30", @"ronmueck31", @"ronmueck32", @"ronmueck33", @"ronmueck34", @"ronmueck35", @"ronmueck36", @"ronmueck37", @"ronmueck38", @"ronmueck39", @"ronmueck40", @"ronmueck41", @"ronmueck42", @"ronmueck43", @"ronmueck44", @"ronmueck45", @"ronmueck46", @"ronmueck47", @"ronmueck48", @"ronmueck49", @"ronmueck50", @"ronmueck51"] mutableCopy];

//    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//    _gravity = [UIGravityBehavior alloc] initWithItems:@[
    
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender
{
    // Get a reference to the flow layout
    MTFLowLayout *layout = (MTFLowLayout *)self.collectionView.collectionViewLayout;
    
    // If this is the start of the gesture
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // Get the initial location of the pinch
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        
        // Convert pinch location into a specific cell
        NSIndexPath *pinchedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        
        // Store the indexPath to cell
        layout.currentCellPath = pinchedCellPath;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        // Store the new center location of the selected cell
        layout.currentCellCenter = [sender locationInView:self.collectionView];
        
        // Store the scale value
        layout.currentCellScale = sender.scale;
    }
    else
    {
        [self.collectionView performBatchUpdates:^{
            layout.currentCellPath = nil;
            layout.currentCellScale = 1.0;
        } completion:nil];
    }
//    
//    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
//    UIGestureRecognizerState state = longPress.state;
//    
//    CGPoint location = [longPress locationInView:self.collectionView];
//    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
}

//- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender
//{
//    MTFLowLayout *layout = (MTFLowLayout *)self.collectionView.collectionViewLayout;
//
//    if (sender.state == UIGestureRecognizerStateBegan)
//    {
//        CGPoint initialTapPoint = [sender locationInView:self.collectionView];
//        NSIndexPath *tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialTapPoint];
//        layout.currentCellPath = tappedCellPath;
//    }
//    else if (sender.state == UIGestureRecognizerStateChanged)
//    {
//        layout.currentCellCenter = [sender locationInView:self.collectionView];
//        layout.currentCellScale = (layout.currentCellScale * 2);
//    }
//    else
//        [self.collectionView performBatchUpdates:^{
//            
//        }completion:nil];

//    
//    moveItemAtIndexPath:toIndexPath
//    - (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;
//    
//    - (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion; // allows multiple insert/delete/reload/move calls to be animated simultaneously. Nestable.
//
    
//}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    image = [UIImage imageNamed:_photos[row]];
    
    cell.photoView.image = image;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.layer.borderWidth = 5.f;
    cell.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1].CGColor;
    
    return cell;
}

#pragma mark - UICollectionViewFlowLayoutDelegate

static const float WIDTH = 145;
static const float HEIGHT = 145;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image;
    long row = [indexPath row];

    image = [UIImage imageNamed:_photos[row]];

    if (image.size.height != image.size.width) {
        
        return CGSizeMake(WIDTH, (image.size.height * (WIDTH/image.size.width)));
    }
    return CGSizeMake(WIDTH, HEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDelegate

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    long row = [indexPath row];
//    
//    [_photos removeObjectAtIndex:row];
//    
//    NSArray *deletions = @[indexPath];
//    
//    [self.collectionView deleteItemsAtIndexPaths:deletions];
//}



@end

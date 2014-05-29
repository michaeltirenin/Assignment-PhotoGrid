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

@interface MTViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;

//// testing ...
@property (nonatomic, weak) UIView *pieceForReset;

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MTFLowLayout *layout = [[MTFLowLayout alloc] init];
    
    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
    _photos = [@[@"ronmueck01", @"ronmueck02", @"ronmueck03", @"ronmueck04", @"ronmueck05", @"ronmueck06", @"ronmueck07", @"ronmueck08", @"ronmueck09", @"ronmueck10", @"ronmueck11", @"ronmueck12", @"ronmueck13", @"ronmueck14", @"ronmueck15", @"ronmueck16", @"ronmueck17", @"ronmueck18", @"ronmueck19", @"ronmueck20", @"ronmueck21", @"ronmueck22", @"ronmueck23", @"ronmueck24", @"ronmueck25", @"ronmueck26", @"ronmueck27", @"ronmueck28", @"ronmueck29", @"ronmueck30", @"ronmueck31", @"ronmueck32", @"ronmueck33", @"ronmueck34", @"ronmueck35", @"ronmueck36", @"ronmueck37", @"ronmueck38", @"ronmueck39", @"ronmueck40", @"ronmueck41", @"ronmueck42", @"ronmueck43", @"ronmueck44", @"ronmueck45", @"ronmueck46", @"ronmueck47", @"ronmueck48", @"ronmueck49", @"ronmueck50", @"ronmueck51"] mutableCopy];    

//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
//    [self.collectionView addGestureRecognizer:longPress];
}

//- (IBAction)longPressGestureRecognized:(id)sender
//{
//    
//    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
//    UIGestureRecognizerState state = longPress.state;
//    
//    CGPoint location = [longPress locationInView:self.collectionView];
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)self.view];
//    
//    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
//    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
//    
//    switch (state) {
//        case UIGestureRecognizerStateBegan: {
//            if (indexPath) {
//                sourceIndexPath = indexPath;
//                
//                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//                
//                // Take a snapshot of the selected row using helper method.
//                snapshot = [self customSnapshotFromView:cell];
//                
//                // Add the snapshot as subview, centered at cell's center...
//                __block CGPoint center = cell.center;
//                snapshot.center = center;
//                snapshot.alpha = 0.0;
//                [self.collectionView addSubview:snapshot];
//                [UIView animateWithDuration:0.25 animations:^{
//                    
//                    // Offset for gesture location.
//                    center.y = location.y;
//                    snapshot.center = center;
//                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                    snapshot.alpha = 0.98;
//                    
//                    // Black out.
//                    cell.backgroundColor = [UIColor blackColor];
//                } completion:nil];
//            }
//            break;
//        }
//        case UIGestureRecognizerStateChanged: {
//            CGPoint center = snapshot.center;
//            center.y = location.y;
//            snapshot.center = center;
//            
//            // Is destination valid and is it different from source?
//            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
//                
//                // ... update data source.
////                [self.objects exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
//                
//                // ... move the rows.
//                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
//                
//                // ... and update source so it is in sync with UI changes.
//                sourceIndexPath = indexPath;
//            }
//            break;
//        }
//        default: {
//            // Clean up.
//            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                snapshot.center = cell.center;
//                snapshot.transform = CGAffineTransformIdentity;
//                snapshot.alpha = 0.0;
//                
//                // Undo the black-out effect we did.
//                cell.backgroundColor = [UIColor whiteColor];
//                
//            } completion:^(BOOL finished) {
//                
//                [snapshot removeFromSuperview];
//                snapshot = nil;
//                
//            }];
//            sourceIndexPath = nil;
//            break;
//        }
//    }
//}
//// testing ...
- (IBAction)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];
        self.collectionView = [gestureRecognizer view];

        NSString *menuItemTitle = NSLocalizedString(@"Long Press", @"Reset menu item title");
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:menuItemTitle action:@selector(resetPiece:)];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems:@[resetMenuItem]];
        
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        CGRect menuLocation = CGRectMake(location.x, location.y, 0, 0);
        [menuController setTargetRect:menuLocation inView:[gestureRecognizer view]];
        
        [menuController setMenuVisible:YES animated:YES];
    }
}

//// testing ...
- (void)resetPiece:(UIMenuController *)controller
{
    UIView *pieceForReset = self.pieceForReset;
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(pieceForReset.bounds), CGRectGetMidY(pieceForReset.bounds));
    CGPoint locationInSuperview = [pieceForReset convertPoint:centerPoint toView:[pieceForReset superview]];
    
    [[pieceForReset layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [pieceForReset setCenter:locationInSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [pieceForReset setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}

// testing ...
// UIMenuController requires that we can become first responder or it won't display
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

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
////////////////
//- (UIView *)customSnapshotFromView:(UIView *)inputView {
//    
//    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
//    snapshot.layer.masksToBounds = NO;
//    snapshot.layer.cornerRadius = 0.0;
//    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
//    snapshot.layer.shadowRadius = 5.0;
//    snapshot.layer.shadowOpacity = 0.4;
//    
//    return snapshot;
//}

@end

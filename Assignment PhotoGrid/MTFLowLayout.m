//
//  MTFLowLayout.m
//  Assignment PhotoGrid
//
//  Created by Michael Tirenin on 5/28/14.
//  Copyright (c) 2014 Michael Tirenin. All rights reserved.
//

#import "MTFLowLayout.h"

@implementation MTFLowLayout

//- (void)modifyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    // If the indexPath matches the one we have stored
//    if ([layoutAttributes.indexPath isEqual:_currentCellPath])
//    {
//        // Assign the new layout attributes
//        layoutAttributes.transform3D = CATransform3DMakeScale(_currentCellScale, _currentCellScale, 1.0);
//        layoutAttributes.center = _currentCellCenter;
//        layoutAttributes.zIndex = 1;
//    }
//}

- (void)setCurrentCellScale:(CGFloat)scale;
{
    _currentCellScale = scale;
    [self invalidateLayout];
}

- (void)setCurrentCellCenter:(CGPoint)origin
{
    _currentCellCenter = origin;
    [self invalidateLayout];
}

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 10;
//    self.itemSize = CGSizeMake(44, 44);
//    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet = [NSMutableSet set];

    return self;
}

- (void)prepareLayout
{
    
    [super prepareLayout];
    
    // Need to overflow actual visible rect slightly to avoid flickering.
    CGRect visibleRect = CGRectInset((CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    // Remove any behaviours that are no longer visible.
    NSArray *noLongerVisibleBehaviours = [self.animator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }]];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.animator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
    }];
    
    // Add any newly visible behaviours.
    // A "newly visible" item is one that is in the itemsInVisibleRect(Set|Array) but not in the visibleIndexPathsSet
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        return !currentlyVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehaviour.length = 0.5f;
        springBehaviour.damping = 0.6f;
        springBehaviour.frequency = 1.0f;
        
        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
            
            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        
        [self.animator addBehavior:springBehaviour];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {

    return [self.animator itemsInRect:rect];
//
//    NSArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    
//    for(int i = 1; i < [answer count]; ++i) {
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
//        NSInteger maximumSpacing = 10;
//        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.height < self.collectionViewContentSize.height) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.y = origin + maximumSpacing;
//            currentLayoutAttributes.frame = frame;
//        }
//    }
//    return answer;

//    // Get all the attributes for the elements in the specified frame
//    NSArray *allAttributesInRect = [super layoutAttributesForElementsInRect:rect];
//    
//    for (UICollectionViewLayoutAttributes *cellAttributes in allAttributesInRect)
//    {
//        // Modify the attributes for the cells in the frame rect
//        [self modifyLayoutAttributes:cellAttributes];
//    }
//    return allAttributesInRect;

}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // Get the current attributes for the item at the indexPath
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//
//    // Modify them to match the *pinch* values
//    [self modifyLayoutAttributes:attributes];
//    
//    // Return them to collection view
//    return attributes;
    
    return [self.animator layoutAttributesForCellAtIndexPath:indexPath];

}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [self.animator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

@end

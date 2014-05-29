//
//  MTFLowLayout.h
//  Assignment PhotoGrid
//
//  Created by Michael Tirenin on 5/28/14.
//  Copyright (c) 2014 Michael Tirenin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTFLowLayout : UICollectionViewFlowLayout

@property (strong, nonatomic) NSIndexPath *currentCellPath;
@property (nonatomic) CGPoint currentCellCenter;
@property (nonatomic) CGFloat currentCellScale;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;

@end

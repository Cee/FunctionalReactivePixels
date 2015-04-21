//
//  FRPFullSizePhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by Cee on 21/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPFullSizePhotoViewController;

@protocol FRPFullSizePhotoViewControllerDelegate <NSObject>

@optional
- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index;

@end

@interface FRPFullSizePhotoViewController : UIViewController

- (instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSArray *photoModelArray;
@property (nonatomic, weak) id<FRPFullSizePhotoViewControllerDelegate> delegate;

@end

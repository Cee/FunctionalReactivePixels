//
//  FRPCell.m
//  FunctionalReactivePixels
//
//  Created by Cee on 21/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"

@interface FRPCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) RACDisposable *subscription;

@end

@implementation FRPCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_bg"]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    self.layer.cornerRadius = 10.f;
    self.layer.masksToBounds = YES;
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.subscription dispose], self.subscription = nil;
}

#pragma mark - Public Method

- (void)setPhotoModel:(FRPPhotoModel *)photoModel
{
    self.subscription = [[[RACObserve(photoModel, thumbnailData) filter:^BOOL(id value) {
        return value != nil;
    }] map:^id(id value) {
        return [UIImage imageWithData:value];
    }] setKeyPath:@keypath(self.imageView, image)
         onObject:self.imageView];
}

@end

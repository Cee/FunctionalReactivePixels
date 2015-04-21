//
//  FRPGalleryFlowLayout.m
//  FunctionalReactivePixels
//
//  Created by Cee on 20/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    self.itemSize = CGSizeMake(kFRPGalleryGridWidth, kFRPGalleryGridWidth);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return self;
}


@end

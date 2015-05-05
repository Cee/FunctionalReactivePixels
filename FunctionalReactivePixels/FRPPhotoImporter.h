//
//  FRPPhotoImporter.h
//  FunctionalReactivePixels
//
//  Created by Cee on 20/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRPPhotoModel;

@interface FRPPhotoImporter : NSObject

+ (RACSignal *)importPhotosWithFeatureType:(PXAPIHelperPhotoFeature)type;
+ (RACReplaySubject *)fetchPhotoDetails:(FRPPhotoModel *)photoModel;

@end

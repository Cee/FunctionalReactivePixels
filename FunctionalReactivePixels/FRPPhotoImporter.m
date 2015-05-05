//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by Cee on 20/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter

+ (RACReplaySubject *)importPhotosWithFeatureType:(PXAPIHelperPhotoFeature)type
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest *request = [self photoURLRequestWithType:type];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   id results = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:0
                                                                                  error:nil];
                                   [subject sendNext:[[[results[@"photos"] rac_sequence] map:^id(NSDictionary *photoDictionary) {
                                       FRPPhotoModel *model = [[FRPPhotoModel alloc] init];
                                       
                                       [self configurePhotoModel:model
                                                  withDictionary:photoDictionary];
                                       [self downloadThumbnailForPhotoModel:model];
                                       
                                       return model;
                                   }] array]];
                                   [subject sendCompleted];
                               } else {
                                   [subject sendError:connectionError];
                               }
                           }];

    return subject;
}

+ (RACReplaySubject *)fetchPhotoDetails:(FRPPhotoModel *)photoModel
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSURLRequest *request = [self photoURLRequest:photoModel];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data) {
                                   id results = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:0
                                                                                  error:nil][@"photo"];
                                   [self configurePhotoModel:photoModel withDictionary:results];
                                   [self downloadFullsizedImageForPhotoModel:photoModel];
                                   
                                   [subject sendNext:photoModel];
                                   [subject sendCompleted];
                               } else {
                                   [subject sendError:connectionError];
                               }
                           }];
    
    return subject;
}

#pragma mark - Private Methods

+ (NSURLRequest *)photoURLRequestWithType:(PXAPIHelperPhotoFeature)type
{
    return [FRPAppDelegate.apiHelper urlRequestForPhotoFeature:type
                                                resultsPerPage:20
                                                          page:0
                                                    photoSizes:PXPhotoModelSizeThumbnail
                                                     sortOrder:PXAPIHelperSortOrderRating
                                                        except:PXPhotoModelCategoryNude];
}

+ (NSURLRequest *)photoURLRequest:(FRPPhotoModel *)photoModel
{
    return [FRPAppDelegate.apiHelper urlRequestForPhotoID:photoModel.identifier.integerValue];
}

+ (void)configurePhotoModel:(FRPPhotoModel *)photoModel withDictionary:(NSDictionary *)dictionary
{
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];
    photoModel.thumbnailURL = [self urlForImageSize:3 inArray:dictionary[@"images"]];
    
    if (dictionary[@"comments_count"]) {
        photoModel.fullsizedURL = [self urlForImageSize:4 inArray:dictionary[@"images"]];
    }
}

+ (NSString *)urlForImageSize:(NSInteger)size inArray:(NSArray *)array
{
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+ (void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel
{
    [self download:photoModel.thumbnailURL withCompletion:^(NSData *data) {
        photoModel.thumbnailData = data;
    }];
}

+ (void)downloadFullsizedImageForPhotoModel:(FRPPhotoModel *)photoModel
{
    [self download:photoModel.fullsizedURL withCompletion:^(NSData *data) {
        photoModel.fullsizedData = data;
    }];
}

+ (void)download:(NSString *)urlString withCompletion:(void(^)(NSData *data))completion
{
    NSAssert(urlString, @"URL must not be nil");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (completion) {
                                   completion(data);
                               }
                           }];
 
}

@end

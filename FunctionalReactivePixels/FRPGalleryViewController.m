//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by Cee on 20/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPCell.h"
#import "FRPFullSizePhotoViewController.h"

@interface FRPGalleryViewController () <FRPFullSizePhotoViewControllerDelegate>
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic) PXAPIHelperPhotoFeature feature;
@end

@implementation FRPGalleryViewController

static NSString * const reuseIdentifier = @"Cell";

- (id)initWithFeature:(PXAPIHelperPhotoFeature)feature
{
    FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
    self = [self initWithCollectionViewLayout:flowLayout];
    self.feature = feature;
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.feature) {
        case PXAPIHelperPhotoFeaturePopular:
            self.title = @"Popular";
            break;
        case PXAPIHelperPhotoFeatureEditors:
            self.title = @"Choice";
            break;
        case PXAPIHelperPhotoFeatureUpcoming:
            self.title = @"Upcoming";
            break;
        default:
            break;
    }
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    // Register cell classes
    [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    @weakify(self);
    [RACObserve(self, photosArray) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [self loadPopularPhotosWithFeature:self.feature];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setPhotoModel:self.photosArray[indexPath.row]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRPFullSizePhotoViewController *viewController = [[FRPFullSizePhotoViewController alloc] initWithPhotoModels:self.photosArray
                                                                                               currentPhotoIndex:indexPath.item];
    viewController.delegate = self;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - FRPFullSizePhotoViewControllerDelegate

- (void)userDidScroll:(FRPFullSizePhotoViewController *)viewController toPhotoAtIndex:(NSInteger)index
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
}

#pragma mark - Private Method

- (void)loadPopularPhotosWithFeature:(PXAPIHelperPhotoFeature)type
{
    [[FRPPhotoImporter importPhotosWithFeatureType:type] subscribeNext:^(id array) {
        self.photosArray = array;
    } error:^(NSError *error) {
        NSLog(@"Couldn't fetch photos from 500px: %@", error);
    }];
}

@end

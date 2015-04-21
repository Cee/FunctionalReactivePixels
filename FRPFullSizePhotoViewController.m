//
//  FRPFullSizePhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by Cee on 21/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "FRPFullSizePhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoViewController.h"

@interface FRPFullSizePhotoViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSArray *photoModelArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation FRPFullSizePhotoViewController

- (instancetype)initWithPhotoModels:(NSArray *)photoModelArray currentPhotoIndex:(NSInteger)photoIndex
{
    self = [super init];
    if (!self) return nil;
    
    self.photoModelArray = photoModelArray;
    
    self.title = [self.photoModelArray[photoIndex] photoName];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:@{UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:photoIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.pageViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UIPageViewControllerDataSource>

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    self.title = [[self.pageViewController.viewControllers.firstObject photoModel] photoName];
    [self.delegate userDidScroll:self toPhotoAtIndex:[self.pageViewController.viewControllers.firstObject photoIndex]];
}

#pragma mark <UIPageViewControllerDelegate>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(FRPPhotoViewController *)viewController
{
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(FRPPhotoViewController *)viewController
{
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

#pragma mark - Private Methods

- (FRPPhotoViewController *)photoViewControllerForIndex:(NSInteger)index
{
    if (index >= 0 && index < self.photoModelArray.count) {
        FRPPhotoModel *photoModel = self.photoModelArray[index];
        
        FRPPhotoViewController *photoViewController = [[FRPPhotoViewController alloc] initWithPhotoModel:photoModel
                                                                                                   index:index];
        return photoViewController;
    }
    
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

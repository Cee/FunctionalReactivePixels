//
//  FRPPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by Cee on 21/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "FRPPhotoViewController.h"
#import "FRPPhotoModel.h"
#import "FRPPhotoImporter.h"
#import <SVProgressHUD.h>

@interface FRPPhotoViewController ()

@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) FRPPhotoModel *photoModel;

@end

@implementation FRPPhotoViewController

- (instancetype)initWithPhotoModel:(FRPPhotoModel *)photoModel index:(NSInteger)photoIndex
{
    self = [super init];
    if (!self) return nil;
    
    self.photoModel = photoModel;
    self.photoIndex = photoIndex;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,
                                                                           self.view.bounds.size.width,
                                                                           self.view.bounds.size.height - 64)];
    RAC(imageView, image) = [RACObserve(self.photoModel, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [SVProgressHUD show];
    
    [[FRPPhotoImporter fetchPhotoDetails:self.photoModel] subscribeError:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Error"];
    } completed:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

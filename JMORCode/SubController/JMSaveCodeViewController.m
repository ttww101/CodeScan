//
//  JMSaveCodeViewController.m
//  JMORCode
//
//  Created by 赵俊明 on 2017/11/25.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMSaveCodeViewController.h"

@import GoogleMobileAds;
@interface JMSaveCodeViewController ()
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@end

@implementation JMSaveCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = JMColor(240, 240, 240);
    _shareImage.image = _image;
    _shareImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"gif.base.alert.done", "") style:(UIBarButtonItemStyleDone) target:self action:@selector(doneExe:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)doneExe:(UIBarButtonItem *)item
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    
    [MobClick event:@"masterboard_home_share"];
    [self shareToFriends];
}

- (IBAction)save:(id)sender {
    
    // 初始化广告
    [MobClick event:@"masterboard_home_save"];
    [self createAndLoadInterstitial];
    UIImageWriteToSavedPhotosAlbum(_image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if(error) {
        [self showInfo:[NSString stringWithFormat:@"error: %@",error]];
    } else {
        [self showInfo:NSLocalizedString(@"gif.base.alert.success", "")];
    }
}

#pragma mark - Error handle
- (void)showInfo:(NSString*)str {
    [self showInfo:str andTitle:NSLocalizedString(@"gif.base.alert.alert", "")];
}

- (void)showInfo:(NSString*)str andTitle:(NSString *)title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.interstitial.isReady) {
            
            [MobClick event:@"scanCodeADShow"];
            [self.interstitial presentFromRootViewController:self];
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)shareToFriends
{
    // 初始化广告
    [self createAndLoadInterstitial];
    NSMutableArray *items = [NSMutableArray array];
    if (_image) {
        
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        [items addObject:[NSString stringWithFormat:@"#%@#", appName]];
        [items addObject:_image];
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[ UIActivityTypeCopyToPasteboard]];
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    if (IS_IPAD) {
        
        UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
        
        if (popover){
            popover.sourceView = self.navigationController.navigationBar;
            popover.sourceRect = self.navigationController.navigationBar.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
        }
    }
    
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        NSString *title = completed?NSLocalizedString(@"gif.base.alert.success", ""):NSLocalizedString(@"gif.base.alert.Failed", "");
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionSuccess = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.interstitial.isReady) {[self.interstitial presentFromRootViewController:self];}
        }];
        
        [alertVC addAction:actionSuccess];
        [self presentViewController:alertVC animated:YES completion:nil];
    };
}

// 插页广告
- (void)createAndLoadInterstitial {
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GoogleUtiID_pageInsert];
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[@"38f0acbef2e79c22b6b8fbab2669b75b", kGADSimulatorID];
    [self.interstitial loadRequest:request];
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

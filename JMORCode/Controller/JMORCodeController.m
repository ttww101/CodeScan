//
//  JMORCodeController.m
//  JMORCode
//
//  Created by JM Zhao on 2017/11/21.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMORCodeController.h"
#import "MMScanViewController.h"
#import "JMDrawQrCoderController.h"
#import "JMDrawBarCoderController.h"
#import "JMPuzzleMenuView.h"
#import "JMAboutUsController.h"
#import "JMBaseWebViewController.h"
#import "JMADView.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "JMQRCodeCollectionController.h"
#import "JMBarCodeViewController.h"

@import GoogleMobileAds;
@interface JMORCodeController ()<GADNativeExpressAdViewDelegate, GADVideoControllerDelegate, GADInterstitialDelegate>
@property (strong, nonatomic) JMADView *adView;
@property (strong, nonatomic) IBOutlet JMPuzzleMenuView *menuView;
@property (nonatomic, weak) UICollectionView *collection;
@property (strong, nonatomic) IBOutlet GADNativeExpressAdView *googleAdView;
@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) FLAnimatedImageView *particleView;
@end

@implementation JMORCodeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0]
                           };
    self.navigationController.navigationBar.titleTextAttributes = attr;
    
    int x = [self getRandomNumber:0 to:2];
    if (x == 1) {
    
        if (self.interstitial.isReady) {
            
            [MobClick event:@"scanCodeADShow"];
            [self.interstitial presentFromRootViewController:self];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self createAndLoadInterstitial];
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from+1)));
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // http://blog.csdn.net/gxp1032901/article/details/41879557
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JMSelf(ws);
    self.menuView.didSelectBlock = ^(NSInteger type) {[ws chouseORCode:type];};
    self.title = NSLocalizedString(@"orscan.items.scan", "");
    
    // 原生广告
    [self setupAd];
    
    self.particleView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 84, kW, kH - _menuView.y)];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"loadings" ofType:@"gif"];
    FLAnimatedImage *image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:file]];
    self.particleView.animatedImage = image;
    [self.view addSubview:self.particleView];
}

- (IBAction)orcodeSetting:(id)sender {

    JMAboutUsController *about = [[JMAboutUsController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
}

- (void)chouseORCode:(NSInteger)type
{
    [self createAndLoadInterstitial];
    
    if (type == 0) {
        [MobClick event:@"scanCodeQRAdnBarSacn"];
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
//                NSLog(@"扫描结果：%@",result);
                NSArray *codes = [result componentsSeparatedByString:@">"];
                BOOL isQ = [codes.firstObject isEqualToString:@"Q"];
                [self showInfo:codes.lastObject isQ:isQ];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (type == 1) {
        [MobClick event:@"scanCodeQRSacn"];
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
//                NSLog(@"扫描结果：%@",result);
                [self showInfo:result isQ:YES];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (type== 2) {
        [MobClick event:@"scanCodeBarSacn"];
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeBarCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                NSLog(@"error: %@",error);
            } else {
//                NSLog(@"扫描结果：%@",result);
                [self showInfo:result isQ:NO];
            }
        }];
        [self.navigationController pushViewController:scanVc animated:YES];
    } else if (type == 3) {
        [MobClick event:@"scanCodeQRCreat"];
        JMQRCodeCollectionController *qrCode = [[JMQRCodeCollectionController alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
        
    } else if (type == 4) {
        [MobClick event:@"scanCodeBarCreat"];
        JMBarCodeViewController *drawBarVC = [[JMBarCodeViewController alloc] init];
        [self.navigationController pushViewController:drawBarVC animated:YES]; 
    }else{
        [MobClick event:@"scanCodeADShow"];
        [self createAndLoadInterstitial];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [hud hideAnimated:YES];
                if (self.interstitial.isReady) {
                    
                    [MobClick event:@"scanCodeADShow"];
                    [self.interstitial presentFromRootViewController:self];
                }
            });
        });
    }
}

#pragma mark - Error handle
- (void)showInfo:(NSString*)str isQ:(BOOL)isQ {
    
    [self showInfo:str andTitle:NSLocalizedString(@"gif.base.alert.alert", "") isQ:isQ];
}

- (void)showInfo:(NSString*)str andTitle:(NSString *)title isQ:(BOOL)isQ
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"orscan.items.copy", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        UIAlertController *al = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"orscan.items.copySuccess", "") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:UIAlertActionStyleDefault handler:nil];
        [al addAction:ac];
        [self presentViewController:al animated:YES completion:NULL];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:isQ?NSLocalizedString(@"orscan.items.open", ""):NSLocalizedString(@"gif.base.alert.sure", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (isQ) {
            JMBaseWebViewController *drawVC = [[JMBaseWebViewController alloc] init];
            drawVC.title = NSLocalizedString(@"gif.set.sectionOne.rowZero", "");
            drawVC.urlString = str;
            [self.navigationController pushViewController:drawVC animated:YES];
        }
    }];

    [alert addAction:action2];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark -- 初始化广告
- (void)setupAd
{
    self.googleAdView.adUnitID = GoogleUtiID_origin;
    self.googleAdView.rootViewController = self;
    self.googleAdView.delegate = self;
    
    // The video options object can be used to control the initial mute state of video assets.
    // By default, they start muted.
    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
    videoOptions.startMuted = true;
    [self.googleAdView setAdOptions:@[ videoOptions ]];
    
    // Set this UIViewController as the video controller delegate, so it will be notified of events
    // in the video lifecycle.
    self.googleAdView.videoController.delegate = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"38f0acbef2e79c22b6b8fbab2669b75b", kGADSimulatorID];
    [self.googleAdView loadRequest:request];
}

#pragma mark - GADadViewDelegate
- (void)adViewDidReceiveAd:(GADNativeExpressAdView *)adView {
    
    NSLog(@"3333333");
    [self.particleView removeFromSuperview];
    if (adView.videoController.hasVideoContent) {
        NSLog(@"Received ad an with a video asset.");
    } else {
        NSLog(@"Received ad an without a video asset.");
    }
}

- (void)nativeExpressAdViewDidReceiveAd:(GADNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"1111111");
    [self.particleView removeFromSuperview];
}

#pragma mark - GADVideoControllerDelegate
- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController
{
    [self.particleView removeFromSuperview];
    NSLog(@"22222222");
}

// 插页广告
- (void)createAndLoadInterstitial {
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GoogleUtiID_pageInsert];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
    request.testDevices = @[@"38f0acbef2e79c22b6b8fbab2669b75b", kGADSimulatorID];
    [self.interstitial loadRequest:request];
}

#pragma mark Display-Time Lifecycle Notifications, GADInterstitialDelegate
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidReceiveAd");
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

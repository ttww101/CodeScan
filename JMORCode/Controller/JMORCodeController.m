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
#import "JMQRCodeCollectionController.h"
#import "JMBarCodeViewController.h"
#import "JMQRCodeCollectionViewCell.h"
#import "JMQRCodeCollModel.h"

@import GoogleMobileAds;
@interface JMORCodeController ()<GADInterstitialDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation JMORCodeController
static NSString *const oneRowID = @"threeRow";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.interstitial.isReady) {
        
        [MobClick event:@"scanCodeADShow"];
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [self creatModels];
    self.title = NSLocalizedString(@"orscan.items.scan", "");
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
    collection.backgroundColor = JMTabViewBaseColor;
    collection.dataSource = self;
    collection.delegate = self;
    collection.showsVerticalScrollIndicator = NO;
    [collection registerClass:[JMQRCodeCollectionViewCell class] forCellWithReuseIdentifier:oneRowID];
    [self.view addSubview:collection];
    self.collection = collection;
}

- (IBAction)orcodeSetting:(id)sender {

    JMAboutUsController *about = [[JMAboutUsController alloc] init];
    [self.navigationController pushViewController:about animated:YES];
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

// 插页广告
- (void)createAndLoadInterstitial {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GoogleUtiID_pageInsert];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
//    request.testDevices = @[@"38f0acbef2e79c22b6b8fbab2669b75b", kGADSimulatorID];
    [self.interstitial loadRequest:request];
}

#pragma mark Display-Time Lifecycle Notifications, GADInterstitialDelegate
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidReceiveAd");
}


/////////////////////////
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMQRCodeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneRowID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self createAndLoadInterstitial];
    if (indexPath.row == 0) {
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
    } else if (indexPath.row == 1) {
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
    } else if (indexPath.row == 2) {
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
    } else if (indexPath.row == 3) {
        [MobClick event:@"scanCodeQRCreat"];
        JMQRCodeCollectionController *qrCode = [[JMQRCodeCollectionController alloc] init];
        [self.navigationController pushViewController:qrCode animated:YES];
        
    } else if (indexPath.row == 4) {
        
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


#pragma mark UICollectionViewDataSource,
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kW-30)/2, (kH-40-64)/3);
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

// 动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

// 动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (NSMutableArray *)creatModels
{
    NSMutableArray *models = [NSMutableArray array];
    NSArray *dics = @[@{@"title":NSLocalizedString(@"orscan.items.scan", ""), @"image":@"ScanCode"}, @{@"title":NSLocalizedString(@"orscan.items.scanQRCode", ""), @"image":@"scanqrCode"}, @{@"title":NSLocalizedString(@"orscan.items.scanBarCode", ""), @"image":@"scanbarCode"}, @{@"title":NSLocalizedString(@"orscan.items.creatQRCode", ""), @"image":@"QRCode"}, @{@"title":NSLocalizedString(@"orscan.items.creatBarCode", ""), @"image":@"BarCoder"}, @{@"title":NSLocalizedString(@"orscan.items.scanAD", ""), @"image":@"AD"}];
    
    for (NSDictionary *dic in dics) {
        JMQRCodeCollModel *model = [JMQRCodeCollModel new];
        model.title = dic[@"title"];
        model.image = dic[@"image"];
        [models addObject:model];
    }
    return models;
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

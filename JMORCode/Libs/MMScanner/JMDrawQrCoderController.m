//
//  JMDrawQrCoderController.m
//  JMORCode
//
//  Created by JM Zhao on 2017/11/21.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMDrawQrCoderController.h"
#import "MMScanViewController.h"
#import "JMPhotosAlertView.h"
@interface JMDrawQrCoderController ()<UIGestureRecognizerDelegate, UITextFieldDelegate, JMPhotosAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UITextField *linkTfd;
@property (nonatomic, weak) JMPhotosAlertView *alert;
@end

@implementation JMDrawQrCoderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = JMColor(234, 234, 241);
}

- (void)creatAlertView
{
    // NSLocalizedString(@"gif.base.alert.download", ""),
    
    NSArray *array = @[NSLocalizedString(@"orscan.items.scanShare", ""),NSLocalizedString(@"orscan.items.scanSaveLib", ""),NSLocalizedString(@"gif.base.alert.cancle", "")];
    JMPhotosAlertView *alert = [[JMPhotosAlertView alloc] initWithFrame:CGRectMake(0, kH, kW, alertHeight)];
    alert.titles = array;
    alert.delegate = self;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:backView];
    [backView addSubview:alert];
    
    self.alert = alert;
    [UIView animateWithDuration:0.2 animations:^{
        
        backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        alert.frame = CGRectMake(0, kH-(10+alertHeight*array.count), kW, 10+alertHeight*array.count);
    }];
}


#pragma mark -- JMPhotosAlertViewDelegate
- (void)photoFromSource:(NSInteger)sourceType;
{
    if (sourceType == 200){
        
        [self shareToFriends];
        
    }else if(sourceType == 201){
        
        UIImageWriteToSavedPhotosAlbum(_qrImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
}

- (void)cancle
{
    
}

- (IBAction)createQrBtnClicked:(id)sender {
    
    if (_linkTfd.text == nil || _linkTfd.text.length == 0) {
        _linkTfd.placeholder = NSLocalizedString(@"orscan.items.scanInputNumber", "");
    }
    
    // UIImage *image = [MMScanViewController createQRImageWithString:_linkTfd.text QRSize:CGSizeMake(250, 250) QRColor:[UIColor blackColor] bkColor:[UIColor colorWithRed:0.318 green:0.690 blue:0.839 alpha:1.00]];
    // 如果不需要设置背景色以及前景色，则使用下面代码  默认白色底黑色码
    UIImage *image = [MMScanViewController createQRImageWithString:_linkTfd.text QRSize:CGSizeMake(kW, kW)];
    [_qrImageView setImage: image];
    [self creatAlertView];
}

//长按保存图片
- (IBAction)tapImage:(id)sender {
    
    if (self.qrImageView.image) {
    
        [self creatAlertView];
    }else{
        [self showInfo:NSLocalizedString(@"orscan.items.scanCreatCodeFrist", "")];
    }
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
    
    
    UIAlertAction *action1 = ({
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"gif.base.alert.sure", "") style:UIAlertActionStyleDefault handler:NULL];
        action;
    });
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)shareToFriends
{
    NSMutableArray *items = [NSMutableArray array];
    if (self.qrImageView.image) {
        
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        [items addObject:[NSString stringWithFormat:@"#%@#", appName]];
        [items addObject:self.qrImageView.image];
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage]];
    
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
            
            //                if (self.interstitial.isReady) {
            //
            //                    [self.interstitial presentFromRootViewController:self];
            //                    [self createAndLoadInterstitial];
            //                }
        }];
        
        [alertVC addAction:actionSuccess];
        [self presentViewController:alertVC animated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
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

//
//  JMAboutUsController.m
//  YaoYao
//
//  Created by JM Zhao on 2016/11/30.
//  Copyright © 2016年 JunMingZhaoPra. All rights reserved.
//

#import "JMAboutUsController.h"
#import "JMUserDefault.h"
#import "UIView+Extension.h"
#import "UINavigationBar+Awesome.h"
#import "JMAboutCell.h"
#import "JMAboutModel.h"
#import "JMAccountHeaderFooter.h"
#import "JMAboutHeaderView.h"

@interface JMAboutUsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UITableView *tabView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation JMAboutUsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = JMColor(41, 41, 41);
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    NSDictionary *attr = @{
//                           NSForegroundColorAttributeName : JMColor(41, 41, 41),
//                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0]
//                           };
//    self.navigationController.navigationBar.titleTextAttributes = attr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"gif.set.navigation.title", "");
    self.view.backgroundColor = JMColor(240, 240, 240);
    [self loadDataSource];
    [self setUI];
}

- (void)setUI
{
    JMAboutHeaderView *header = [[JMAboutHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width*0.45)];
    UITableView *tabView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    tabView.scrollEnabled = NO;
    [tabView registerClass:[JMAboutCell class] forCellReuseIdentifier:@"aboutCell"];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.sectionHeaderHeight = 0;
    tabView.sectionFooterHeight = 0;
    tabView.separatorColor = tabView.backgroundColor;
    tabView.tableHeaderView = header;
    [self.view addSubview:tabView];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){tabView.cellLayoutMarginsFollowReadableWidth = NO;}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0?0:35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JMAccountHeaderFooter *headView = [JMAccountHeaderFooter headViewWithTableView:tableView];
    if (section == 1) {headView.name.text = NSLocalizedString(@"gif.set.header.SectionThree", "");}
    return headView;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"aboutCell";

    JMAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {cell = [[JMAboutCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];}
    cell.model = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 && indexPath.row == 0) {
        
        [MobClick event:@"masterboard_set_callback"];
        [self customerFeedback];
        
    }else if (indexPath.section ==0 && indexPath.row == 1){
    
        [MobClick event:@"masterboard_set_comment"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppiTunesID_ScanCode]];
        
    }else if (indexPath.section ==0 && indexPath.row == 2){
        
        [MobClick event:@"masterboard_set_share"];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:@"ScanCode"];
        [items addObject:[NSURL URLWithString:AppiTunesID_ScanCode]];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToTwitter]];
        activityViewController.excludedActivityTypes = excludedActivityTypes;
        [self presentViewController:activityViewController animated:YES completion:nil];
        activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            
            NSLog(@"%@  ----   %@", activityType, returnedItems);
        };

    }else if (indexPath.section ==1 && indexPath.row == 0){
        
        [MobClick event:@"masterboard_set_one"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppiTunesID_ebookReader]];
        
    }
}

// 用户反馈
- (void)customerFeedback
{
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"simplismvip@163.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"simplismvip@163.com", nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];

    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"simplismvip@163.com", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    
    // 添加主题
    [mailUrl appendString:@"&subject=用户反馈"];
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *sysVersion= [[UIDevice currentDevice] systemVersion];
    NSString *device = [[UIDevice currentDevice] model];
    NSString *buildID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersionID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *emailString = [NSString stringWithFormat:@"&body=<b>应用名称: %@, 设备类型: %@, 系统版本: %@, build版本: %@, app版本: %@</b>", appName, device, sysVersion, buildID, appVersionID];
    [mailUrl appendString:emailString];
    
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet;
    NSString *email = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:set];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadDataSource
{
    NSArray *secOne = @[NSLocalizedString(@"gif.set.aboutUs.rowZero", ""), NSLocalizedString(@"gif.set.aboutUs.rowOne", ""), NSLocalizedString(@"gif.set.aboutUs.rowTwo", "")];
    
    NSArray *secTwo = @[@{@"title":NSLocalizedString(@"gif.base.otherApp.epubreader", ""), @"icon":@"ebookreader"}];
    
    NSMutableArray *secOneArr = [NSMutableArray array];
    for (NSString *titles in secOne) {
        
        JMAboutModel *model = [[JMAboutModel alloc] init];
        model.title = titles;
        model.isShowImage = NO;
        [secOneArr addObject:model];
    }
    
    NSMutableArray *secTwoArr = [NSMutableArray array];
    for (NSDictionary *titles in secTwo) {
        
        JMAboutModel *model = [[JMAboutModel alloc] init];
        model.title = titles[@"title"];
        model.icon = titles[@"icon"];
        model.isShowImage = YES;
        [secTwoArr addObject:model];
    }
    
    self.dataSource = @[secOneArr, secTwoArr];
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

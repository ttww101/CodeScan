//
//  JMQRCodeCollectionController.m
//  JMORCode
//
//  Created by JM Zhao on 2017/11/24.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMQRCodeCollectionController.h"
#import "JMQRCodeCollModel.h"
#import "JMQRCodeCollectionViewCell.h"
#import "JMNumberInputViewController.h"
#import "UINavigationBar+Awesome.h"
#import "JMEmailInputViewController.h"

#import "JMTextInputViewController.h"
@interface JMQRCodeCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMQRCodeCollectionController

static NSString *const oneRowID = @"threeRow";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = JMColor(41, 41, 41);
    NSDictionary *attr = @{
                           NSForegroundColorAttributeName : JMColor(41, 41, 41),
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0]
                           };
    self.navigationController.navigationBar.titleTextAttributes = attr;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) { self.dataSource = [NSMutableArray array];}
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码";
    NSArray *aray = @[@{@"title":@"文本", @"image":@"text"}, @{@"title":@"邮箱",@"image":@"email"}, @{@"title":@"网址", @"image":@"website"}, @{@"title":@"电话", @"image":@"phone"}, @{@"title":@"名片", @"image":@"namei"}, @{@"title":@"WiFi", @"image":@"WiFi"}, @{@"title":@"地址", @"image":@"local"}, @{@"title":@"密码", @"image":@"mima"}, @{@"title":@"广告", @"image":@"AD"}];
    
    for (NSDictionary *dic in aray) {
        JMQRCodeCollModel *model = [[JMQRCodeCollModel alloc] init];
        model.title = dic[@"title"];
        model.image = dic[@"image"];
        [self.dataSource addObject:model];
    }
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:collectionLayout];
    collection.backgroundColor = JMTabViewBaseColor;
    collection.dataSource = self;
    collection.delegate = self;
//    collection.backgroundColor = JMColor(250, 108, 135);
    collection.showsVerticalScrollIndicator = NO;
    [collection registerClass:[JMQRCodeCollectionViewCell class] forCellWithReuseIdentifier:oneRowID];
    [self.view addSubview:collection];
    self.collection = collection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JMQRCodeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneRowID forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
     
        JMTextInputViewController *textinput = [JMTextInputViewController new];
        textinput.title = @"文本";
        textinput.playholder = @"输入文本内容...";
        [self.navigationController pushViewController:textinput animated:YES];
    
    }else if (indexPath.row == 1){
        
        JMEmailInputViewController *textinput = [JMEmailInputViewController new];
        textinput.title = @"邮箱";
        textinput.playholder = @"输入邮箱...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 2){
     
        JMTextInputViewController *textinput = [JMTextInputViewController new];
        textinput.title = @"网址";
        textinput.playholder = @"输入网址...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 3){
        
        JMNumberInputViewController *textinput = [JMNumberInputViewController new];
        textinput.title = @"电话";
        textinput.playholder = @"输入电话号码...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 4){
        
        JMNumberInputViewController *textinput = [JMNumberInputViewController new];
        textinput.title = @"名片";
        textinput.playholder = @"输入名片...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 5){
        
        JMNumberInputViewController *textinput = [JMNumberInputViewController new];
        textinput.title = @"Wi-Fi";
        textinput.playholder = @"输入Wi-Fi密码...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 6){
        
        JMNumberInputViewController *textinput = [JMNumberInputViewController new];
        textinput.title = @"地址";
        textinput.playholder = @"输入地址...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 7){
        
        JMNumberInputViewController *textinput = [JMNumberInputViewController new];
        textinput.title = @"密码";
        textinput.playholder = @"输入密码...";
        [self.navigationController pushViewController:textinput animated:YES];
        
    }else if (indexPath.row == 8){
        
        
        
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
    return CGSizeMake((kW-8)/3, (kH-8-64)/3);
}

// 动态设置每个分区的EdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2, 2, 2);
}

// 动态设置每行的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

// 动态设置每列的间距大小
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
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

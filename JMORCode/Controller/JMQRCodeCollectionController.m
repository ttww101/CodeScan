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

@interface JMQRCodeCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation JMQRCodeCollectionController

static NSString *const oneRowID = @"threeRow";

- (NSMutableArray *)dataSource
{
    if (!_dataSource) { self.dataSource = [NSMutableArray array];}
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选取二维码类型";
    
    NSArray *aray = @[@{@"title":@"文本", @"image":@"text"}, @{@"title":@"邮箱",@"image":@"email"}, @{@"title":@"网址", @"image":@"website"}, @{@"title":@"通讯录", @"image":@"phone"}, @{@"title":@"名片", @"image":@"WiFi"}, @{@"title":@"WiFi", @"image":@"WiFi"}, @{@"title":@"邮箱", @"image":@"email"}, @{@"title":@"短信", @"image":@"mima"}, @{@"title":@"广告", @"image":@"AD"}];
    
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

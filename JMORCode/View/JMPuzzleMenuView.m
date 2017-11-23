//
//  JMPuzzleMenuView.m
//  Puzzle
//
//  Created by JM Zhao on 2017/9/22.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMPuzzleMenuView.h"
#import "JMMenuItem.h"
#import "JMMenuItemModel.h"

@implementation JMPuzzleMenuView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        NSArray *array = [self creatModels];
        int i = 0;
        for (JMMenuItemModel *model in array) {
        
            JMMenuItem *menu = [[JMMenuItem alloc] init];
            menu.tag = i+200;
            [menu addTarget:self action:@selector(didSelect:) forControlEvents:(UIControlEventTouchUpInside)];
            menu.model = model;
            [self addSubview:menu];
            i ++;
        }
    }
    return self;
}

- (void)didSelect:(UIButton *)sender
{
    if (self.didSelectBlock) {self.didSelectBlock(sender.tag-200);}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int i = 0;
    CGFloat margin = 20;
    CGFloat w = (self.bounds.size.width-margin*4)/3;
    
    for (JMMenuItem *view in self.subviews) {
        CGFloat y = i/3*(w+margin)+margin;
        CGFloat x = i < 9 ? i%3*(w+margin)+margin : (w+margin)+margin;
        view.frame = CGRectMake(x, y, w, w);
        i ++;
    }
}

- (NSArray *)creatModels
{
    NSMutableArray *models = [NSMutableArray array];
    NSArray *dics = @[@{@"title":NSLocalizedString(@"orscan.items.scan", ""), @"image":@"ScanCode"}, @{@"title":NSLocalizedString(@"orscan.items.scanQRCode", ""), @"image":@"QRCode"}, @{@"title":NSLocalizedString(@"orscan.items.creatBarCode", ""), @"image":@"BarCoder"}, @{@"title":NSLocalizedString(@"orscan.items.creatQRCode", ""), @"image":@"QRCode"}, @{@"title":NSLocalizedString(@"orscan.items.creatBarCode", ""), @"image":@"BarCoder"}, @{@"title":NSLocalizedString(@"orscan.items.scanAD", ""), @"image":@"AD"}];
    for (NSDictionary *dic in dics) {
        JMMenuItemModel *model = [JMMenuItemModel new];
        model.title = dic[@"title"];
        model.image = dic[@"image"];
        [models addObject:model];
    }
    return [models copy];
}

@end

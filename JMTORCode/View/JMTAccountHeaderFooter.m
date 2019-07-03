//
//  JMTAccountHeaderFooter.m
//  YaoYao
//
//  Created by JM Zhao on 2017/3/24.
//  Copyright © 2017年 JunMingZhaoPra. All rights reserved.
//

#import "JMTAccountHeaderFooter.h"

@implementation JMTAccountHeaderFooter

+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headID = @"header";
    JMTAccountHeaderFooter *headView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    if (headView == nil) {headView = [[JMTAccountHeaderFooter alloc] initWithReuseIdentifier:headID];;}
    return headView;
}

// 重用headView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UILabel *name = [[UILabel alloc] init];
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = [UIColor grayColor];
        [self.contentView addSubview:name];
        name.textAlignment = NSTextAlignmentLeft;
        self.name = name;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.name.frame = CGRectMake(10, 0, self.bounds.size.width-20, self.bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  JMTextView.h
//  JMORCode
//
//  Created by 赵俊明 on 2017/11/25.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMTextView : UITextView
@property (nonatomic, copy) NSString *content;
@property (nonatomic, weak) UILabel *playholed;
@end

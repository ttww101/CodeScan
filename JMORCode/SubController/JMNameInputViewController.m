//
//  JMNameInputViewController.m
//  JMORCode
//
//  Created by 赵俊明 on 2017/11/25.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMNameInputViewController.h"

@interface JMNameInputViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) UITextField *content;
@property (nonatomic, weak) UITextField *textView;
@end

@implementation JMNameInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *content = [[UITextField alloc] initWithFrame:CGRectMake(0, 74, kW, 40)];
    content.delegate = self;
    content.layer.cornerRadius = 5;
    content.layer.masksToBounds = YES;
    content.clearButtonMode = UITextFieldViewModeWhileEditing;
    content.keyboardType = UIKeyboardTypeNumberPad;
    content.backgroundColor = [UIColor whiteColor];
    content.placeholder = self.playholder;
    [self.view addSubview:content];
    self.content = content;
    
    UITextField *textView = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(content.frame)+10, kW, 40)];
    textView.placeholder = self.playholder;
    textView.delegate = self;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.clearButtonMode = UITextFieldViewModeWhileEditing;
    textView.keyboardType = UIKeyboardTypeNumberPad;
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    [content becomeFirstResponder];
}

- (void)creatExe:(UIBarButtonItem *)item
{
    if (_textView.text.length>0) {
        
        UIImage *image = [self creatQRCodeImage:self.endString];
        UIStoryboard *store = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JMSaveCodeViewController *save = [store instantiateViewControllerWithIdentifier:@"codeView"];
        save.image = image;
        [self.navigationController pushViewController:save animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.endString = [NSString stringWithFormat:@"%@&&%@", _content.text, _textView.text];
    NSLog(@"end-%@", self.endString);
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

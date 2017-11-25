//
//  JMTextInputViewController.m
//  JMORCode
//
//  Created by 赵俊明 on 2017/11/25.
//  Copyright © 2017年 JunMing. All rights reserved.
//

#import "JMTextInputViewController.h"
#import "JMTextView.h"
@interface JMTextInputViewController ()<UITextViewDelegate>
@property (nonatomic, weak) JMTextView *editerView;
@end

@implementation JMTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JMTextView *textView = [[JMTextView alloc] initWithFrame:CGRectMake(0, 84, kW, 200)];
    textView.delegate = (id)self;
    textView.font = [UIFont fontWithName:@"Arial" size:16.5f];
    textView.textColor = JMBaseColor;
    textView.backgroundColor = [UIColor whiteColor];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textView];
    self.editerView = textView;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"生成" style:(UIBarButtonItemStyleDone) target:self action:@selector(creatExe:)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)creatExe:(UIBarButtonItem *)item
{
    if (_editerView.text.length>0) {
        
         [MMScanViewController createQRImageWithString:_editerView.text QRSize:CGSizeMake(250, 150) QRColor:[UIColor blackColor] bkColor:[UIColor colorWithRed:0.318 green:0.690 blue:0.839 alpha:1.00]];
        UIImage *image = [self creatQRCodeImage:_editerView.text];
        UIStoryboard *store = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        JMSaveCodeViewController *save = [store instantiateViewControllerWithIdentifier:@"codeView"];
        save.image = image;
        [self.navigationController pushViewController:save animated:YES];
    }
}

// UITextFieldDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *string = _editerView.text.length>120?[textView.text substringWithRange:NSMakeRange(0, 120)]:_editerView.text;
    NSLog(@"end-%@", string);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    _editerView.content = [NSString stringWithFormat:@"%ld", 119-textView.text.length];
    NSLog(@"should-%@", _editerView.content);
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    return YES;
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

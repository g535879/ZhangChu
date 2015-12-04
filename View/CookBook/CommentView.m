//
//  CommentView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/30.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "CommentView.h"

#define SPACE 10 * scale_screen

@interface CommentView()<UITextFieldDelegate>

@end
@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self viewConfig];
    }
    
    return self;
}

#pragma mark - viewConfig

- (void)viewConfig {
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(SPACE, SPACE, self.bounds.size.width - 90, self.frame.size.height - 20)];
    textField.delegate = self;
    textField.placeholder = @" 说点什么吧...";
    textField.layer.cornerRadius = 5;
    [textField setFont:[UIFont systemFontOfSize:13.0f * scale_screen]];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:textField];
    
    UIButton * cbtn = [MyCustomView createButtonWithFrame:CGRectMake(CGRectGetMaxX(textField.frame) + SPACE, textField.frame.origin.y, 60, textField.frame.size.height) target:self SEL:@selector(commentBtnClick:) backgroundImage:imageStar(@"detail_comment")];
    [cbtn setBackgroundImage:imageStar(@"detail_comment_hl") forState:UIControlStateHighlighted];
    
    [self addSubview:cbtn];
}

#pragma mark - btn click events
- (void)commentBtnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(commentBtnClick:)]) {
        [self.delegate commonClick:btn];
    }
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end

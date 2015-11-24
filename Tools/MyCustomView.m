//
//  MyCustomView.m
//  ZhangChu_BJ
//
//  Created by 古玉彬 on 15/11/23.
//  Copyright © 2015年 ____LHH_____. All rights reserved.
//

#import "MyCustomView.h"

@implementation MyCustomView

+ (UILabel *)createLabelWithFrame:(CGRect)frame textString:(NSString *)text withFont:(float)fontSize textColor:(UIColor *)color {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text =text;
    label.textColor =color;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.numberOfLines = 0;
    return label;
}
@end

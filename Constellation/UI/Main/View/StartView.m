//
//  StartView.m
//  Constellation
//
//  Created by Sj03 on 2018/3/29.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "StartView.h"

@interface StartView ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *startImageView;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
@implementation StartView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([StartView class]) owner:self options:nil];
    [self addSubview:self.view];
}

- (void)getStartNumber:(NSInteger )num {
    [self.startImageView enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (num > idx) {
            obj.image = IMAGE_NAME(@"星级");
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  YMMeIconCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/24.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMMeIconCell.h"

@interface YMMeIconCell ()<UIGestureRecognizerDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewCenterY;

@end

@implementation YMMeIconCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = WhiteColor;
    self.contentView.backgroundColor = WhiteColor;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeUserIconClick:)];
    tap.delegate = self;
    self.iconImgView.userInteractionEnabled = YES;
    [self.iconImgView addGestureRecognizer:tap];
    
    //切一个圆形
    [YMTool viewLayerWithView:_iconImgView cornerRadius:_iconImgView.height/2 boredColor:ClearColor borderWidth:1];
    
     self.height = iPhone5or5cor5sorSE ? 170 : (iPhone6or6sor7 ? 190 : 210);
    
    self.imgViewCenterY.constant = iPhone5or5cor5sorSE ? 7 : (iPhone6or6sor7 ? 9 : 12);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)changeUserIconClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦头像");
    if (self.changeIconBlock) {
        self.changeIconBlock();
    }
}
-(void)setUsrModel:(UserModel *)usrModel{
    _usrModel = usrModel;
    NSDictionary* usrInfoDic = usrModel.userInfo[0];
    //用户 icon
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseApi,usrInfoDic[@"upload_pic"]]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    //_phoneLabel.text = [NSString isEmptyString:usrInfoDic[@"phone"]] ? @"请登陆" : usrInfoDic[@"phone"];
    if ([NSString isEmptyString:usrInfoDic[@"phone"]]) {
        _phoneLabel.text = @"请登陆";
       // [YMTool viewLayerWithView:_phoneLabel cornerRadius:4 boredColor:WhiteColor borderWidth:1];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeUserIconClick:)];
        tap.delegate = self;
        _phoneLabel.userInteractionEnabled = YES;
        [_phoneLabel addGestureRecognizer:tap];
        
    }else{
        _phoneLabel.text = [kUserDefaults valueForKey:kPhone];// usrInfoDic[@"phone"];
    }
 }

@end

//
//  YMLoanTieCell.m
//  Daiba
//
//  Created by YouMeng on 2017/8/22.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMLoanTieCell.h"
#import "PreHeader.h"

@interface YMLoanTieCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tileLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailRight;

//状态按钮右边
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusRight;

@end

@implementation YMLoanTieCell

- (void)awakeFromNib {
    [super awakeFromNib];
      self.backgroundColor = WhiteColor;
     [YMTool viewLayerWithView:self cornerRadius:8 boredColor:WhiteColor borderWidth:1];
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    if (SCREEN_WIDTH == 320) {
        _imgLeft.constant = 10;//20
        _tileLeft.constant = 7;
        _imgTop.constant = 10;
    }
    if (SCREEN_WIDTH == 375) {
        _imgLeft.constant = 12;
        _tileLeft.constant = 10;
        _imgTop.constant = 12;
    }
}

-(void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.size.width -= 30;

    
    [super setFrame:frame];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(instancetype)shareCellWithTableView:(UITableView* )tableView{
    YMLoanTieCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    }
    
    return cell;
}


-(void)cellWithStatus:(NSString* )status indexPath:(NSIndexPath* )indexPath{
    
    if (indexPath.section <= 1) {
        if (indexPath.section == 0) {
             _statusRightMargin.constant = 0;
            NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
            long pastTime = [[kUserDefaults valueForKey:kSetPhoneDate] longValue];
            //不足 5分钟
            if (status.integerValue == 0) {
                if (nowTime - pastTime < 0) {
                    _statusLabel.text = @"认证中";
                }else{
                    _statusLabel.text = @"认证未通过";
                }
            }
        }
        if (status.integerValue == 1) {
            self.statusLabel.text = @"已认证";
           // self.statusLabel.sd_layout.rightSpaceToView(self.contentView, -15);
            _statusRightMargin.constant = 0;
        }else{
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section > 1) {
        _statusLabel.text = @"敬请期待";
    }
    switch (indexPath.section) {
        case 0:
        {
           _descLabel.text = @"80%的授权用户获得了更高的贷款额度";
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
             _descLabel.text = @"70%的授权用户获得了提额特权";
             self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            _descLabel.text = @"完善信息获得更高额度";

        }
            break;
        case 3:
        {
            _descLabel.text = @"完成绑定获得更高额度";

        }
            break;
        case 4:
        {
             _descLabel.text =  @"完成绑定获得更高额度";
            
        }
            break;
        case 5:
        {
           _descLabel.text = @"完成认证获取更高额度";
        }
            break;
        case 6:
        {
            _descLabel.text = @"完成认证获取更高额度";
        }
            break;
        default:
            break;
    }
}

-(void)cellWithCreditModel:(YMCreditModel* )model indexPath:(NSIndexPath* )indexPath{
    if (indexPath.section <= 1) {
        //手机认证
        if (indexPath.section == 0) {
            _statusRightMargin.constant = 0;
            
            NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
            long pastTime = [[kUserDefaults valueForKey:kSetPhoneDate] longValue];
            //不足 5分钟
            if (model.mobile_credit.integerValue == 0) {
                if (nowTime - pastTime < 0) {
                    self.statusLabel.text = @"认证中";
                }else{
                    //未认证
                    self.statusLabel.text = [NSString creditStatusWithStatus:model.mobile_credit];
                    self.statusLabel.textColor = RGB(204, 204, 204);
                }
            }else{
                self.statusLabel.text = [NSString creditStatusWithStatus:model.mobile_credit];
                //已认证
                if (model.mobile_credit.integerValue == 1) {
                    self.statusLabel.textColor = RGB(107, 216, 26);
                    _statusRightMargin.constant = -5;
                //未认证
                }else if (model.mobile_credit.integerValue == 0){
                    self.statusLabel.textColor = RGB(204, 204, 204);
                    self.accessoryType = UITableViewCellAccessoryNone;
                }
                //敬请期待
                else if (model.mobile_credit.integerValue == 4){
                    self.statusLabel.textColor = RGB(246, 71, 71);
                }
            }
        //芝麻信用
        }if (indexPath.section == 1) {
            self.statusLabel.text = [NSString creditStatusWithStatus:model.zmxy];
            // 已认证
            if (model.zmxy.integerValue == 1) {
               self.statusLabel.textColor = RGB(107, 216, 26);
                _statusRightMargin.constant = -5;
            //未认证
            }else if (model.zmxy.integerValue == 0){
                self.statusLabel.textColor = RGB(204, 204, 204);
                self.accessoryType = UITableViewCellAccessoryNone;
            }
            //敬请期待
            else if (model.zmxy.integerValue == 4){
                self.statusLabel.textColor = RGB(246, 71, 71);
            }
        }
        
    }
    if (indexPath.section > 1) {
        
        _detailImgView.hidden = YES;
        _detailRight.constant = 0;
        _statusRight.constant = -2;
        _statusLabel.text = @"敬请期待";
       
    }
    switch (indexPath.section) {
        case 0:
        {
            _descLabel.text = @"完善信息可获得特权";

        }
            break;
        case 1:
        {
            _descLabel.text = @"认证成功可快速放贷";
//            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 2:
        {
            _descLabel.text = @"完善信息获得更高额度";
            // _statusLabel.text = [NSString creditStatusWithStatus:model.xxrz ];
            
        }
            break;
        case 3:
        {
          //   _statusLabel.text = [NSString creditStatusWithStatus:model.sbzh ];
            _descLabel.text = @"完成绑定获得更高额度";
            
        }
            break;
        case 4:
        {
          //   _statusLabel.text = [NSString creditStatusWithStatus:model.gjj ];
            _descLabel.text =  @"完成绑定获得更高额度";
            
        }
            break;
        case 5:
        {
          //  _statusLabel.text = [NSString creditStatusWithStatus:model.tb];
            _descLabel.text = @"完成认证获取更高额度";
        }
            break;
        case 6:
        {
         //   _statusLabel.text = [NSString creditStatusWithStatus:model.jd];
            _descLabel.text = @"完成认证获取更高额度";
        }
            break;
        default:
            break;
    }
}

@end

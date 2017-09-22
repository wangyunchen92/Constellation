//
//  YMHeightTools.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMHeightTools.h"

@implementation YMHeightTools

//单独计算图片的高度
+ (CGFloat)heightForImage:(UIImage *)image width:(CGFloat)kPhotoCell_Width
{
    //(2)获取图片的大小
    CGSize size = image.size;
    //(3)求出缩放比例
    CGFloat scale = kPhotoCell_Width / size.width;
    CGFloat imageHeight = size.height * scale;
    return imageHeight;
}
//单独计算文本的高度
+ (CGFloat)heightForText:(NSString *)text  fontSize:(CGFloat)kFontSize  width:(CGFloat)kPhotoCell_Width
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:kFontSize]};
    return [text boundingRectWithSize:CGSizeMake(kPhotoCell_Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

//获取文字的宽度
+(CGFloat)widthForText:(NSString* )text fontSize:(CGFloat)fontSize{
    
    return [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}].width;
    
}

+ (CGFloat)getImgWidthByImgsArr:(NSArray* )imgsArr spaceX:(CGFloat)spaceX margin:(CGFloat)margin  rightMarin:(CGFloat)rightMargin{
    if (imgsArr.count == 0) {
        return 0;
    }
    //1 行
    if (imgsArr.count == 1) {
        return  SCREEN_WIDTH * 0.4;
    }else if (imgsArr.count == 2){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin)/2;
    } // 1 行
    else if (imgsArr.count == 3 ){  // 1 行
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }// 2 行
    else if (imgsArr.count == 4 ){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2) / 2.2;
    } // 2 行
    else if (imgsArr.count == 5 || imgsArr.count == 6){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }// 3 行
    else if (imgsArr.count >= 7 && imgsArr.count <= 9){
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }else{
        return (SCREEN_WIDTH - spaceX - rightMargin - margin * 2)/3;
    }
}

+ (CGFloat)getHeighByImgsArr:(NSArray* )imgsArr spaceX:(CGFloat)spaceX margin:(CGFloat)margin rightMarin:(CGFloat)rightMargin{
    CGFloat imgWidth = [self getImgWidthByImgsArr:imgsArr spaceX:spaceX margin:margin rightMarin:rightMargin];
    //1 行
    if (imgsArr.count == 1) {
        return  imgWidth;
    }else if (imgsArr.count == 2){
        return imgWidth;
    } // 1 行
    else if (imgsArr.count == 3 ){  // 1 行
        return imgWidth;
    }// 2 行
    else if (imgsArr.count == 4 ){
        return imgWidth * 2 + margin;
    } // 2 行
    else if (imgsArr.count == 5 || imgsArr.count == 6){
        return imgWidth * 2 + margin;
    }// 3 行
    else if (imgsArr.count >= 7 && imgsArr.count <= 9){
        return imgWidth * 3 + margin * 2;
    }else{
        return imgWidth * 3 + margin * 2;
    }
}

+ (CGFloat)getCellHeightWithUsrModel:(UserModel* )usrModel indexpath:(NSIndexPath* )indexPath{
    
    if (indexPath.section == 0) {
        //立即开户 -- 审核开户
        if (usrModel.postion.integerValue == 66) {
            CGFloat textHeigh = [YMHeightTools heightForText:@"您的材料成功提交，已进入快速审核通道。贷吧承诺确保您的信息安全，您提交的资料仅作本次贷款申请使用，不会提供给任何第三方机构。审核期间，请确保手机通畅，并注意接听客服电话，一经审核通过，我们将在第一时间通知您，请保持手机开机" fontSize:14 width:SCREEN_WIDTH - 15 * 2];
            
            return textHeigh + 118 + (30 + 35 + 10) + 20;
        }
        if (usrModel.postion.integerValue == 77) {
            CGFloat textHeigh = [YMHeightTools heightForText:@"您的开户资料审核失败，第X步信息有误，请重新提交正确开户信息。" fontSize:14 width:SCREEN_WIDTH - 15 * 2];
            
            return textHeigh + 118 + (30 + 35 + 10) + 20;
        }
        if (usrModel.postion.integerValue == 99){
            // 0 1 2 3  5  -1 立即借款  还款失败
            if (usrModel.status.integerValue == 0 ||
                usrModel.status.integerValue == 1 ||
                (usrModel.status.integerValue == 2 && [kUserDefaults boolForKey:kisSuccessLoan] == NO)||
              usrModel.status.integerValue == 3 ||
              usrModel.status.integerValue == 5 ||
                (usrModel.status.integerValue == 7 && [kUserDefaults boolForKey:kisFailureBackLoan] == NO)) {
                //|| self.usrModel.status.integerValue == 6
                return 141;
            }
            //待借款
            if (usrModel.status.integerValue == -1) {
                return 432;
            }
            //立即还款。
            if (usrModel.status.integerValue == 4 ||
                (usrModel.status.integerValue == 2 && [kUserDefaults boolForKey:kisSuccessLoan]) ||
                (usrModel.postion.integerValue == 99  && usrModel.status.integerValue == 7 && [kUserDefaults boolForKey:kisFailureBackLoan] )) {//|| self.usrModel.status.integerValue == 6
                
                CGFloat cardTipsHeight = [YMHeightTools heightForText:@"请将应还金额存入您的招商银行(3776)，然后点击“立即还款”" fontSize:14 width:SCREEN_WIDTH - 15 * 2];
                CGFloat tipsHeight  = [YMHeightTools heightForText:@"友情提示：贷款用户需在到期还款日前还款，逾期不还将依法报送人民银行征信系统未来可能会对您找工作，办理签证，车贷，房贷造成影响。" fontSize:14 width:SCREEN_WIDTH - 15 * 2];
                
                return 242 + cardTipsHeight + (13 + 35 + 15) + tipsHeight + 15 ;
            }
        }
        //只有一档 默认 断网
        if (usrModel.date_select.count == 1 || usrModel.max_money <= 0 ) {
            return 300;
        }
        //默认 立即开户 -- 未登陆
        // 0 1 2 3  5  -1 立即借款
        return  432;
    }
    if (indexPath.section == 1) {
        if (usrModel.postion.integerValue == 99) {
            CGFloat textHeigh = [YMHeightTools heightForText:@"友情提示：贷款用户需在到期还款日前还款，逾期不还将依法报送人民银行征信系统未来可能会对您找工作，办理签证，车贷，房贷造成影响。" fontSize:14 width:SCREEN_WIDTH - 15 * 2];
            return 256 + 30 + textHeigh + 20 + 40;
        }
        //还款失败
        if (usrModel.status.integerValue == 7) {
            CGFloat cardTipsHeight = [YMHeightTools heightForText:@" 1.请确认您当前绑定的中国农业银行（尾号0370）卡内余额是否大于100.18元; \n2.卡内余额充足，仍无法还款成功，建议您查看“如何还款成功”。" fontSize:12 width:SCREEN_WIDTH - 15 * 2];
            
            return 80 + cardTipsHeight + 30 + 44 + 30;
        }
    }
    return 0;
}
@end

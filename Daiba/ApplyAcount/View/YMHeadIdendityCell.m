//
//  YMHeadIdendityCell.m
//  Daiba
//
//  Created by YouMeng on 2017/7/27.
//  Copyright © 2017年 YouMeng. All rights reserved.


#import "YMHeadIdendityCell.h"
#import "XCFileManager.h"

@interface YMHeadIdendityCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgTagView;
@property (weak, nonatomic) IBOutlet UILabel *imgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vedioImgView;
@property (weak, nonatomic) IBOutlet UIImageView *vedioTagView;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifybtn;
@end

@implementation YMHeadIdendityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [YMTool viewLayerWithView:_modifybtn cornerRadius:4 boredColor:DefaultNavBarColor borderWidth:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(instancetype)shareCellWithModifyBlock:(void (^)(UIButton* btn))modifyBlock{
    YMHeadIdendityCell* cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
    cell.modifyBlock = modifyBlock;
    
    return cell;
}

- (IBAction)modifyBtnClick:(id)sender {
    if (self.modifyBlock) {
        self.modifyBlock(sender);
    }
}

-(void)setPhotoModel:(PhotoModel *)photoModel{
    _photoModel = photoModel;
    
    if (![NSString isEmptyString:photoModel.photo]) {
        _imgTagView.hidden = NO;
        _imgTagView.image = [UIImage imageNamed:@"认证"];
        _imgLabel.text = @"实时头像已提交";
        
        _vedioTagView.hidden = NO;
        _imgTagView.image = [UIImage imageNamed:@"认证"];
        _videoLabel.text = @"影像资料已提交";
        
#warning todo - 缓存中的图片 和 视频
        [_modifybtn setTitle:@"修改" forState:UIControlStateNormal];
        UIImage* img = [XCFileManager getLocalFileWithFilePath:headImgFilePath fileKey:kHeadImage];
        if (img) {
            _imgImgView.image = img;
        }else{
            _imgImgView.image = [UIImage imageNamed:@"添加用户"];
        }
        //读取视频封面
        UIImage* videoImg = [XCFileManager getLocalFileWithFilePath:videoImgFilePath fileKey:kVideoPreImage];
        if (videoImg) {
            _vedioImgView.image = videoImg;
        }else{
            _vedioImgView.image = [UIImage imageNamed:@"添加视频"];
        }
        
    }else{
        _imgTagView.hidden = YES;
        _imgLabel.text = @"实时头像待上传";
        
        _vedioTagView.hidden = YES;
        _videoLabel.text = @"影像资料待上传";
        
        [_modifybtn setTitle:@"填写" forState:UIControlStateNormal];
    }
    
    _imgImgView.clipsToBounds = YES;
    _vedioImgView.clipsToBounds = YES;
    
}

@end

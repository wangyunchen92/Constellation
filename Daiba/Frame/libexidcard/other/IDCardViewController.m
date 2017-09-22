
#import "IDCardViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "IdCardInfo.h"
#import <Masonry/Masonry.h>


#define kSACardWidthRatio     SCREEN_WIDTH / 375.0f

#define kSACardHeightRatio    SCREEN_HEGIHT / 667.0f

@interface IDCardViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *repeatTakeButton;

@property (nonatomic, strong) UIImageView *positiveTagImageView;

@property (nonatomic, strong) UIImageView *inverseTagImageView;


@property (nonatomic, strong) UIImageView *pickImageView;

@property (nonatomic, strong) NSString *cancelButtonTitle;

//采集的图片
@property (nonatomic, strong) UIImage *pickImage;

@property (nonatomic, assign) BOOL isFirst;

//采集到的照片添加到数组
@property(nonatomic,strong)NSMutableArray* idImgsArr;
@property(nonatomic,strong)NSMutableDictionary* idImgsDic;

@end

@implementation IDCardViewController

static Boolean init_flag = false;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirst = YES;
    }
    return self;
}
-(NSMutableArray *)idImgsArr{
    if (!_idImgsArr) {
        _idImgsArr = [[NSMutableArray alloc]init];
    }
    return _idImgsArr;
}
-(NSMutableDictionary *)idImgsDic{
    if (!_idImgsDic) {
        _idImgsDic = [[NSMutableDictionary alloc]init];
    }
    return _idImgsDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!init_flag)
    {
        const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
        int ret = EXCARDS_Init(thePath);
        if (ret != 0)
        {
            NSLog(@"Init Failed!ret=[%d]", ret);
        }
        
        init_flag = true;
    }
    
    [self setupSunviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isPositive) {
        self.positiveTagImageView.hidden = NO;
    }else {
        self.inverseTagImageView.hidden = NO;
    }
    [self initCapture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_buffer != NULL)
    {
        free(_buffer);
        _buffer = NULL;
    }
}

#pragma mark - Capture

- (void)initCapture
{
    // init capture manager
    _capture = [[CardCapture alloc] init];
    
    _capture.delegate = self;
    _capture.verify = self.verify;
    
    _capture.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    _capture.outputSetting = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];

    [_capture addVideoInput:AVCaptureDevicePositionBack];
    
    [_capture addVideoOutput];
    [_capture addVideoPreviewLayer];
    
    CGRect layerRect =  [UIScreen mainScreen].bounds;//self.view.bounds;
    [[_capture previewLayer] setOpaque: 0];
    [[_capture previewLayer] setBounds:layerRect];
    [[_capture previewLayer] setPosition:CGPointMake( CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
    
    [self.cameraView.layer addSublayer:_capture.previewLayer];
    [self.view sendSubviewToBack:self.cameraView];
    
    // start !
    [self performSelectorInBackground:@selector(startCapture) withObject:nil];
}

- (void)removeCapture
{
    [_capture.captureSession stopRunning];
    [_cameraView removeFromSuperview];
    _capture     = nil;
    _cameraView  = nil;
}

- (void)startCapture
{
    //@autoreleasepool
    {
        [[_capture captureSession] startRunning];
    }
}

#pragma mark -  采集到可识别的照片 ---  Capture Delegate
- (void)idCardRecognited:(IdCardInfo *)idInfo
{
   // dispatch_async(dispatch_get_main_queue(), ^(void) {
        self.pickImage = self.capture.stillImage;
    NSLog(@"pick == %@",self.pickImage);
        //正面
        if (idInfo.type == 1) {
            NSLog(@"\n姓名：%@\n性别：%@\n民族：%@\n身份证号：%@\n地址：%@", idInfo.name, idInfo.gender, idInfo.nation, idInfo.code, idInfo.address);
           
        }// 反面
        else if (idInfo.type == 2) {
            NSLog(@"\n签发机关：%@\n有效日期：%@", idInfo.issue, idInfo.valid);
//            [self.idImgsDic setObject:self.pickImage forKey:@"inverse"];
//            [self.idImgsArr addObject:self.idImgsDic];
        }
  //  });
    [_capture.captureSession stopRunning];
}

#pragma mark -
#pragma mark - event meyhod

- (void)takePhotoButtonAction {
    
}
//取消按钮 3 种状态  取消 -- 下一步 -- 完成
- (void)cancelAction:(UIButton *)cancelButton {
    if ([self.cancelButton.titleLabel.text isEqualToString:NSLocalizedString(@"下一步", nil)]) {
        self.isFirst = NO;
        if (self.isPositive) {
            self.positiveImage = self.pickImage;
        }else {
            self.inverseImage = self.pickImage;
        }
        [self repeatTakeButtonAction:nil];
    }else {
        if ([self.cancelButton.titleLabel.text isEqualToString:NSLocalizedString(@"完成", nil)]) {
            if (self.isPositive) {
                if (self.isFirst) {
                    self.positiveImage = self.pickImage;
                }else {
                    self.inverseImage = self.pickImage;
                }
            }else {
                if (self.isFirst) {
                    self.inverseImage = self.pickImage;
                }else {
                    self.positiveImage = self.pickImage;
                }
            }
        }
        
        if ([self.finishDelegate respondsToSelector:@selector(finishPickerImageWithPositiveImage:inverseImage:)]) {
            [self.finishDelegate finishPickerImageWithPositiveImage:self.positiveImage inverseImage:self.inverseImage];
        }
        [self removeCapture];
        [self dismissViewControllerAnimated:YES completion:nil];
        if(init_flag){
            EXCARDS_Done();
            init_flag = false;
        }
    }
}

- (void)repeatTakeButtonAction:(UIButton *)repeatButton {
    self.pickImageView.hidden = YES;
    self.repeatTakeButton.hidden = YES;
    self.cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSLog(@"移除前 imgsArr == %@",self.idImgsArr);
    if (self.isPositive) {
        if (self.isFirst) {
            self.positiveTagImageView.hidden = NO;
            self.inverseTagImageView.hidden = YES;
            //移除刚才保存的照片
            [self.idImgsDic removeObjectForKey:@"positive"];
            [self.idImgsArr removeLastObject];
        }else {
            self.positiveTagImageView.hidden = YES;
            self.inverseTagImageView.hidden = NO;
            
            [self.idImgsDic removeObjectForKey:@"inverse"];
            [self.idImgsArr removeLastObject];
        }
    }else {
        if (self.isFirst) {
            self.positiveTagImageView.hidden = YES;
            self.inverseTagImageView.hidden = NO;
            
            [self.idImgsDic removeObjectForKey:@"inverse"];
            [self.idImgsArr removeLastObject];

        }else {
            self.positiveTagImageView.hidden = NO;
            self.inverseTagImageView.hidden = YES;
            
            //移除刚才保存的照片
            [self.idImgsDic removeObjectForKey:@"positive"];
            [self.idImgsArr removeLastObject];

        }
    }
     NSLog(@"移除后 imgsArr == %@",self.idImgsArr);
    [_capture.captureSession startRunning];
}

#pragma mark -
#pragma mark - Setter && Getter
- (UIView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[UIView alloc] init];
    }
    return _cameraView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _cancelButton;
}

- (UIButton *)repeatTakeButton {
    if (!_repeatTakeButton) {
        _repeatTakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _repeatTakeButton.backgroundColor = [UIColor clearColor];
        [_repeatTakeButton addTarget:self action:@selector(repeatTakeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_repeatTakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_repeatTakeButton setTitle:NSLocalizedString(@"重拍", nil) forState:UIControlStateNormal];
        _repeatTakeButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _repeatTakeButton.hidden = YES;
    }
    return _repeatTakeButton;
}

- (UIImageView *)inverseTagImageView {
    if (!_inverseTagImageView) {
        _inverseTagImageView = [[UIImageView alloc] init];
        _inverseTagImageView.backgroundColor = [UIColor clearColor];
        _inverseTagImageView.image = [UIImage imageNamed:@"icon_img_2"];
        _inverseTagImageView.hidden = YES;
    }
    return _inverseTagImageView;
}
//正面的头像
- (UIImageView *)positiveTagImageView {
    if (!_positiveTagImageView) {
        _positiveTagImageView = [[UIImageView alloc] init];
        _positiveTagImageView.backgroundColor = [UIColor clearColor];
        _positiveTagImageView.image = [UIImage imageNamed:@"icon_img"];
        _positiveTagImageView.hidden = YES;
    }
    return _positiveTagImageView;
}

- (UIImageView *)pickImageView {
    if (!_pickImageView) {
        _pickImageView = [[UIImageView alloc] init];
        _pickImageView.backgroundColor = [UIColor blackColor];
        _pickImageView.hidden = YES;
        _pickImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _pickImageView;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = cancelButtonTitle;
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    if ([cancelButtonTitle isEqualToString:NSLocalizedString(@"取消", nil)]) {
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([cancelButtonTitle isEqualToString:NSLocalizedString(@"完成", nil)]) {
        [self.cancelButton setTitleColor:RGB(0, 148, 246) forState:UIControlStateNormal];
    }else if ([cancelButtonTitle isEqualToString:NSLocalizedString(@"下一步", nil)]) {
        [self.cancelButton setTitleColor:RGB(0, 148, 246) forState:UIControlStateNormal];
    }
}

- (void)setPickImage:(UIImage *)pickImage {
    _pickImage = pickImage;
    
    self.pickImageView.hidden = YES;
    self.pickImageView.image = pickImage;
    self.repeatTakeButton.hidden = NO;
    if (!self.isFirst) {
        self.cancelButtonTitle = NSLocalizedString(@"完成", nil);
    }else {
        if (self.isPositive) {
            if (!self.inverseImage) {
                self.cancelButtonTitle = NSLocalizedString(@"下一步", nil);
                
                [self.idImgsDic setObject:self.pickImage forKey:@"positive"];
                [self.idImgsArr addObject:self.idImgsDic];
            }else {
                
                [self.idImgsDic setObject:self.pickImage forKey:@"inverse"];
                [self.idImgsArr addObject:self.idImgsDic];
                self.cancelButtonTitle = NSLocalizedString(@"完成", nil);
            }
        }else {
            if (!self.positiveImage) {
                [self.idImgsDic setObject:self.pickImage forKey:@"inverse"];
                [self.idImgsArr addObject:self.idImgsDic];
                self.cancelButtonTitle = NSLocalizedString(@"下一步", nil);
            }else {
                [self.idImgsDic setObject:self.pickImage forKey:@"positive"];
                [self.idImgsArr addObject:self.idImgsDic];
                self.cancelButtonTitle = NSLocalizedString(@"完成", nil);
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private Method
- (void)setupSunviews {
    [self.view addSubview:self.cameraView];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.repeatTakeButton];
    [self.view addSubview:self.inverseTagImageView];
    [self.view addSubview:self.positiveTagImageView];
    [self.view addSubview:self.pickImageView];
    
    self.cancelButton.transform = CGAffineTransformRotate(self.cancelButton.transform, M_PI_2);
    self.repeatTakeButton.transform = CGAffineTransformRotate(self.repeatTakeButton.transform, M_PI_2);
    
    [self setupSubviewsConstraints];
}

- (void)setupSubviewsConstraints {
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(44);
        make.bottom.mas_equalTo(-300 * kSACardHeightRatio);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-10 * kSACardWidthRatio);
        make.bottom.mas_equalTo(self.view).offset(-30 * kSACardHeightRatio);
        
    }];
    [self.repeatTakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10 * kSACardWidthRatio);
        make.bottom.mas_equalTo(self.view).offset(-30 * kSACardHeightRatio);
    }];
    [self.inverseTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-70 * kSACardWidthRatio);
        make.top.mas_equalTo(self.view).offset((40 + 70) * kSACardHeightRatio);
        make.width.mas_equalTo(80 * kSACardWidthRatio);
        make.height.mas_equalTo(75 * kSACardWidthRatio);
    }];
    [self.positiveTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-100 * kSACardHeightRatio);// -164
        make.width.height.mas_equalTo(140 * kSACardHeightRatio);
    }];
    [self.pickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-80 * kSACardHeightRatio);
        make.left.right.mas_equalTo(self.view);
    }];
}

@end

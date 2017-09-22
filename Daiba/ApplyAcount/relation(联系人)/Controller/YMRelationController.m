//
//  YMRelationController.m
//  Daiba
//
//  Created by YouMeng on 2017/7/29.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMRelationController.h"
#import "RelationCell.h"
#import "YMWarnView.h"

//通讯录相关
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "NVMContactManager.h"
//ios9以后要用下面两个库代理上面两个
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

#import "YMVideoInfoController.h"
#import "YMApplyMainController.h"

#import "YMWebViewController.h"

@interface YMRelationController ()<UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *warnView;

//
@property(nonatomic,strong)NSMutableArray* titlesArr;

//上传 btn
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

//地址簿导航栏
@property (nonatomic,strong)ABPeoplePickerNavigationController *picker;
//保存电话和姓名
@property(nonatomic,strong)UITextField* telTextFd;
@property(nonatomic,strong)UITextField* nameTextFd;

//家人同事朋友
@property(nonatomic,strong)RelationCell* homeCell;

@property(nonatomic,strong)RelationCell* friendCell;

@property(nonatomic,strong)RelationCell* workmateCell;

//通讯录数组
@property(nonatomic,strong)NSArray* peoplesArr;
@property(nonatomic,assign)BOOL isOpenContact;
@end

@implementation YMRelationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改view
    [self modifyView];
    
    if (self.isShowNext == YES) {
        self.navigationItem.rightBarButtonItem =  [UIBarButtonItem itemWithTitle:@"第5/6步" font:Font(13) titleColor:WhiteColor target:self action:@selector(next:)];
    }
}

-(void)next:(UIButton*)nextBtn{
    YMVideoInfoController* yvc = [[YMVideoInfoController alloc]init];
    yvc.title = @"影像资料";
    yvc.isShowNext  = YES;
    [self.navigationController pushViewController:yvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSMutableArray *)titlesArr{
    if (!_titlesArr) {
        _titlesArr = @[@"家人",@"朋友",@"同事"].mutableCopy;
    }
    return _titlesArr;
}
-(void)back{
    YMWeakSelf;
    [YMTool presentAlertViewWithTitle:@"温馨提示" message:@"资料尚未完整，确认放弃填写？" cancelTitle:@"返回" cancelHandle:^(UIAlertAction *action) {
        
        YMApplyMainController* yvc = [[YMApplyMainController alloc]init];
        yvc.title = @"提交资料，立即申请开户";
        [weakSelf.navigationController pushViewController:yvc animated:YES];
        
    } sureTitle:@"继续填写" sureHandle:^(UIAlertAction * _Nullable action) {
        
    } controller:self];
}
#pragma mark - UI
   
-(void)modifyView
{
    //返回到信息主页
    if (self.isShowNext == YES) {
        self.navigationItem.leftBarButtonItem =  [UIBarButtonItem backItemWithImageNamed:@"back" title:nil target:self action:@selector(back)];
    }

    [YMTool viewLayerWithView:_updateBtn cornerRadius:4 boredColor:DefaultNavBarColor borderWidth:1];
    YMWarnView* warnView = [YMWarnView shareViewWithIconStr:@"感叹" warnStr:@"请添加三位联系人，并修改联系人姓名为真实姓名" tapBlock:^(UILabel *label) {
        DDLog(@"点击啦联系人头部") ;
    }];
    [self.warnView addSubview:warnView];
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMWeakSelf;
    RelationCell * cell = [RelationCell shareCellWithTitle:self.titlesArr[indexPath.row] modifyBlock:^(UIButton *btn) {
        RelationCell* reCell = (RelationCell*)btn.superview.superview;
        weakSelf.telTextFd = reCell.numTextFd;
        weakSelf.nameTextFd = reCell.nameTextFd;
        [weakSelf addressBtnClick:btn];
        NSLog(@"btn title == %@",btn.titleLabel.text);
    }];
    if (indexPath.row == 0) {
        self.homeCell = cell;
        self.homeCell.nameTextFd.text = self.addresBookModel.family_name;
        self.homeCell.numTextFd.text = self.addresBookModel.family_phone;

    }
    if (indexPath.row == 1) {
        self.friendCell = cell;
        self.friendCell.nameTextFd.text = self.addresBookModel.friend_name;
        self.friendCell.numTextFd.text = self.addresBookModel.friend_phone;

    }
    if (indexPath.row == 2) {
        self.workmateCell = cell;
        self.workmateCell.nameTextFd.text = self.addresBookModel.colleague_name;
        self.workmateCell.numTextFd.text = self.addresBookModel.colleague_phone;

        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0);
    }
    
    if (![NSString isEmptyString: cell.numTextFd.text]) {
        [cell.modifyBtn setTitle:@" 修改 " forState:UIControlStateNormal];
    }else{
        [cell.modifyBtn setTitle:@" 选择 " forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark - 调用=通讯录
- (void)addressBtnClick:(UIButton* )btn{
    //if(!self.picker){
    self.picker = [[ABPeoplePickerNavigationController alloc] init];
    self.picker.peoplePickerDelegate = self;
    //}
    ABAddressBookRef abr = [self.picker addressBook];
    if (&ABAddressBookRequestAccessWithCompletion != NULL) {
        //检查是否是iOS6
        //开启通讯录权限声明
        //  ABAddressBookRef abr = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            //如果该应用从未申请过权限，申请权限
            ABAddressBookRequestAccessWithCompletion(abr, ^(bool granted, CFErrorRef error) {
                //根据granted参数判断用户是否同意授予权限
                if (granted) {
                    //查询所有，这里我们可以用来进行下一步操作
                    DDLog(@"第一次开启授权");
                    //设置字体颜色
                    [[UINavigationBar appearance]setTintColor:BlueBtnColor ];
                    [self presentViewController:self.picker animated:YES completion:^{
                        //设置导航栏按钮的颜色
                        [[UINavigationBar appearance]setTintColor:DefaultNavBarColor];
                    }];
                }
            });
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            //查询所有，这里我们可以用来进行下一步操作
            DDLog(@"已经开启授权");
            self.isOpenContact = YES;
            self.peoplesArr = [NVMContactManager manager].allPeople;
            
            [[UINavigationBar appearance]setTintColor:BlueBtnColor];
            [self presentViewController:self.picker animated:YES completion:^{
                //设置导航栏按钮的颜色
                [[UINavigationBar appearance]setTintColor:DefaultNavBarColor];
            }];
            //查询所有，这里我们可以用来进行下一步操作
        } else {
            
            //如果权限被收回，只能提醒用户去系统设置菜单中打开
            UIAlertView* alertV = [[UIAlertView alloc]initWithTitle:@"通讯录权限" message:@"您的通讯录权限没有打开，请在设置中开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertV show];
        }
        //释放abr 对象
        if(abr){
            CFRelease(abr);
        }
    }

}

// 开启通讯录 权限
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        DDLog(@"开启通讯录权限");
        // 跳转到设置界面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            // url地址可以打开
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma mark - 通讯录delegate
//此方法点击联系人之后会将联系人的名字和手机号码返回 如果没有这个方法的话 那么当点击联系人的时候会拨打电话
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
  
    ABMultiValueRef values = ABRecordCopyValue(person, property);
    
    DDLog(@"values == %@ person == %@",values,person);
    if(values != NULL)  //需要判断空值 否则可能会崩溃
    {
        //个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName !=nil) {
            nameString = (__bridge NSString *)abFullName;
        }else{
            if ((__bridge id)abLastName != nil) {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        
       //电话号码
         ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
         DDLog(@"values == %@ nameString == %@",values,nameString);
        CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
        //电话号码
        CFStringRef telValue = ABMultiValueCopyValueAtIndex(valuesRef,index);
        
        [self.picker dismissViewControllerAnimated:YES completion:^{
            
            self.telTextFd.text = (__bridge NSString * _Nullable)(telValue);
            self.nameTextFd.text = nameString;

            RelationCell* reCell = (RelationCell*)self.telTextFd.superview.superview;
              
            if (![NSString isEmptyString: reCell.numTextFd.text]) {
                [reCell.modifyBtn setTitle:@" 修改 " forState:UIControlStateNormal];
            }else{
                [reCell.modifyBtn setTitle:@" 选择 " forState:UIControlStateNormal];
            }
        }];
        CFRelease(values);
    }
}


#pragma mark - 上传身份证信息
- (IBAction)uploadBtnClick:(id)sender {
    DDLog(@"点击提交");
    if ([NSString isEmptyString:self.homeCell.numTextFd.text] ) {
        [MBProgressHUD showFail:@"请填写家人的联系方式！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:self.friendCell.numTextFd.text] ) {
        [MBProgressHUD showFail:@"请填写朋友的联系方式！" view:self.view];
        return;
    }
    if ([NSString isEmptyString:self.workmateCell.numTextFd.text] ) {
        [MBProgressHUD showFail:@"请填写同事的联系方式！" view:self.view];
        return;
    }
    if ([self.friendCell.numTextFd.text isEqualToString:self.homeCell.numTextFd.text] ||
        [self.friendCell.numTextFd.text isEqualToString:self.workmateCell.numTextFd.text] ||
        [self.homeCell.numTextFd.text isEqualToString:self.workmateCell.numTextFd.text]) {
        [MBProgressHUD showFail:@"紧急联系人不可重复，请修改重复的联系人！" view:self.view];
        return;
    }

    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    [param setObject:@"4" forKey:@"postion"];
    [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
    [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    //参数
    [param setObject:self.homeCell.nameTextFd.text forKey:@"family_name"];
    [param setObject:[NSString deleteStrWithOrignalStr:self.homeCell.numTextFd.text specailStr:@"-"]  forKey:@"family_phone"];
    [param setObject:self.friendCell.nameTextFd.text forKey:@"friend_name"];
    [param setObject:[NSString deleteStrWithOrignalStr:self.friendCell.numTextFd.text specailStr:@"-"]  forKey:@"friend_phone"];
    [param setObject:self.workmateCell.nameTextFd.text forKey:@"colleague_name"];
    [param setObject:[NSString deleteStrWithOrignalStr:self.workmateCell.numTextFd.text specailStr:@"-"]  forKey:@"colleague_phone"];
    
    YMWeakSelf;
    [[HttpManger sharedInstance]callHTTPReqAPI:accountApplyURL params:param view:self.view loading:YES tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        if (self.isOpenContact == YES) {
            //没有通讯录不传
            if (self.peoplesArr.count > 0 ) {
                //上传通讯录
                [self  updateContacts];
            }
        }
        
        if (self.isShowNext == YES) {
            if (self.isModify == NO) {
                [MBProgressHUD showSuccess:@"上传成功！" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    DDLog(@"手机认证");
                    YMWebViewController* wvc = [[YMWebViewController alloc]init];
                    wvc.urlStr = getMobileURL;
                    wvc.hidesBottomBarWhenPushed = YES;
                    wvc.isSecret = YES;
                    wvc.title = @"手机认证";
                    wvc.isNext = YES;
                    [self.navigationController pushViewController:wvc animated:YES];
                });
            }else{
                YMApplyMainController* yvc = [[YMApplyMainController alloc]init];
                yvc.title = @"提交资料，立即申请开户";
                [weakSelf.navigationController pushViewController:yvc animated:YES];

            }
        }
        if (weakSelf.isShowNext == NO) {
            [MBProgressHUD showSuccess:@"上传成功，请等待审核！" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
                //回跳
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

//上传通讯录到服务器
-(void)updateContacts{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    NSMutableString* phone_list = [[NSMutableString alloc]initWithString:@"["];
   
    for (int i = 0 ; i < self.peoplesArr.count ; i ++) {
        NVMContact* contact = self.peoplesArr[i];
        phone_list = [phone_list stringByAppendingString:[NSString stringWithFormat:@"{\"contacts\":\"%@\",\"phone\":\"%@\"},",contact.fullName,contact.fullPhoneNumbers]].mutableCopy;
    }
    if (self.peoplesArr.count > 0) {
         [phone_list deleteCharactersInRange:NSMakeRange(phone_list.length - 1, 1)];
    }
   //phone_list = [phone_list stringByDeletingLastPathComponent].mutableCopy;
    phone_list = [phone_list stringByAppendingString:@"]"].mutableCopy;
    DDLog(@"phone_list == %@",phone_list);
     [param setObject:phone_list forKey:@"phone_list"];
     [param setObject:[kUserDefaults valueForKey:kUid] forKey:@"uid"];
     [param setObject:[kUserDefaults valueForKey:kToken] forKey:@"token"];
    
    [[HttpManger sharedInstance]callHTTPReqAPI:updatePhoneURL params:param view:self.view loading:NO tableView:nil completionHandler:^(id task, id responseObject, NSError *error) {
        
        DDLog(@"上传成功");
    }];
    
}

@end

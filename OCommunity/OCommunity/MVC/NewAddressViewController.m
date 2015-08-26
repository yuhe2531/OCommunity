//
//  NewAddressViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/5/4.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "NewAddressViewController.h"
#import "newAddressView.h"
#import "Toast+UIView.h"

@interface NewAddressViewController ()
{
    newAddressView *textF0;
    newAddressView *textF1;
    newAddressView *textF2;
    newAddressView *textF3;
}
@end

@implementation NewAddressViewController

#define kBottomView_height 80
#define kSaveBtn_left 30
#define kSaveBtn_height 35

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *title = !_addressModel ? @"新建收货地址" : @"修改收货地址";
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:title];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(newAddressPop)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(0, 0, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    [cancelBtn addTarget:self action:@selector(newAddressPop) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 84, kScreen_width, kScreen_height-64) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kBottomView_height)];
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreen_width, 0.5)];
//    bottomLine.backgroundColor = [UIColor lightGrayColor];
//    [bottomView addSubview:bottomLine];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(kSaveBtn_left, kBottomView_height-kSaveBtn_height-15, kScreen_width-2*kSaveBtn_left, kSaveBtn_height);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.backgroundColor = kRedColor;
    saveBtn.layer.cornerRadius = 5;
    [saveBtn addTarget:self action:@selector(saveNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:saveBtn];
    
    tableView.tableFooterView = bottomView;
    textF0 = [[newAddressView alloc] initWithFrame:CGRectMake(15, 10, kScreen_width-30, 45)];
    textF1 = [[newAddressView alloc] initWithFrame:CGRectMake(15, 10, kScreen_width-30, 45)];
    textF2 = [[newAddressView alloc] initWithFrame:CGRectMake(15, 10, kScreen_width-30, 45)];
    textF3 = [[newAddressView alloc] initWithFrame:CGRectMake(15, 10, kScreen_width-30, 45)];

    // Do any additional setup after loading the view.
}

-(void)newAddressPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    newAddressView *textF = [[newAddressView alloc] initWithFrame:CGRectMake(15, 10, kScreen_width-30, 45)];
//    textF.tag = 600 + indexPath.row;
//    textF.textField.font = [UIFont boldSystemFontOfSize:kFontSize_1];
    switch (indexPath.row) {
        case 0:{
            textF0.textField.placeholder = @"收货人";
            [cell.contentView addSubview:textF0];
            textF0.addImageView.image = [UIImage imageNamed:@"add_user"];
        }
            break;
        case 1:{
            textF1.textField.placeholder = @"手机号";
            textF1.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentView addSubview:textF1];
            textF1.addImageView.image = [UIImage imageNamed:@"add_number"];
        }
            
            break;
        case 2:{
            textF2.textField.placeholder = @"收货地址";
            [cell.contentView addSubview:textF2];
            textF2.addImageView.image = [UIImage imageNamed:@"add_address"];

        }
            break;
        case 3:{
            textF3.textField.placeholder = @"备注";
            [cell.contentView addSubview:textF3];
            textF3.addImageView.image = [UIImage imageNamed:@"address_mark"];

        }
            break;
        default:
            break;
    }
//    [cell.contentView addSubview:textF];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

-(void)saveNewAddress
{
    NSLog(@"======= 保存新添加收货地址");
    BOOL RF = [[YanMethodManager defaultManager]validateMobile:textF1.textField.text];
    if (RF==YES) {
        NSLog(@"正确");
        if(!_addressModel){
            if (textF0.textField.text.length!=0&&textF1.textField.text.length!=0&&textF2.textField.text.length!=0)
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NetWorkRequest *request = [[NetWorkRequest alloc]init];
                NSString *memberID =[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
                NSLog(@"%@",memberID);
                NSString *para = [NSString stringWithFormat:@"member_id=%@&consigner=%@&mobile=%@&address=%@&remark=%@",memberID,textF0.textField.text,textF1.textField.text,textF2.textField.text,textF3.textField.text];

                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=addaddress"] postData:para];
                request.successRequest = ^(NSDictionary *dataDic)
                {
                    NSLog(@"添加地址%@",dataDic);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSNumber *codeNum = [dataDic objectForKey:@"code"];
                    if (codeNum.intValue == 200) {
                        
//                        [self.view makeToast:@"已添加新的收货地址" duration:.5 position:@"center"];
                        if (_addressBlock) {
                            
                            _addressBlock();
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        });

                    }else if (codeNum.intValue ==202){
                    
                    
                        [self.view makeToast:@"该收获地址已被添加" duration:.5 position:@"center"];

                    
                    }else{
                        
                        [self.view makeToast:@"添加失败" duration:.5 position:@"center"];
                        
                    }
                    
                };
                request.failureRequest = ^(NSError *error){
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    
                };
                
                
            }
        }
        else
        {
            if (textF0.textField.text.length!=0&&textF1.textField.text.length!=0&&textF2.textField.text.length!=0)
            {
                
                NetWorkRequest *request = [[NetWorkRequest alloc]init];
                NSString *memberID =[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
                NSLog(@"%@",memberID);

                NSString *para = [NSString stringWithFormat:@"id=%d&consigner=%@&mobile=%@&address=%@&remark=%@&member_id=%@",_addressModel.address_id,textF0.textField.text,textF1.textField.text,textF2.textField.text,textF3.textField.text,memberID];

                [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=editaddressinfo"] postData:para];
                request.successRequest = ^(NSDictionary *dataDic)
                {
                    NSLog(@"dajdjagjdgj%@",dataDic);
                    NSNumber *codeNum = [dataDic objectForKey:@"code"];
                    if (codeNum.intValue == 200) {
                        
                        [self.view makeToast:@"修改地址成功" duration:.5 position:@"center"];
                        if (_addressBlock) {
                            
                            _addressBlock();
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        });
                        
                    }else{
                        
                        [self.view makeToast:@"修改地址失败" duration:.5 position:@"center"];
                        
                    }
                    
                    
                    
                    
                };
                request.failureRequest = ^(NSError *error){
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    
                };
                
                
            }
        }
        
        if(textF0.textField.text.length==0){
            
            [self.view makeToast:@"用户名不能为空" duration:1.5 position:@"center"];
        }else if (textF1.textField.text.length==0){
            [self.view makeToast:@"手机号不能为空"duration:1.5 position:@"center"];
        }else if(textF2.textField.text.length==0){
            [self.view makeToast:@"收货地址不能为空" duration:1.5 position:@"center"];
        }

    }else{
        [self.view makeToast:@"手机号格式错误" duration:1.5 position:@"center"];
    }
    
   

    
}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    UITextField *textF0 = (UITextField *)[self.view viewWithTag:600];
//    UITextField *textF1 = (UITextField *)[self.view viewWithTag:601];
//    UITextField *textF2 = (UITextField *)[self.view viewWithTag:602];
//    UITextField *textF3 = (UITextField *)[self.view viewWithTag:603];
//    [textF0 resignFirstResponder];
//    [textF1 resignFirstResponder];
//    [textF2 resignFirstResponder];
//    [textF3 resignFirstResponder];
//}
//编辑收货地址传入旧地址
-(void)setAddressModel:(goodsClassify *)addressModel{
    _addressModel = addressModel;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    textF2.textField.text = _addressModel.address;
    textF0.textField.text = _addressModel.consigner;
    textF1.textField.text = _addressModel.mobile;
    textF3.textField.text = _addressModel.remark;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
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

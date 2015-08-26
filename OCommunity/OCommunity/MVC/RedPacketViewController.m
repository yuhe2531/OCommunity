//
//  RedPacketViewController.m
//  OCommunity
//
//  Created by Runkun1 on 15/6/30.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import "RedPacketViewController.h"

@interface RedPacketViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) float hongbao;

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWithRGB(247, 246, 104);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = [[YanMethodManager defaultManager] navibarTitle:@"红包"];
    [[YanMethodManager defaultManager] popToViewControllerOnClicked:self selector:@selector(redpacketPop)];
    [self addRedPacketSubviews];
    // Do any additional setup after loading the view.
}

-(void)addRedPacketSubviews
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 300)];
    imageView.image = [UIImage imageNamed:@"redPackage_bg.jpg"];
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 80+200)];
    view.center = self.view.center;
    [self.view addSubview:view];
    
    imageView.centerY = view.centerY-40;
    
    UILabel *redPacketLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 80)];
    redPacketLabel.backgroundColor = kColorWithRGB(252, 253, 193);
    redPacketLabel.adjustsFontSizeToFitWidth = NO;
    redPacketLabel.text = [NSString stringWithFormat:@"您有%.1f元的红包\n要尽快使用哦!!",_hongbao];
    redPacketLabel.textColor = kBlack_Color_1;
    redPacketLabel.textAlignment = NSTextAlignmentCenter;
    redPacketLabel.numberOfLines = 2;
    redPacketLabel.font = [UIFont systemFontOfSize:kFontSize_2];
    redPacketLabel.centerX = view.width/2;
    [view addSubview:redPacketLabel];
    
    UIImageView *packetImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, redPacketLabel.bottom, 250, 200)];
    packetImgv.centerX = view.width/2;
//    packetImgv.backgroundColor = [UIColor blueColor];
    packetImgv.contentMode = UIViewContentModeScaleToFill;
    packetImgv.image = [UIImage imageNamed:@"check_packet"];
    [view addSubview:packetImgv];
    
    NSDictionary *storeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"market_item_local"];
    NSString *store_id = [storeDic objectForKey:@"store_id"];
    NSString *member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NetWorkRequest *request = [[NetWorkRequest alloc] init];
    [request requestForPOSTWithUrl:[kHostHttp stringByAppendingString:@"mobile/api.php?commend=hongbaostore"] postData:[NSString stringWithFormat:@"store_id=%@&member_id=%@",store_id,member_id]];
    request.successRequest = ^(NSDictionary *packageDic){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSNumber *code = [packageDic objectForKey:@"code"];
        if (code.integerValue == 200) {
            NSNumber *ishonebao = [packageDic objectForKey:@"ishongbao"];
            NSNumber *islingqu = [packageDic objectForKey:@"islingqu"];
            NSNumber *isxiaofei = [packageDic objectForKey:@"isxiaofei"];
            if (ishonebao.integerValue == 1 && islingqu.integerValue == 1) {
                NSDictionary *dataDic = [packageDic objectForKey:@"data"];
                if ([[YanMethodManager defaultManager] isDictionaryEmptyWithDic:dataDic] == NO) {
                    NSNumber *hongbao = [dataDic objectForKey:@"hongbao"];
                    
                    if (isxiaofei.integerValue == 0) {
                        _hongbao = hongbao.floatValue;
                    } else {
                        _hongbao = 0;
                    }
                }
                
                NSString *redStr = [NSString stringWithFormat:@"您有%.1f元的红包\n要尽快使用哦!!",_hongbao];
                redPacketLabel.attributedText = [[YanMethodManager defaultManager] attributStringWithColor:kRed_PriceColor text:redStr specialStr:[NSString stringWithFormat:@"%.1f",_hongbao]];
            
            } else if (islingqu.integerValue == 1 && isxiaofei.integerValue == 1) {
                redPacketLabel.text = [NSString stringWithFormat:@"您的红包已使用\n等待下一波红包吧!"];
            }
            else {
                redPacketLabel.text = [NSString stringWithFormat:@"等一等\n红包马上发"];
            }
        }
    };
 
}

-(void)redpacketPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
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

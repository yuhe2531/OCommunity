//
//  NoLoginViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/5/13.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DissmissBlock)(void);

@interface NoLoginViewController : UIViewController

@property (nonatomic, copy) DissmissBlock dissmissBlock;

@end

//
//  GoodsCategoryViewController.h
//  OCommunity
//
//  Created by Runkun1 on 15/4/28.
//  Copyright (c) 2015年 Runkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

{
     BOOL close[100];
}

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL footer_Refresh;
@property (nonatomic, assign) BOOL table_Click;
@property (nonatomic, assign) BOOL collection_First;
@property (nonatomic, assign) BOOL marketHomeMore;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

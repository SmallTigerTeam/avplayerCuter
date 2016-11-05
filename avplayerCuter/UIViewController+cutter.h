//
//  UIViewController+cutter.h
//  avplayerCuter
//
//  Created by mac_w on 2016/11/5.
//  Copyright © 2016年 aee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CutterVideoVC.h"

@interface UIViewController (cutter)<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)CutterVideoVC *cutterVC;


-(void)selectedButtonDidClicked;
@end

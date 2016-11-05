//
//  UIViewController+cutter.m
//  avplayerCuter
//
//  Created by mac_w on 2016/11/5.
//  Copyright © 2016年 aee.wutaotao All rights reserved.
//  

#import "UIViewController+cutter.h"
#import <objc/runtime.h>

static char flashKey;

@implementation UIViewController (cutter)

-(void)setCutterVC:(CutterVideoVC *)cutterVC
{
    objc_setAssociatedObject(self, &flashKey, cutterVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CutterVideoVC *)cutterVC
{
    return objc_getAssociatedObject(self, &flashKey);
}


-(void)selectedButtonDidClicked{
    
   
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate=self;
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:picker animated:YES completion:nil];
    

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL *videoURL=info[@"UIImagePickerControllerMediaURL"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.cutterVC=[[CutterVideoVC alloc]init];
    self.cutterVC.sourceURL=videoURL;
    [self addChildViewController:self.cutterVC];
    self.cutterVC.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:self.cutterVC.view];
    
    
    
}





@end

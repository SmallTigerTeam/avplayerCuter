//
//  CutterVideoVC.h
//  avplayerCuter
//
//  Created by mac_w on 2016/11/4.
//  Copyright © 2016年 aee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CutterVideoVC : UIViewController
@property(nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong) NSMutableArray		*groupArrays;
@property (nonatomic,strong) UIImageView *litimgView;

@property (nonatomic,strong) NSMutableArray *movideUrlArr;

@property (nonatomic,strong) UIView *videoView;

@property (nonatomic,strong) AVPlayerLayer *playerlayer;

@property (nonatomic,strong) AVPlayer *player;



@property (nonatomic,strong) UIImageView *firstImageView;
@property (nonatomic,strong) UIButton *playButton;

@property (strong, nonatomic)  UITextField *beginTime;

@property (strong, nonatomic)   UITextField *endTime;

@property (nonatomic,strong) NSURL *sourceURL;
@end

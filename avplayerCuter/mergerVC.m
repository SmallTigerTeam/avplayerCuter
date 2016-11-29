//
//  mergerVC.m
//  avplayerCuter
//
//  Created by mac_w on 2016/11/29.
//  Copyright © 2016年 aee. All rights reserved.
//

#import "mergerVC.h"
#import <AVFoundation/AVFoundation.h>

@interface mergerVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)NSURL *outptVideoUrl;

@property(nonatomic,strong)UIImageView *playerView;

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerLayer  *playerLayer;

@end

@implementation mergerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self.view addSubview:self.mergerButton];
    
    [self.view addSubview:self.chooseViewButton];
    [self.view addSubview:self.playerView];
    
}

-(void)chooseVideoS{
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
    
    [self.sourcePathARR addObject:videoURL];
    
}



-(void)mergerButtonDidClicked{
    

    
    if (self.sourcePathARR.count<2) {
        UIAlertController *alerVC=[UIAlertController alertControllerWithTitle:@"没有足够的视频" message:@"请添加两个以上视频" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alerVC animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alerVC dismissViewControllerAnimated:YES completion:nil];
        });
        
    }else{
        
        NSMutableArray *assetArr=[NSMutableArray array];
        for (NSURL *sourcePath in self.sourcePathARR) {
            AVAsset *asset = [AVAsset assetWithURL:sourcePath];
            [assetArr addObject:asset];
        }

        
        AVMutableComposition *mainComposition = [[AVMutableComposition alloc] init];
        AVMutableCompositionTrack *compositionVideoTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        AVMutableCompositionTrack *soundtrackTrack = [mainComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        CMTime insertTime = kCMTimeZero;
        for(AVAsset *videoAsset in assetArr){
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:insertTime error:nil];
            
            [soundtrackTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:insertTime error:nil];
            
            // Updating the insertTime for the next insert
            insertTime = CMTimeAdd(insertTime, videoAsset.duration);
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        // Creating a full path and URL to the exported video
        NSString *outputVideoPath =  [documentsDirectory stringByAppendingPathComponent:
                                      [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        // NSString *documentsDirectory = [paths objectAtIndex:0];
        //    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
        //                             current_name];
        NSURL *outptVideoUrl = [NSURL fileURLWithPath:outputVideoPath];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mainComposition presetName:AVAssetExportPreset640x480];
        
        // Setting attributes of the exporter
        exporter.outputURL=outptVideoUrl;
        exporter.outputFileType =AVFileTypeMPEG4; //AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //completion(exporter);
                AVAsset *asset=[AVAsset assetWithURL:outptVideoUrl];
                AVPlayerItem *item=[[AVPlayerItem alloc]initWithAsset:asset];
                
                _player = [[AVPlayer alloc] initWithPlayerItem:item];
                
                _playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
                _playerLayer.frame=_playerView.bounds;
                [_playerView.layer addSublayer: _playerLayer];
                [_player play];
                NSLog(@"合成成功！---%@",outptVideoUrl);
                // [self exportDidFinish:exporter:assets];
            });
        }];
        
        
    }
    
}

-(UIButton *)chooseViewButton{
    if (_chooseViewButton==nil) {
        _chooseViewButton=[[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100), 400, 100, 40)];
        [_chooseViewButton setTitle:@"选择视频" forState:UIControlStateNormal];
        [_chooseViewButton addTarget:self action:@selector(chooseVideoS) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _chooseViewButton;
}



-(UIButton *)mergerButton{
    
    if (_mergerButton==nil) {
        _mergerButton=[[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100), 500, 100, 40)];
        [_mergerButton setTitle:@"合成" forState:UIControlStateNormal];
        [_mergerButton addTarget:self action:@selector(mergerButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mergerButton;
}

-(NSMutableArray *)sourcePathARR{
    
    if (_sourcePathARR==nil) {
        _sourcePathARR=[NSMutableArray array];
    }
    return _sourcePathARR;
}

-(UIImageView *)playerView{
    if (_playerView==nil) {
        _playerView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
        _playerView.backgroundColor=[UIColor greenColor];
    }
    return _playerView;
}



@end

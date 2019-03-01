//
// Created by LAgagggggg on 2018/11/17.
// Copyright (c) 2018 ookkee. All rights reserved.
//

#import "IntroduceViewController.h"
#import <AVFoundation/AVFoundation.h>

typedef enum : NSInteger {
    OBIntroduceStatusFirst,
    OBIntroduceStatusFirstEnd,
    OBIntroduceStatusSecond,
    OBIntroduceStatusSecondEnd,
    OBIntroduceStatusThird,
    OBIntroduceStatusThirdEnd,
    OBIntroduceStatusLast,
    OBIntroduceStatusEnd
} OBIntroduceStatus;

@interface IntroduceViewController ()

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic) OBIntroduceStatus status;
@property (nonatomic) NSArray<AVPlayerItem *>* playerItemArr;

@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidTaped)];
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidSwipedDown)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewDidSwipedLeft)];
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeLeft];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[0]];
    self.status=OBIntroduceStatusFirst;
    self.player.rate=-1;
    [self.player play];
}

-(void)setUI{
    //视频layer
    self.player = [[AVPlayer alloc] init];
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    avLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:avLayer];
    //skip按钮
    UIButton * skipButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:skipButton];
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.equalTo(self.view.mas_top).with.offset(OB_TopHeight+15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setTintColor:[UIColor lightGrayColor]];
    [skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - event response

- (void)videoPlayDidEnd{
    if (self.status==OBIntroduceStatusFirst) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.status==OBIntroduceStatusFirst) {
                CMTimeScale scale=self.player.currentItem.duration.timescale;
                CMTimeValue value=760;
                [self.player seekToTime:CMTimeMake(value, scale)];
                [self.player play];
            }
        });
    } else if (self.status==OBIntroduceStatusFirstEnd){
        [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[1]];
        self.status=OBIntroduceStatusSecond;
        [self.player play];
    } else if (self.status==OBIntroduceStatusSecond){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.status==OBIntroduceStatusSecond) {
                CMTimeScale scale=self.player.currentItem.duration.timescale;
                CMTimeValue value=160;
                [self.player seekToTime:CMTimeMake(value, scale)];
                [self.player play];
            }
        });
    } else if (self.status==OBIntroduceStatusSecondEnd){
        [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[2]];
        self.status=OBIntroduceStatusThird;
        [self.player play];
    } else if (self.status==OBIntroduceStatusThird) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.status==OBIntroduceStatusThird) {
                CMTimeScale scale=self.player.currentItem.duration.timescale;
                CMTimeValue value=860;
                [self.player seekToTime:CMTimeMake(value, scale)];
                [self.player play];
            }
        });
    } else if (self.status==OBIntroduceStatusThirdEnd){
        [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[3]];
        self.status=OBIntroduceStatusLast;
        [self.player play];
    } else if (self.status==OBIntroduceStatusLast){
        self.status=OBIntroduceStatusEnd;
    }
}

- (void)viewDidTaped{
    if (self.status==OBIntroduceStatusFirst) {
        if (self.player.timeControlStatus==AVPlayerTimeControlStatusPlaying) {
            self.status=OBIntroduceStatusFirstEnd;
        }
        else{
            [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[1]];
            self.status=OBIntroduceStatusSecond;
            [self.player play];
        }
    } else if (self.status==OBIntroduceStatusThird){
        if (self.player.timeControlStatus==AVPlayerTimeControlStatusPlaying) {
            self.status=OBIntroduceStatusThirdEnd;
        }
        else{
            [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[3]];
            self.status=OBIntroduceStatusLast;
            [self.player play];
        }
    } else if (self.status==OBIntroduceStatusEnd){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidSwipedDown{
    if (self.status==OBIntroduceStatusSecond) {
        if (self.player.timeControlStatus==AVPlayerTimeControlStatusPlaying) {
            self.status=OBIntroduceStatusSecondEnd;
        }
        else{
            [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[2]];
            self.status=OBIntroduceStatusThird;
            [self.player play];
        }
        
    }
}

- (void)viewDidSwipedLeft{
    if (self.status==OBIntroduceStatusFirst) {
        if (self.player.timeControlStatus==AVPlayerTimeControlStatusPlaying) {
            self.status=OBIntroduceStatusFirstEnd;
        }
        else{
            [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[1]];
            self.status=OBIntroduceStatusSecond;
            [self.player play];
        }
    }else if (self.status==OBIntroduceStatusSecond) {
        if (self.player.timeControlStatus==AVPlayerTimeControlStatusPlaying) {
            self.status=OBIntroduceStatusSecondEnd;
        }
        else{
            [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[2]];
            self.status=OBIntroduceStatusThird;
            [self.player play];
        }
    } else if (self.status==OBIntroduceStatusThird){
        if (self.player.timeControlStatus==AVPlayerTimeControlStatusPlaying) {
            self.status=OBIntroduceStatusThirdEnd;
        }
        else{
            [self.player replaceCurrentItemWithPlayerItem:self.playerItemArr[3]];
            self.status=OBIntroduceStatusLast;
            [self.player play];
        }
    } else if (self.status==OBIntroduceStatusEnd){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)skipButtonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter&getter

- (NSArray<AVPlayerItem *> *)playerItemArr{
    if (!_playerItemArr) {
        NSMutableArray * tempArr=[[NSMutableArray alloc]init];
        for (int i=1; i<=4; i++) {
            NSString * resource=[NSString stringWithFormat:@"Introduce%d",i];
            NSString * videoPath=[[NSBundle mainBundle] pathForResource:resource ofType:@"mp4"];
            NSURL * videoURL=[NSURL fileURLWithPath:videoPath];
            AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoURL];
            [tempArr addObject:playerItem];
        }
        _playerItemArr=tempArr.copy;
    }
    return _playerItemArr;
}


@end

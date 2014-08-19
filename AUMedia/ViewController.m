//
//  ViewController.m
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "ViewController.h"
#import "AUMedia.h"
#import "AUMediaExampleItem.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *downloadAudioProgress;
@property (strong, nonatomic) IBOutlet UITextField *audioPathTextField;
@property (strong, nonatomic) IBOutlet UISlider *audioslider;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[AUMedia sharedInstance] setAudioProgressBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished, id<AUItem> item) {

        if (_audioslider.maximumValue != timeRemaining + elapsedTime) {
            [_audioslider setMinimumValue:0];
            [_audioslider setMaximumValue:elapsedTime + timeRemaining];
        }
        
        [_audioslider setValue:elapsedTime animated:YES];
    }];
    
    [[AUMedia sharedInstance] openMediaItem:[self audioItem]];
    [[[AUMedia sharedInstance] audioPlayer] pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)audioSliderChanged:(UISlider *)sender {
    CGFloat newValue = sender.value;
    [[[AUMedia sharedInstance] audioPlayer] moveToSecond:newValue];
}

- (IBAction)playAudio:(id)sender {
    if ([[[AUMedia sharedInstance] audioPlayer] status] == AFSoundManagerStatusPlaying) {
        [[[AUMedia sharedInstance] audioPlayer] pause];
    } else if ([[[AUMedia sharedInstance] audioPlayer] status] == AFSoundManagerStatusPaused) {
        [[[AUMedia sharedInstance] audioPlayer] resume];
    }
}

- (IBAction)stopAudio:(id)sender {
    [[[AUMedia sharedInstance] audioPlayer] stop];
}

- (IBAction)downloadAudio:(id)sender {
    [[AUMedia sharedInstance] downloadMediaItem:[self audioItem]];
}

- (AUMediaExampleItem *)audioItem {
    AUMediaExampleItem *item = [[AUMediaExampleItem alloc] init];
    [item setRemotePath:_audioPathTextField.text];
    [item setUid:2];
    [item setType:AUAudioItemType];
    
    return item;
}

@end

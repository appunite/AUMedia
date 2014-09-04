//
//  ViewController.m
//  AUMedia
//
//  Created by Piotr Bernad on 18.08.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "ViewController.h"
#import "AUMedia.h"
#import "AUMediaItem.h"

static void *AUMediaProgressObserverContext = &AUMediaProgressObserverContext;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *downloadAudioProgress;
@property (strong, nonatomic) IBOutlet UITextField *audioPathTextField;
@property (strong, nonatomic) IBOutlet UISlider *audioslider;
@property (strong, nonatomic) AUMediaItem *audioItem;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[AUMedia sharedInstance] setAudioProgressBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished, AUMediaItem *item) {

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
    BOOL started = [[AUMedia sharedInstance] downloadMediaItem:[self audioItem]];
    
    if (started) {
        NSProgress *progress= [[AUMedia sharedInstance] progressForItem:[self audioItem]];
        [_downloadAudioProgress setProgress:progress.fractionCompleted];
        [progress addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                      options:NSKeyValueObservingOptionInitial
                      context:AUMediaProgressObserverContext];
    } else {
        [_downloadAudioProgress setProgress:1.0f animated:YES];
    }
}

- (AUMediaItem *)audioItem {
    if (!_audioItem) {
        _audioItem = [[AUMediaItem alloc] init];
        [_audioItem setRemotePath:_audioPathTextField.text];
        [_audioItem setUid:2];
        [_audioItem setType:AUAudioItemType];
    }
    
    return _audioItem;
}

#pragma mark - Progress Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == AUMediaProgressObserverContext) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSProgress *progress = object;
            [self.downloadAudioProgress setProgress:progress.fractionCompleted animated:YES];
        }];
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

@end

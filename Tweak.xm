#include <AVFoundation/AVAudioPlayer.h>
#include <AppSupport/CPDistributedMessagingCenter.h>
%hook SpringBoard
AVAudioPlayer *player = [[AVAudioPlayer alloc] init];
-(void) applicationDidFinishLaunching:(id)fp8 {
    %orig;
    CPDistributedMessagingCenter *playMessagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.artikus.playcenter"];
    [playMessagingCenter runServerOnCurrentThread];
    [playMessagingCenter registerForMessageName:@"playAudio" target:self selector:@selector(play:message:)];
}
%new
- (NSDictionary *)play:(NSString *)name message:(NSDictionary *)userInfo {
    if([[userInfo objectForKey:@"message"] isEqualToString:@"stop"]) {
        printf("Stopping audio playback.");
        [player stop];
    } else if([[userInfo objectForKey:@"message"] isEqualToString:@"pause"]) {
        printf("Pausing audio playback");
        [player pause];
    } else if([[userInfo objectForKey:@"message"] isEqualToString:@"play"]) {
        printf("Starting playback again.");
        [player play];
    } else {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[userInfo objectForKey:@"message"] isDirectory:NO] error:nil];
        [player prepareToPlay];
        [player play];
    }
    return nil;
}
%end

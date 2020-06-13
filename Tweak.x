#include <AVFoundation/AVFoundation.h>
#include <AppSupport/CPDistributedMessagingCenter.h>

%hook SpringBoard

AVAudioPlayer *player;

- (void)applicationDidFinishLaunching:(id)application {
  %orig;
  player = [AVAudioPlayer new];
  CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"com.artikus.playcenter"];
  [center runServerOnCurrentThread];
  [center registerForMessageName:@"playAudio" target:self selector:@selector(play:message:)];
}

%new
- (NSDictionary *)play:(NSString *)name message:(NSDictionary *)userInfo {
  if([[userInfo objectForKey:@"message"] isEqualToString:@"stop"]) {
    printf("Stopping audio playback.");
    [player stop];
  } else if([[userInfo objectForKey:@"message"] isEqualToString:@"pause"]) {
    printf("Pausing audio playback.");
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

#include <AppSupport/CPDistributedMessagingCenter.h>
int main(int argc, char **argv, char **envp) {
  NSString *arg = [NSString stringWithCString:(argv[1] ? : "") encoding:NSUTF8StringEncoding];
  if(argc < 2 || (![[NSFileManager defaultManager] fileExistsAtPath:arg isDirectory:nil] && ![@[@"stop", @"pause", @"play"] containsObject:arg])) {
    printf("Please choose a file to play (and make sure it exists), for example:\nplaycli /var/mobile/Music/Lil_Peep_The_Brightside.mp3 (also be sure to use quotes \"\" if using file paths that contain spaces)\nYou can also control your playback:\nplaycli pause\nplaycli play\nplaycli stop\n");
    return -1;
  }
  CPDistributedMessagingCenter *center = [CPDistributedMessagingCenter centerNamed:@"com.artikus.playcenter"];
  [center sendMessageAndReceiveReplyName:@"playAudio" userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] forKey:@"message"]];
  return 0;
}

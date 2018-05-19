#include <AppSupport/CPDistributedMessagingCenter.h>
#import <AudioToolbox/AudioToolbox.h>
int main(int argc, char **argv, char **envp) {
    if (argc < 2) {
        printf("Please choose a file to play (and make sure it exists), for example:\nplaycli /var/mobile/Music/Lil_Peep_The_Brightside.mp3 (also be sure to use quotes \"\" if using file paths that contain spaces)\nYou can also control your playback:\nplaycli pause\nplaycli play\nplaycli stop\n");
        return -1;
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding]] && ![[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] isEqualToString:@"stop"] && ![[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] isEqualToString:@"pause"] && ![[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] isEqualToString:@"play"]) {
        printf("Please choose a file to play (and make sure it exists), for example:\nplaycli /var/mobile/Music/Lil_Peep_The_Brightside.mp3 (also be sure to use quotes \"\" if using file paths that contain spaces)\nYou can also control your playback:\nplaycli pause\nplaycli play\nplaycli stop\n");
        return -1;
    } else {
        CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.artikus.playcenter"];
        [messagingCenter sendMessageAndReceiveReplyName:@"playAudio" userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding] forKey:@"message"]];
        AudioFileID fileID;
        OSStatus result = AudioFileOpenURL((CFURLRef)[NSURL fileURLWithPath:[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding]], kAudioFileReadPermission, 0, &fileID);
        if (result != noErr) {
            return -1;
        }
        CFDictionaryRef piDict = nil;
        UInt32 piDataSize = sizeof(piDict);
        result = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
        if (result != noErr) return -1;
        AudioFileClose(fileID);
        NSDictionary *tagsDictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary*)piDict];
        CFRelease(piDict);
        printf("Playing: \"%s - %s\"\n",[[tagsDictionary valueForKey:@"artist"] UTF8String],[[tagsDictionary valueForKey:@"title"] UTF8String]);
        return 0;
    }
}

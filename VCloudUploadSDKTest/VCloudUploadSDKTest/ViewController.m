//
//  ViewController.h
//  NOSSDKDemo
//
//  Created by taojinliang on 16/8/24.
//  Copyright © 2016年 taojinliang. All rights reserved.
//

#import "ViewController.h"
#import "NOSVCloudUploadSDK.h"
#import "MD5Utils.h"
#import "NOSTestConf.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,NOSUploadRequestDelegate>
@property (weak, nonatomic) IBOutlet UITextField *soTimeoutText;
@property (weak, nonatomic) IBOutlet UITextField *chunkSizeText;
@property (weak, nonatomic) IBOutlet UITextField *retryCountText;
@property (weak, nonatomic) IBOutlet UITextField *monitorInterval;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (nonatomic, copy) NSString *lastPath;
@property (nonatomic, assign) NSInteger lastType;
@end

BOOL cancelUpload = NO;
NOSUploadManager *upManager = nil;

@implementation ViewController

-(NSString *)NOSUploadAppKey{
    return kNOSTestAppKey;
}

-(NSString *)NOSVcloudAppAccid{
    return kNOSTestAccid;
}

-(NSString *)NOSVcloudAppToken{
    return kNOSTestToken;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    NSError *error = nil;
    NSString *dir = [NSTemporaryDirectory() stringByAppendingString:@"nos-ios-sdk-test"];
    NSLog(@"%@", dir);
    //创建断点续传目录并记录
    NOSFileRecorder *file = [NOSFileRecorder fileRecorderWithFolder:dir error:&error];
    //配置基于位置服务的参数
 
    [self setGlobalConf];
    
    if (error) {
        NSLog(@"%@", error);
    }
    //实例化上传管理类
    upManager = [NOSUploadManager sharedInstanceWithRecorder: (id<NOSRecorderDelegate>)file
                                        recorderKeyGenerator: nil];
    //设置上传管理类的delegate
    upManager.delegate = self;
    self.progressBar.progress = 0;
}

- (void)setGlobalConf {
    NOSConfig *conf = [[NOSConfig alloc] initWithLbsHost: @"http://wanproxy.127.net"
                                           withSoTimeout: [_soTimeoutText.text intValue]
                       //withConnectionTimeout: [_connectTimeoutText.text intValue]
                                     withRefreshInterval: [_monitorInterval.text intValue]
                                           withChunkSize: [_chunkSizeText.text intValue] * 1024
                                     withMoniterInterval: [_monitorInterval.text intValue]
                                          withRetryCount: [_retryCountText.text intValue]];
    //将其设置为全局变量
    [NOSUploadManager setGlobalConf:conf];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self setGlobalConf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)DemoHttpsUpload:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    }
    ipc.delegate = self;
    [self presentViewController:ipc
                       animated:YES
                     completion:nil];
}

- (IBAction)DemoCancel:(id)sender {
    cancelUpload = YES;
}
- (IBAction)continueUpload:(id)sender {
    [self doUpload:self.lastPath type:self.lastType];
}

- (void)upload:(NSString *)filepath type:(NSInteger)key{
    self.lastPath = filepath;
    self.lastType = key;
    [self doUpload:filepath type:key];
}

- (void)doUpload:(NSString *)filepath type:(NSInteger)key{
    cancelUpload = NO;
    //文件初始化后可获取
    NSString *bucket = upManager.bucketName;
    NSString *object = upManager.objectName;
    NSString *token = upManager.xNosToken;

    NSString *localFileName = filepath;
    NSString* type = @"";
    if (key == 0) {
       type = @"image/jpeg";
    }else{
        type = @"application/octet-stream";
    }
    
    //可选参数集合:上传进度回调   视频：application/octet-stream   图片：image/jpeg
    NOSUploadOption *option = [[NOSUploadOption alloc] initWithMime:type
                                                    progressHandler: ^(NSString *key, float percent) {
                                                        NSLog(@"key:%@ current progress:%f", key, percent);
                                                        [self updateProcessBar:percent];
                                                    }
                                                              metas: nil
                                                 cancellationSignal: ^BOOL{
                                                     return cancelUpload;
                                                 }];
    
    //文件上传
    [upManager putFileByHttps: localFileName bucket:bucket key:object
                        token: token
                     complete: ^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
                         NSLog(@"上传完成~~");
                          if (key) {
                            NSLog(@"key=%@", key);
                          }
                          
                          if (info) {
                            NSLog(@"info=%@", info);
                          }
                          
                          if (resp) {
                            NSLog(@"resp=%@", resp);
                          }
        
    
                            if(info.statusCode == 200) {
                                [self updateProcessBar:1.0f];
                            }
                     }
                       option: option];
 
    NSLog(@"开始上传~~");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    NSString *name = @"";
    NSString *filepath = @"";
    NSInteger key = 0;
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        
        NSString *dataMd5 = [Md5Utls getMD5WithData:data];
        filepath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),dataMd5];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
            [data writeToFile:filepath atomically:YES];
        }
        name = [[filepath lastPathComponent] stringByAppendingPathExtension:@"jpg"];
        key = 0;
    }else if ([type isEqualToString:@"public.movie"]){
        //如果是视频
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSString *dataMd5 = [Md5Utls getMD5WithData:data];
        filepath = [NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),dataMd5];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
            [data writeToFile:filepath atomically:YES];
        }
        name = [[filepath lastPathComponent] stringByAppendingString:@".MOV"];
        key = 1;
    }
    
//    filepath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
//    name = @"1.mp4";
    
    //文件上传初始化
    __weak typeof (self) weakSelf = self;
    [upManager fileUploadInit:name userFileName:nil typeId:nil presetId:nil uploadCallbackUrl:nil callbackUrl:nil description:nil watermarkId:nil userDefInfo:nil  success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            [weakSelf upload:filepath type:key];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

- (IBAction)QueryId:(id)sender {
    //上传完成根据对象名查询视频或水印图片主Id
    [upManager videoQuery:[NSArray arrayWithObjects:upManager.objectName, nil] success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)updateProcessBar:(CGFloat)percent {
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) sSelf = wSelf;
        sSelf.progressBar.progress = percent;
    });
}

@end

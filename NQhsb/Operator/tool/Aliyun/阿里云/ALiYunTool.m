//
//  ALiYunTool.m
//  Employ
//
//  Created by YuanZhiPu on 15/10/19.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "ALiYunTool.h"
NSString * const g_AK = @"LTAIsmzNUDDLnBSL";
NSString * const g_SK = @"DszPXjiWJ2OQfCnchF2IdviVsDVJGN";
NSString * const TEST_BUCKET_IMAGE = @"huawuyuan";
NSString * const PUBLIC_BUCKET = @"public-read-write";
NSString * const ENDPOINTVIDEO = @"http://oss-cn-qingdao.aliyuncs.com";
NSString * const ENDPOINTIMAGE = @"http://oss-cn-qingdao.aliyuncs.com/";

NSString * const folderHeaderImage = @"headimage";//头像--->需要跟安卓的文件格式统一
NSString * const folderAudioImage = @"audiofile"; //声音

//NSString * const MultipartUploadObjectKey = @"multipartUploadObject";
static OSSClient * client;

@implementation ALiYunTool

+ (NSString *)upLoadImage:(UIImage *)image
{
    [OSSLog enableLog];
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = TEST_BUCKET_IMAGE;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
   
    request.objectKey = [NSString stringWithFormat:@"headimage/%@_img_%d.png",[NSDate timeStringWithDataTimeToDate:a],((arc4random()% 100000000) + 10000)];
    
    OSSPlainTextAKSKPairCredentialProvider *credential1 = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:g_AK secretKey:g_SK];
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3;
    conf.enableBackgroundTransmitService = NO;
    conf.timeoutIntervalForRequest = 15;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    client = [[OSSClient alloc] initWithEndpoint:ENDPOINTIMAGE credentialProvider:credential1 clientConfiguration:conf];
    
    //创建bucket
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = TEST_BUCKET_IMAGE;
    create.xOssACL = PUBLIC_BUCKET;
    create.location = @"oss-cn-beijing";
    [[[client createBucket:create] continueWithBlock:^id(OSSTask *task) {
        return nil;
    }] waitUntilFinished];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.1);
    request.uploadingData = data;
    request.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    NSString *urlString = [NSString stringWithFormat:@"http://huawuyuan.oss-cn-qingdao.aliyuncs.com/%@",request.objectKey];
    
    NSString *encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    OSSTask * task = [client putObject:request];
    
    [task  continueWithBlock:^id(OSSTask *task) {
       
        if (task.error) {
            OSSLogError(@"%@", task.error);
        }
        OSSPutObjectResult * result = task.result;
        NSLog(@"Result - requestId: %@, headerFields: %@",
              result.requestId,
              result.httpResponseHeaderFields);
        return nil;

    }];
    return encodingString;
}

#pragma mark --异步上传多张图片
+ (void)asyncUploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete
{
    BOOL  isAsync=YES;
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:g_AK           secretKey:g_SK];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3;
    conf.enableBackgroundTransmitService = NO;
    conf.timeoutIntervalForRequest = 15;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:ENDPOINTIMAGE credentialProvider:credential clientConfiguration:conf];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = TEST_BUCKET_IMAGE;
                NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a=[dat timeIntervalSince1970];
                NSString *imageName = [NSString stringWithFormat:@"headimage/%@_img_%d.png",[NSDate timeStringWithDataTimeToDate:a],((arc4random()% 100000000) + 10000)];//上传图片的路径
                put.objectKey = imageName;
                //
                //http://www.jianshu.com/p/62bf322d36d2  -->可点击查看原理 bucketName +aliYunHost+图片名称
                
                 NSString *encodingString = [[NSString stringWithFormat:@"http://huawuyuan.oss-cn-qingdao.aliyuncs.com/%@",imageName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [callBackNames addObject: encodingString];//上传成功时返回的图片路径,相对路径-->需要切换到绝对路径下面
                
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                
                OSSTask * putTask = [client putObject:put];
    
                [putTask continueWithBlock:^id(OSSTask *task)
                 {
                    
                     if (task.error)
                     {
                         OSSLogError(@"%@", task.error);
                     }
                     OSSPutObjectResult * result = task.result;
                     NSLog(@"Result - requestId: %@, headerFields: %@",
                           result.requestId,
                           result.httpResponseHeaderFields);
                     return nil;
                }]; // 阻塞直到上传完成
                if (isAsync) {
                    if (image == images.lastObject) {
                        NSLog(@"upload object finished!");
                        if (complete) {
                            complete([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        NSLog(@"haha");
        if (complete) {
            if (complete) {
                complete([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
            }
        }
    }
}
#pragma mark --上传音频
+ (NSString*)asyncUploadVideoPath:(NSString *)videoPath complete:(void(^)( UploadImageState state))complete
{
    
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = TEST_BUCKET_IMAGE;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    //
    request.objectKey = [NSString stringWithFormat:@"audiofile/%@_audio_%d.amr",[NSDate timeStringWithDataTimeToDate:a],((arc4random()% 100000000) + 10000)];
    
    OSSPlainTextAKSKPairCredentialProvider *credential1 = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:g_AK secretKey:g_SK];
    
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3;
    conf.enableBackgroundTransmitService = NO;
    conf.timeoutIntervalForRequest = 15;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    client = [[OSSClient alloc] initWithEndpoint:ENDPOINTIMAGE credentialProvider:credential1 clientConfiguration:conf];
    
    //创建bucket
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = TEST_BUCKET_IMAGE;
    create.xOssACL = PUBLIC_BUCKET;
    create.location = @"oss-cn-beijing";
    [[[client createBucket:create] continueWithBlock:^id(OSSTask *task) {
        return nil;
    }] waitUntilFinished];
    NSData *data ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:videoPath])//如果存在
    {
       data = [[NSData alloc] initWithContentsOfFile:videoPath];//获取数据
       
    }else
    {
      return @"路径为空";
    }
 
    request.uploadingData = data;
    request.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    NSString *urlString = [NSString stringWithFormat:@"http://huawuyuan.oss-cn-qingdao.aliyuncs.com/%@",request.objectKey];
    NSString *encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    OSSTask * task = [client putObject:request];
    [[task continueWithBlock:^id(OSSTask *task) {
        if (task.error)
        {
            complete(UploadImageSuccess);
            OSSLogError(@"%@", task.error);
            
        }else{
            complete(UploadImageFailed);
        }
        OSSPutObjectResult * result = task.result;
        NSLog(@"Result - requestId: %@, headerFields: %@",
              result.requestId,
              result.httpResponseHeaderFields);
        return nil;
    }] waitUntilFinished];

    return encodingString;

    
    
}
@end

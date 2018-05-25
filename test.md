#应用状态
iOS应用有以下5种状态
* **Not running**
app还没有被启动或者已经被系统杀死
* **Inactive**
app在前台运行，但是不能接受事件.app一般转换到其他转态过程中停留在改转态
* **Active**
app运行在前台可以接受事件。
* **Background**
app在后台正常运行代码。大部分app会在该转态停留短暂然后转到Supended状态，但是app可以申请额外的运行时间。

* **Suspended**
app在后台但不能运行代码。系统会在不通知app的情况下自动使app进入该状态。在内存充足的情况下，系统会把app保留在内存中，否则系统会把app清理。


几个状态转换如下图：
![](http://km.oa.com/files/photos/pictures/201805/1527139733_84_w904_h998.png)
下面介绍在几个重要的状态下开发中需要注意的问题
##Inactive
该状态会在双击Home键，来电，上下拉状态栏等情况下出现，同过下面方式通知app
```objc
- (void)applicationWillResignActive:(UIApplication *)application {

}
//或者通知
UIApplicationWillResignActiveNotification
```
如果app是显示动态页面或者需要用户交互，比如播放电影，捕捉用户手势等，进入该状态需要做相应的处理。

##Background
正常下app进入Background状态后停留短暂会转到Supended状态，目前暂时没找到Apple官方文档描述具体停留多久，因为Background状态下是可以运行代码，Suspended下是不能运行代码，
可以通过输出log，计算出运行时间
```objc
- (void)applicationDidEnterBackground:(UIApplication *)application {

    self.date = [NSDate date];
    __weak typeof(self) wself = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"background time %fS", [NSDate date].timeIntervalSince1970 - wself.date.timeIntervalSince1970);
    }];

}
```
Log输出为
```objc
2018-05-24 21:41:45.861395+0800 BackgroundMode[4990:445845] background time 0.024013S
2018-05-24 21:41:46.028801+0800 BackgroundMode[4990:445845] background time 0.191421S
```
因为在Background状态下只能有短暂的运行时间就会转向Suspended，而在Suspended下不能运行代码，在低内存的情况会直接被系统清楚，所以在当app进入Background状态后注意以下事项。
###不应该做


###应该做
####1. 准备好APP的截图
因为当 ***applicationDidEnterBackground*** 方法返回后，系统会把app当前界面截图，并且把该图作为过渡动画界面，如果当前页面包含敏感信息或者想修改过渡动画的界面，就是需要添加新View到app视图层级里面

####3.保存app相关的状态信息
3.尽快释放内存
####4.Suspended
在该状态下是没有代码运行，

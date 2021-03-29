# XMSinaSwift

#### 介绍
sina demo with swift 

使用stroyboard 进行模块划分，分配任务更优


1.首页【加载emoji以及自定义表情，图文混排（单张和多张图不同布局），富文本，以及点击事件。coredata存储首页前100条数据】

2.登录【登录页面（web方式。GCD新建私人并行队列，创建并发新线程，然后在新线程内进行信号量操作，保证先拿到token再获取个人信息）最后进入欢迎页面（切换根控制器）】

3.发布【发布新动态（图片、文本和表情）】


#### 软件架构
HomeDataCoreData【存储首页前100条数据】

Compose【发布】

Main【登录和欢迎】

Home【首页】

Msg【消息】

Discover【发现】

Profile【我的】

Tool【工具】

----->【网络moya封装】

----->【UI拓展】

----->【其他工具】


Pods【三方】


#### 安装教程

下载完毕不需要pod install


#### 使用说明

需要使用测试账号进行登录，账号见代码appdelegate

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request

欢迎小伙伴们推荐
联系方式：510846302@qq.com

#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)

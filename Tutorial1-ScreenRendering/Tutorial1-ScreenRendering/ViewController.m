//
//  ViewController.m
//  Tutorial1-ScreenRendering
//
//  Created by 琥珀川 on 16/8/31.
//  Copyright © 2016年 琥珀川. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <GLKViewControllerDelegate, GLKViewDelegate>

@property (nonatomic, assign) CGFloat redColorFloat; // RGB中红色的色值
@property (nonatomic, assign, getter=isIncreasing) BOOL increasing; // 判断是否增加


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.increasing = YES;
    self.redColorFloat = 0.0;
    
    self.delegate = self;
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    //    使用代码初始化
    //    GLKView *view = [GLKView alloc] initWithFrame:self.view.bounds context:context
    
    //    使用Storyboard初始化
    GLKView *view = (GLKView *)self.view;
    view.context = context; // 关联上下文
    
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888; // 颜色缓冲区格式
    //    view.drawableDepthFormat = GLKViewDrawableDepthFormat24; // 深度缓冲区格式
    //    view.drawableStencilFormat = GLKViewDrawableStencilFormat8; // 模型缓冲区格式
    //    view.drawableMultisample = GLKViewDrawableMultisample4X; // 允许多重采样 (多重采样主要用于反锯齿，只对多边形的边缘进行抗锯齿处理，资源消耗较小，最常见的反锯齿), 如果允许了多重采样，必须测试性能
    
    self.preferredFramesPerSecond = 60; // 控制刷新频率}
}

// 渲染场景代码
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(self.redColorFloat, 0, 0, 1); // 清理屏幕的RGB颜色和alpha值
    glClear(GL_COLOR_BUFFER_BIT); // 调用glClear来实际执行清理操作, 参数是一个缓冲区，缓冲区有多种格式，上篇文章有提及，现在我们执行的是颜色缓冲区
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
    
    if (self.isIncreasing) {
        self.redColorFloat += 1.0 * self.timeSinceLastUpdate;
    }else {
        self.redColorFloat -= 1.0 * self.timeSinceLastUpdate;
    }
    
    if (self.redColorFloat >= 1.0) {
        self.redColorFloat = 1.0;
        self.increasing = NO;
    }
    
    if (self.redColorFloat <= 0) {
        self.redColorFloat = 0;
        self.increasing = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

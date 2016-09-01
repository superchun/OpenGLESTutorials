//
//  ViewController.m
//  Tutorial2-SimpleGraphic
//
//  Created by 琥珀川 on 16/8/31.
//  Copyright © 2016年 琥珀川. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (nonatomic, assign) int count;
@property (nonatomic, assign) float reation;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reation = 0.0;
    self.preferredFramesPerSecond = 60;
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
//    view.delegate = self;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    [EAGLContext setCurrentContext:context];
    
    // 顶点数据
    GLfloat verties[] = {
        0.5, -0.5, 0.0,  1.0, 0.0, 0.0, 1.0,   // 前面为x, y, z, 后面为颜色
        0.5, 0.5, 0,     0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0,   0.0, 0.0, 1.0, 1.0,
        -0.5, 0.5, 0,    0.0, 0.0, 0.0, 1.0
    };
    
    // 索引数据
    GLuint indecs[] = {
        0, 3, 2,
        1, 3, 0
    };
    
    self.count = sizeof(indecs) / sizeof(GLuint);
    
    GLuint vertBuffer;
    GLuint indeBuffer;
    
    glGenBuffers(1, &vertBuffer); // 创建缓冲区对象
    glBindBuffer(GL_ARRAY_BUFFER, vertBuffer); // 指定当前活动缓冲区对象
                                               // GL_ARRAY_BUFFER 坐标，颜色等
                                               // GL_ELEMENT_ARRAY_BUFFER 索引坐标
    
    // 把顶点数据从 CPU 复制到 GPU
    glBufferData(GL_ARRAY_BUFFER, sizeof(verties), verties, GL_STATIC_DRAW);
    // glBufferData(<#GLenum target#>, <#GLsizeiptr size#>, <#const GLvoid *data#>, <#GLenum usage#>)
    // target 可以是GL_ARRAY_BUFFER(顶点数据)，或者GL_ELEMENT_ARRAY_BUFFER(索引数据)
    // 存储相关数据所需要的内存容量
    // 用于初始化缓冲区对象，可以是指向某一块内存地址，也可以是NULL
    // 数据分配后如何读写，详细介绍见：http://parisdog.club/OpenGLES-2.html
    
    glGenBuffers(1, &indeBuffer); // 索引数据
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indeBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indecs), indecs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 激活顶点属性
    //顶点属性包含5种属性：Position(位置)，Normal(法线)，Color(颜色)，TextCoord0(纹理0)，TextCoord1(纹理1)
    
    // 填充数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, (GLfloat *)NULL + 0);
    // glVertexAttribPointer(<#GLuint indx#>, <#GLint size#>, <#GLenum type#>, <#GLboolean normalized#>, <#GLsizei stride#>, <#const GLvoid *ptr#>)
    // indx: 要修改的顶点属性
    // size: 顶点属性组件的数量，必须是从1-4，默认为4。(如本demo中的顶点位置为3(x,y,z)，颜色为4(r,g,b,a))
    // type: 数据类型 (本demo中位置和颜色的类型都为Float)
    // normalized: 是否需要单位化
    // stride: 连续顶点中的偏移量 (本demo中，每行数据的跨度是7*4(7个float型数据，而float占4个字节，所以跨度是7 * 4))
    // ptr: 第一个组件在数组中的偏移量
    
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*7, (GLfloat *)NULL + 3);
    
    self.effect = [[GLKBaseEffect alloc] init];

}

- (void)update {
 
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    
    GLKMatrix4 projectMartix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(130.0), aspect, 0.1, 10.0);
    self.effect.transform.projectionMatrix = projectMartix;
    
    // 旋转
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -1.0);
    self.reation += 90 * self.timeSinceLastUpdate;
    modelMatrix = GLKMatrix4Rotate(modelMatrix, GLKMathDegreesToRadians(self.reation), 0, 0, 1);
    self.effect.transform.modelviewMatrix = modelMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    glClearColor(0.3, 0.6, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 启动着色器
    [self.effect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.count, GL_UNSIGNED_INT, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

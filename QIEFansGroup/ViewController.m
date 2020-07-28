//
//  ViewController.m
//  QIEFansGroup
//
//  Created by 李超群 on 2020/7/28.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>

/** 选择类型 */
typedef NS_ENUM(NSUInteger, NSChooseType) {
    NSChooseTypeIcon,
    NSChooseTypeLv,
    NSChooseTypeBg,
};

@interface ViewController() <NSTextFieldDelegate>

/** 选择的view */
@property (nonatomic, assign) NSChooseType chooseType;

/** 选择的view */
@property (nonatomic, weak) NSView *selectedView;

/** 所有imageView的背景View */
@property (nonatomic, weak) NSView *fansAllBgView;

/** 粉丝团的背景的视图 */
@property (nonatomic, weak) NSImageView *fansBgImageView;

/** 粉丝团的iocn的视图 */
@property (nonatomic, weak) NSImageView *fansIconImageView;

/** 粉丝团的等级的视图 */
@property (nonatomic, weak) NSImageView *fansLvImageView;

/** 坐标的textField */
@property (nonatomic, weak) NSTextField *xTF, *yTF, *widthTF, *heightTF;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.window.restorable = NO;
    [self.view.window setContentSize:NSMakeSize(800, 600)];

    // Do any additional setup after loading the view.
    [self setupUI];
}

-(void)viewWillAppear{
}

// - MARK: <-- 初始化 -->
/** 初始化UI */
-(void)setupUI{
    
    // - 设置按钮
    [self setupChooseButton];
    
    // - 设置上下左右的位置
    [self setupPositonTextField];
    
    // - 预览的图片
    [self setupPreviewView];
    
    /** 添加右键菜单 */
    [self setupMenu];
}

// - 添加右键菜单
-(void)setupMenu{
    // - 右键菜单
    NSMenu * menu = [[NSMenu alloc]initWithTitle:@"快捷选项"];
    NSMenuItem * item1 = [[NSMenuItem alloc]initWithTitle:@"选择视图" action:nil keyEquivalent:@""];

    // - 选择icon的view
    NSMenuItem * fansIconItem = [[NSMenuItem alloc]initWithTitle:@"icon" action:@selector(menuItemClick:) keyEquivalent:@""];
    fansIconItem.target = self;
    fansIconItem.tag = 11;
    
    // - 选择等级的view
    NSMenuItem * fansLvItem = [[NSMenuItem alloc]initWithTitle:@"等级" action:@selector(menuItemClick:) keyEquivalent:@""];
    fansLvItem.target = self;
    fansLvItem.tag = 12;
    
    // - 选择背景条的viwe
    NSMenuItem * fansBgItem = [[NSMenuItem alloc]initWithTitle:@"背景条" action:@selector(menuItemClick:) keyEquivalent:@""];
    fansBgItem.target = self;
    fansBgItem.tag = 13;
    
    // - 三个自菜单按钮
    NSMenu * subMenu1 = [[NSMenu alloc]initWithTitle:@"icon"];
    [subMenu1 addItem:fansIconItem];
    [subMenu1 addItem:fansLvItem];
    [subMenu1 addItem:fansBgItem];

    // - 主菜单按钮
    [menu addItem:item1];
    [menu setSubmenu:subMenu1 forItem:item1];
    [self.view setMenu:menu];
    
    // - 默认主动调用一次icon的位置
    [self menuItemClick:fansIconItem];
}

/** 初始化设置按钮 */
-(void)setupChooseButton{
    
    NSMutableArray *viewsArray = [NSMutableArray array];

    ({ // - 选择icon按钮
        NSButton *button = [NSButton buttonWithTitle:@"选择icon图片" target:self action:@selector(chooseIconButtonClick)];
        [self.view addSubview:button];
        [viewsArray addObject:button];
    });
    
    
    ({ // - 选择等级按钮
        NSButton *button = [NSButton buttonWithTitle:@"选择等级图片" target:self action:@selector(chooseLvButtonClick)];
        [self.view addSubview:button];
        [viewsArray addObject:button];
    });
    
    
    ({ // - 选择背景按钮
        NSButton *button = [NSButton buttonWithTitle:@"选择背景图片" target:self action:@selector(chooseBgButtonClick)];
        [self.view addSubview:button];
        [viewsArray addObject:button];
    });
    
    // - 布局
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(20);
    }];

    ({ // - 生成图片的按钮
        NSButton *button = [NSButton buttonWithTitle:@"生成图片" target:self action:@selector(creatButtonClick)];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.top.equalTo(self.view).offset(220);
        }];
    });
}

-(void)setupPositonTextField{
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    
    ({ //  - x 坐标
        NSTextField *tf = [[NSTextField alloc]init];
        tf.delegate = self;
        self.xTF = tf;
        tf.placeholderString = @"x 坐标";
        tf.bordered = YES;  ///是否显示边框
        [self.view addSubview:tf];
        [viewsArray addObject:tf];
    });
    
    ({ //  - y 坐标
        NSTextField *tf = [[NSTextField alloc]init];
        tf.delegate = self;
        self.yTF = tf;
        tf.placeholderString = @"y坐标";
        tf.bordered = YES;  ///是否显示边框
        [self.view addSubview:tf];
        [viewsArray addObject:tf];
    });
    
    ({ //  - 宽度
        NSTextField *tf = [[NSTextField alloc]init];
        tf.delegate = self;
        self.widthTF = tf;
        tf.placeholderString = @"宽度";
        tf.bordered = YES;  ///是否显示边框
        [self.view addSubview:tf];
        [viewsArray addObject:tf];
    });

    ({ //  - 高度
        NSTextField *tf = [[NSTextField alloc]init];
        tf.delegate = self;
        self.heightTF = tf;
        tf.placeholderString = @"高度";
        tf.bordered = YES;  ///是否显示边框
        [self.view addSubview:tf];
        [viewsArray addObject:tf];
    });
    
    // - 布局
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.height.mas_equalTo(20);
    }];
}
/** 预览的图片 */
-(void)setupPreviewView{
    CGFloat width = 52;
    CGFloat height = 20;
    
    // - 预览的底图, 方便查看大小
    NSView *previewBgView = ({
        NSView *view = [[NSView alloc]init];
        [self.view addSubview:view];
        [view setWantsLayer:YES];
        view.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-40);
        }];
        view;
    });
    
    // - 图片的背景视图
    NSView *bgView = ({
        NSView *view = [[NSView alloc]initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, width, height))];
        [previewBgView addSubview:view];
        _fansAllBgView = view;
        view;
    });
    
    ({ // - 粉丝团的背景的视图
        CGFloat wid = 43.5;
        CGFloat hei = 13;
        NSImageView *view = [[NSImageView alloc]initWithFrame:NSRectFromCGRect(CGRectMake(width - wid, (height - hei) / 2.0, wid, hei))];
        [bgView addSubview:view];
        _fansBgImageView = view;
    });

    CGFloat iconWH = 17;
    NSImageView *iconView = ({ // - 粉丝团的iocn的视图
        NSImageView *view = [[NSImageView alloc]initWithFrame:NSRectFromCGRect(CGRectMake(1, (height - iconWH) / 2, iconWH, iconWH))];
        [bgView addSubview:view];
        _fansIconImageView = view;
        view;
    });
    
    ({ // - 粉丝团的等级的视图
        NSImageView *view = [[NSImageView alloc]initWithFrame:iconView.frame];
        [bgView addSubview:view];
        _fansLvImageView = view;
    });
}

/** 选择的类型 */
- (void)setChooseType:(NSChooseType)chooseType{
    _chooseType = chooseType;

    // - 定义选中的view
    switch (self.chooseType) {
        case NSChooseTypeIcon:{
            self.selectedView = self.fansIconImageView;
            break;
        }
        case NSChooseTypeLv:{
            self.selectedView = self.fansLvImageView;
            break;
        }
        case NSChooseTypeBg:{
            self.selectedView = self.fansBgImageView;
            break;
        }
    }
    
    // - 设置位置坐标
    self.xTF.stringValue = @(self.selectedView.frame.origin.x).stringValue;
    self.yTF.stringValue = @(self.selectedView.frame.origin.y).stringValue;
    self.widthTF.stringValue = @(self.selectedView.frame.size.width).stringValue;
    self.heightTF.stringValue = @(self.selectedView.frame.size.height
    
    ).stringValue;

}

// - MARK: <-- 事件监听 -->
/** 选择icon */
-(void)chooseIconButtonClick{
    [self chooseAllowsMultipleSelection:NO completionHandler:^(NSArray<NSURL *> *URLs) {
        for (NSURL *url in URLs) {
            self.fansIconImageView.image = [[NSImage alloc]initWithContentsOfURL:url];
        }
    }];
}

/** 选择等级按钮 */
-(void)chooseLvButtonClick{
    [self chooseAllowsMultipleSelection:YES completionHandler:^(NSArray<NSURL *> *URLs) {
        for (NSURL *url in URLs) {
            self.fansLvImageView.image = [[NSImage alloc]initWithContentsOfURL:url];
        }
    }];
}

/** 选择背景按钮 */
-(void)chooseBgButtonClick{
    [self chooseAllowsMultipleSelection:NO completionHandler:^(NSArray<NSURL *> *URLs) {
        for (NSURL *url in URLs) {
            self.fansBgImageView.image = [[NSImage alloc]initWithContentsOfURL:url];
        }
    }];
}

/** 生成图片按钮 */
-(void)creatButtonClick{
    [self.fansAllBgView.superview setNeedsLayout:YES];
    [self saveImage];
}

/** 单击右键的菜单 */
- (void)menuItemClick:(NSMenuItem *)sender{
    if (sender.tag == 11) {
        self.chooseType = NSChooseTypeIcon;
    }else if(sender.tag == 12){
        self.chooseType = NSChooseTypeLv;
    }else if(sender.tag == 13){
        self.chooseType = NSChooseTypeBg;
    }
}

/** 保存图片到本地 */
- (void)saveImage {
    //视图的image
    NSImage *viewImage = [[NSImage alloc] initWithData:[self.fansAllBgView dataWithPDFInsideRect:self.fansAllBgView.bounds]];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[viewImage TIFFRepresentation]];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    NSData *imageData = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:imageProps];
  
    //文件路径
    NSString *filePath = @"~/Documents/232.png";
    if([imageData writeToFile:[filePath stringByExpandingTildeInPath] atomically:YES]){
        NSLog(@"xx");
    }
}

/** 打开选取窗口 */
-(void)chooseAllowsMultipleSelection:(BOOL)allowsMultipleSelection completionHandler:(void (^)(NSArray<NSURL *> *URLs))handler{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:allowsMultipleSelection];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"png"]];
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            !handler ? : handler(panel.URLs);
        }
    }];
}

// - MARK: <-- 代理 -->
- (void)controlTextDidChange:(NSNotification *)obj{
    NSTextField *tf = obj.object;
    float value = [[tf stringValue] floatValue];
    CGRect rect = NSRectToCGRect(self.selectedView.frame);
    if (tf == self.xTF) {
        rect.origin.x = value;
    }else if(self.yTF){
        rect.origin.y = value;
    }else if(self.widthTF){
        rect.size.width = value;
    }else if(self.heightTF){
        rect.size.height = value;
    }
    self.selectedView.frame = NSRectFromCGRect(rect);
}

@end

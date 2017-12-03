//
//  ViewController.m
//  UITtableViewCell
//
//  Created by lilx on 2017/11/30.
//  Copyright © 2017年 liluxin. All rights reserved.
//

#import "ViewController.h"
#import "TestTableViewCellXib.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define SCREEN_WIDTH              ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT             ([UIScreen mainScreen].bounds.size.height)

static NSString *const testCellID = @"testCellID";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** array */
@property (nonatomic, strong) NSMutableArray *titles;
/** 选择数组 */
@property (nonatomic, strong) NSMutableArray *selectedTitles;
@property(nonatomic, strong) UIButton *selectAllButtonn;//选择按钮
@property(nonatomic, strong) UIButton *deleteButtonn;//删除

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"历史播放";

    [self creatData];
    
    [self.view addSubview:self.tableView];
  
    [self setUpSubViews];
}


- (void)setUpSubViews {
    //选择按钮
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    selectedBtn.frame = CGRectMake(0, 0, 60, 30);
    [selectedBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithCustomView:selectedBtn];
    self.navigationItem.rightBarButtonItem =selectItem;
    
    //全选
    _selectAllButtonn = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectAllButtonn.frame = CGRectMake(0, 0, 60, 30);
    [_selectAllButtonn setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButtonn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_selectAllButtonn];
    self.navigationItem.leftBarButtonItem = leftItem;
    _selectAllButtonn.hidden = YES;
    
    
    //删除按钮
    _deleteButtonn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteButtonn.backgroundColor = [UIColor whiteColor];
    _deleteButtonn.hidden = YES;
    [_deleteButtonn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_deleteButtonn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButtonn.frame = CGRectMake(0, SCREEN_HEIGHT-44, self.view.frame.size.width, 44);
    [_deleteButtonn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteButtonn.enabled = NO;
    [self.view addSubview:_deleteButtonn];

}

//删除按钮点击事件
- (void)deleteClick:(UIButton *) button {
    if (!self.selectedTitles.count) return;
    if (self.tableView.editing) {
        [self.titles removeObjectsInArray:self.selectedTitles];
        [self.tableView reloadData];
    }
}

//选择按钮点击响应事件
- (void)selectedBtn:(UIButton *)button {
    
    _deleteButtonn.enabled = YES;
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        _selectAllButtonn.hidden = NO;
        _deleteButtonn.hidden = NO;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        //移除之前选中的内容
        if (self.selectedTitles.count > 0) {
            [self.selectedTitles removeAllObjects];
        }
    }
    else{
        _selectAllButtonn.hidden = YES;
        _deleteButtonn.hidden = YES;
        [button setTitle:@"选择" forState:UIControlStateNormal];
    }
    
}
//全选
- (void)selectAllBtnClick:(UIButton *)button {
    
    for (int i = 0; i < self.titles.count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self.selectedTitles addObjectsFromArray:self.titles];
    }
    NSLog(@"self.selectedTitles:%@", self.selectedTitles);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCellID];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
//    if (indexPath.row == 4) {
//        cell.contentView.backgroundColor = [UIColor blueColor];
//        cell.selectedBackgroundView = [[UIView alloc] init];
//        cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
//    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView.isEditing) {
        // 去掉选中时的cell背景颜色
        [self.selectedTitles addObject:self.titles[indexPath.row]];
        return;
    }
    
    // 不是编辑模式下才允许进入详情页面
    [tableView deselectRowAtIndexPath:indexPath animated:YES];/*
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCellID];
//    unsigned int count;
//    Ivar *ivarList = class_copyIvarList([cell class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivarList[i];
//        NSLog(@"%s", ivar_getName(ivar));
//    }
//    free(ivarList);
 
 */
}



//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCellID];
        if (tableView.editing) {
//            NSLog(@"编辑下cell Frame:%@",NSStringFromCGPoint(cell.contentView.frame.origin));
            NSLog(@"编辑下cell Frame:%@",cell.contentView);

        }
        else {
            NSLog(@"cell Frame:%@", NSStringFromCGPoint(cell.contentView.frame.origin));
        }
    }
    return YES;
}

//选择编辑的方式,按照选择的方式对表进行处理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
}

//选择你要对表进行处理的方式  默认是删除方式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



//取消选中时 将存放在self.selectedTitles中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    [self.selectedTitles removeObject:[self.titles objectAtIndex:indexPath.row]];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44;
        //cell
//        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TestTableViewCellXib class]) bundle:nil] forCellReuseIdentifier:testCellID];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCellID];
    }
    return _tableView;
}


- (void)creatData {
    for (int i = 0; i < 20; i++) {
        NSString *title = [NSString stringWithFormat:@"lucy%d",i];
        [self.titles addObject:title];
    }
}

- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)selectedTitles {
    if (!_selectedTitles) {
        _selectedTitles = [NSMutableArray array];
    }
    return _selectedTitles;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

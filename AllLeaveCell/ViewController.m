//
//  ViewController.m
//  AllLeaveCell
//
//  Created by 王云晨 on 2017/2/13.
//  Copyright © 2017年 王云晨. All rights reserved.
//

#import "ViewController.h"
#import "Node.h"
#import "UIControl+RYButton.h"
#define X0COLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]
#define kGlobal ([Global sharedGlobal])
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *taview;
@property (nonatomic , strong) NSMutableArray *data;//全量数据
@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）
@property (nonatomic, strong) NSMutableArray *arr_number;//存放随机数
@property int num;//随机数；
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    _arr_number = [NSMutableArray array];
    _data = [[NSMutableArray alloc]init];
    Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:1 name:@"中国" depth:0 expand:YES];

    NSArray *data = [NSArray arrayWithObjects:country1,nil];
    [_data addObjectsFromArray:data];

    _tempData = [self createTempData:data];
    
    // Do any additional setup after loading the view.
}
/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initview{
    
    self.taview = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.taview];
    self.taview.delegate = self;
    self.taview.dataSource = self;
    
}


#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *NODE_CELL_ID = @"node_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];

    Node *node = [_tempData objectAtIndex:indexPath.row];
    
    
    // cell有缩进的方法
    //    cell.indentationLevel = node.depth; // 缩进级别
    //    cell.indentationWidth = 30.f; // 每个缩进级别的距离
    
    //添加cell的button
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-50, 10, 20, 20)];
    [button setImage:[UIImage imageNamed:@"ic_Edit"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(AddCell:) forControlEvents:UIControlEventTouchDown];
    button.ry_Node = node;
    
    
    //删除cell的button
    UIButton *delatebutton = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-20, 10, 20, 20)];
    [delatebutton setImage:[UIImage imageNamed:@"ic_delet"] forState:UIControlStateNormal];
    [delatebutton addTarget:self action:@selector(delate:) forControlEvents:UIControlEventTouchDown];
    delatebutton.ry_Node = node;
    
    [cell addSubview:delatebutton];
    [cell addSubview:button];
    
    //cell的样式 可自定义
    if (node.depth == 0) {
        
        button.frame =CGRectMake(cell.frame.size.width-20, 20, 20, 20);
        delatebutton.hidden = YES;
        cell.backgroundColor = X0COLOR(0x558fd3);
        cell.textLabel.text = node.name;
    }
    
    if (node.depth>0) {
        if (node.depth == 1) {
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
            view.image = [UIImage imageNamed:@"ic_level2"];
            [cell addSubview:view];
        }
        else if(node.depth == 2){
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
            view.image = [UIImage imageNamed:@"ic_level3"];
            [cell addSubview:view];
        }
        else
        {
            UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
            view.image = [UIImage imageNamed:@"ic_level4"];
            [cell addSubview:view];
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 44)];
        label.text = node.name;
        [cell addSubview:label];
        
        //更改每层cell的颜色，可根据自己喜好修改
        int a  = 55 -10*node.depth;
        int b = 95 + 10*node.depth;
        int c = 133+10*node.depth;
        cell.backgroundColor = [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1];
        
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    else{
        return 44;
    }
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //先修改数据源
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.parentId == parentNode.nodeId) {
            node.expand = !node.expand;
            if (node.expand) {
                [_tempData insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentNode];
                break;
            }
        }
    }
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        [self.taview insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.taview deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

#pragma 产生随机数
-(void)creatnum{

    
    int i = arc4random() % 100 ;
    NSString *str = [NSString stringWithFormat:@"%d",i];
    NSLog(@"%@",str);
    
    BOOL isbool = [_arr_number containsObject:str];
    
    
    if (isbool) {
        [self creatnum];
    }
    else
    {
        [_arr_number addObject:str];
        self.num = i;
        
    }
    
}

#pragma 添加cell
-(void)AddCell:(id)sender {
    //do something here
    UIButton *button = sender;
    UITableViewCell *cell = (UITableViewCell *)[button superview];
    NSIndexPath *index = [self.taview indexPathForCell:cell];
    Node *node = button.ry_Node;
    [self creatnum];
    //添加的节点信息
    Node *node1 = [[Node alloc] initWithParentId:node.nodeId nodeId:node.nodeId*100+self.num  name:@"北京" depth:node.depth+1 expand:YES];
    [_data addObject:node1];
    NSUInteger startPosition = index.row+1;
    NSUInteger endPosition = startPosition;
    
    for (int i=0; i<_data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if ([node isEqual:button.ry_Node]) {
            node.expand = YES;
            break;
        }
        
        
    }
    [_tempData insertObject:node1 atIndex:endPosition];
    endPosition++;
    
    
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    [self.taview insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma 删除cell
-(void)delate:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    UITableViewCell *cell = (UITableViewCell *)[button superview];
    NSIndexPath *index = [self.taview indexPathForCell:cell];
    [_data removeObject:button.ry_Node];
    
    
    NSUInteger startPosition = index.row;
    NSUInteger endPosition = startPosition;
    endPosition= [self removeAllNodesAtParentNodes:button.ry_Node];
    
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    if (startPosition == endPosition) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:endPosition inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    
    [self.taview deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    
}

-(NSUInteger)removeAllNodesAtParentNodes : (Node *)parentNode {
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition, endPosition-startPosition)];
    }
    if (endPosition == startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition, 1)];
    }
    return endPosition;
}


@end

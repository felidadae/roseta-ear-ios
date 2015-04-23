
typedef void(^DrawView_DrawBlock)(UIView* v,CGContextRef context);

@interface DrawView : UIView
@property (nonatomic,copy) DrawView_DrawBlock drawBlock;
@end
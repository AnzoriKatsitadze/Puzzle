

//
//  GameScene.m
//  Puzzle
//
//  Created by anzori  on 10/3/14.
//  Copyright (c) 2014 anzori . All rights reserved.
//

#define CAMERA_TRANSFORM

#define WIDTH_IPAD 1024
#define WIDTH_IPHONE_5 568
#define WIDTH_IPHONE_4 480
#define HEIGHT_IPAD 768
#define HEIGHT_IPHONE 320

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//width is height!
#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.width == WIDTH_IPHONE_5 )
#define IS_IPHONE_4 ( [ [ UIScreen mainScreen ] bounds ].size.width == WIDTH_IPHONE_4 )

#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen]bounds].size.width - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.width - (double)736) < DBL_EPSILON)

#import "GameScene.h"
#import "UIImage+Crop.h"
#import "ImportImageScene.h"
#import "PuzzleSprite.h"
#import "MenuScene.h"
#import "AppDelegate.h"

@implementation GameScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        cropNodesArray      = [[NSMutableArray alloc] init];
        PuzzlsArray         = [[NSMutableArray alloc] init];
        animalsArray        = [[NSMutableArray alloc] init];
        puzzlesSpritesArray = [[NSMutableArray alloc] init];
        
        initialPositionsArray     = [[NSMutableArray alloc] init];
        destinationPositionsArray = [[NSMutableArray alloc] init];
        
        centerPozitionX = [[UIScreen mainScreen] bounds].size.width/2;
        centerPozitionY = [[UIScreen mainScreen] bounds].size.height/2;
        
        uiscreenWidth = [[UIScreen mainScreen] bounds].size.width;
        uiscreenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        if (centerPozitionX<centerPozitionY)
        {
            int savedPos = centerPozitionX;
            centerPozitionX = centerPozitionY;
            centerPozitionY= savedPos;
            
            float savedDimension = uiscreenWidth;
            uiscreenWidth=uiscreenHeight;
            uiscreenHeight=savedDimension;
        }
        
        
        zPositionCounter = 0;
        setPuzzlesCounter = 0;
        
        [self loadHomeButton];
        
        isIphone5 = [self isHdRes];
        
        [self loadBackground];
        
        if (IS_IPAD)
        {
            self.scaleOut = 0.75;
            self.scaleForSelectedImg = 1.0;
        }
        else
        {
            if (isIphone5)
            {
                self.scaleForSelectedImg = 1.0;
                if (IS_IPHONE_6) {
                    self.scaleForSelectedImg=1.18;
                }
            }
            else
            {
                self.scaleForSelectedImg = 1.0;
            }
        }
        
        self.saveAnimalIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"saveAnimalIndex"];
        
        PuzzlsArray = [self getPazzlsArray];
        
        for (int i = 0; i<PuzzlsArray.count; i++)
        {
            [animalsArray addObject:PuzzlsArray[i][@"name"]];
        
        }
        if (IS_IPAD)
        {
            [animalsArray removeAllObjects];
            for (int i = 0; i<PuzzlsArray.count; i++)
            {
                [animalsArray addObject:PuzzlsArray[i][@"name_Pad"]];
            }
        }
        self.animalName = [animalsArray objectAtIndex:self.saveAnimalIndex];
        
        NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"];
        
        BOOL isselectedTakePicture = [[NSUserDefaults standardUserDefaults] boolForKey:@"iseSelectedTakePicture"];
        if (isselectedTakePicture == NO)
        {
            if ([savedValue isEqualToString:@"easyBoard"])
            {
                addOriginAndblackPTimer = [NSTimer scheduledTimerWithTimeInterval:0
                                                                           target:self
                                                                         selector:@selector(addNinePuzzlesModel)
                                                                         userInfo:nil repeats:NO];
                
            }
            
            if ([savedValue isEqualToString:@"hardBoard"])
            {
                addOriginAndblackPTimerForSixTeen = [NSTimer scheduledTimerWithTimeInterval:0
                                                                                     target:self
                                                                                   selector:@selector(addSixteenPuzzlesModel)
                                                                                   userInfo:nil repeats:NO];
            }
        }
    }
    return self;
}

-(void)loadHomeButton
{
    if (IS_IPAD)
    {
        homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home button.png"];
        homeButton.xScale = homeButton.yScale = 0.35;
        homeButton.position = CGPointMake(50, 730);
        [self addChild:homeButton];
        homeButton.name = @"homeButton";
    }
    else
    {
        homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home button 960.png"];
        homeButton.xScale = homeButton.yScale = 0.5;
        homeButton.position = CGPointMake(20, 300);
        if (IS_IPHONE_6) {
            homeButton.position = CGPointMake(20, 350);
        }
        [self addChild:homeButton];
        homeButton.name = @"homeButton";
    }
}

- (void) useImage
{
    SKTexture *texture = [SKTexture textureWithImage:_teakeImage];
    saveTextureForimportImg = texture;
    originalImage = [SKSpriteNode spriteNodeWithTexture:texture];
    originalImage.xScale = originalImage.yScale = 0.5;
    if (IS_IPAD) {
        originalImage.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    }else{
    originalImage.position = CGPointMake(158, 162);
        if (IS_IPHONE_6) {
            originalImage.position = CGPointMake(180, centerPozitionY);
            originalImage.xScale = 0.586;
            originalImage.yScale = 0.586;
        }
    }
    originalImage.zPosition = 1;
    originalImage.name = @"aaaaaaa";
    [self addChild:originalImage];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"preferenceName"];
    
    if (IS_IPAD)
    {
        if ([savedValue isEqualToString:@"easyBoard"])
        {
            [self woundingPuzzleForIpad:_teakeImage];
            addImageConturTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                   target:self
                                                                 selector:@selector(addImageCountur)
                                                                 userInfo:nil repeats:NO];
        }
        if ([savedValue isEqualToString:@"hardBoard"])
        {
            [self woundingSixteenPuzzleForPad:_teakeImage];
            addImageConturTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                   target:self
                                                                 selector:@selector(addImageCounturSixteen)
                                                                 userInfo:nil repeats:NO];
        }
        [self loadBackground];
        puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                            target:self
                                                          selector:@selector(movePuzzles)
                                                          userInfo:nil repeats:NO];
    }
    else
    {
        if ([savedValue isEqualToString:@"easyBoard"])
        {
            [self woundingPuzzle:_teakeImage];
            addImageConturTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                   target:self
                                                                 selector:@selector(addImageCountur)
                                                                 userInfo:nil repeats:NO];
        }
        if ([savedValue isEqualToString:@"hardBoard"])
        {
            [self woundingSixteenPuzzle:_teakeImage];
            addImageConturTimer = [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                   target:self
                                                                 selector:@selector(addImageCounturSixteen)
                                                                 userInfo:nil repeats:NO];
        }
        [self loadBackground];
        puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                            target:self
                                                          selector:@selector(movePuzzles)
                                                          userInfo:nil repeats:NO];
    }
    
 
}

- (BOOL) isHdRes
{
    // iphone 5/5c/5s/6/6s etc.
    float ratio = 16.0f / 9.0f, EPS = 5e-3f;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float maxS = MAX(screenSize.width, screenSize.height), minS = MIN(screenSize.width, screenSize.height);
    float screenRatio = maxS / minS;
    if(fabs(screenRatio - ratio) <= EPS)
        return true;
    return false;
}

-(void) addSixteenPuzzlesModel
{
    [self getSixTeenPointsFropPlists];
    
    if (IS_IPHONE)
    {
        addSixteenPuzzleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addSixteenMaskPuzzle) userInfo:nil repeats:NO];
        [self addOriginalAndBlackPicturesForIphone];
    }
    else
    {
        addSixteenPuzzleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addSixteenmaskPuzzleForIpad) userInfo:nil repeats:NO];
        [self addOriginalAndBlackPicturesForPad];
    }
    
    [addOriginAndblackPTimer invalidate];
    addOriginAndblackPTimer = nil;
}

-(void) addNinePuzzlesModel
{
    [self getPointsFropPlists];
    
    if (IS_IPHONE)
    {
        [self addOriginalAndBlackPicturesForIphone];
        addMaskTime = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target: self
                                                     selector:@selector(addMaskPuzzle)
                                                     userInfo: nil repeats:NO];
    }
    else
    {
        [self addOriginalAndBlackPicturesForPad];
        addMaskTime = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target: self
                                                     selector:@selector(addMaskPuzzleForIpad)
                                                     userInfo: nil repeats:NO];
    }

    
    
    [addOriginAndblackPTimerForSixTeen invalidate];
    addOriginAndblackPTimerForSixTeen = nil;
}

-(void) addOriginalAndBlackPicturesForIphone
{
    originalImage = [SKSpriteNode spriteNodeWithImageNamed:self.animalName];
    originalImage.position = CGPointMake(158, 162);
    originalImage.xScale = originalImage.yScale = 0.5;
    [self addChild:originalImage];
    
    if (IS_IPHONE_6) {
        originalImage.position = CGPointMake(180, centerPozitionY);
        originalImage.xScale = 0.586;
        originalImage.yScale = 0.586;
    }
}

-(void) addOriginalAndBlackPicturesForPad
{
    originalImage = [SKSpriteNode spriteNodeWithImageNamed:self.animalName];
    originalImage.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    originalImage.xScale = originalImage.yScale = 0.5;
    [self addChild:originalImage];
}

-(void)getPointsFropPlists
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PuzzlesPoints" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    if (IS_IPAD)
    {
        screenResolution = @"iPad";
    }
    else
    {
        if (isIphone5)
        {
            screenResolution = @"r4";
            if (IS_IPHONE_6) {
                screenResolution = @"r4.5";
            }
        }
        else
        {
            screenResolution = @"r3.5";
        }
    }
    destinationPosition = array[0][screenResolution][@"destinationPosition"];
    
    
    CGPoint point = CGPointMake([destinationPosition[@"x"] intValue], [destinationPosition[@"y"] intValue]);
    [destinationPositionsArray addObject:[NSValue valueWithCGPoint:point]];
   // CGPoint positiion = [[destinationPositionsArray objectAtIndex:0] CGPointValue];

    for (int i=0; i<array.count; i++)
    {
        NSDictionary *initialPosition = array[i][screenResolution][@"initialPosition"];
        CGPoint initialPoint = CGPointMake([initialPosition[@"x"] intValue], [initialPosition[@"y"]intValue]);
        [initialPositionsArray addObject:[NSValue valueWithCGPoint:initialPoint]];
    }
}

-(void)getSixTeenPointsFropPlists
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SixteenPuzzlesPoint" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    if (IS_IPAD)
    {
        screenResolution = @"iPad";
    }
    else
    {
        if (isIphone5)
        {
            screenResolution = @"r4";
            if (IS_IPHONE_6) {
                screenResolution = @"r4.5";
            }
        }
        else
        {
            screenResolution = @"r3.5";
        }
    }
    destinationPosition = array[0][screenResolution][@"destinationPosition"];
    
    CGPoint point = CGPointMake([destinationPosition[@"x"] intValue], [destinationPosition[@"y"] intValue]);
    [destinationPositionsArray addObject:[NSValue valueWithCGPoint:point]];
   // CGPoint positiion = [[destinationPositionsArray objectAtIndex:0] CGPointValue];
    
    for (int i=0; i<array.count; i++)
    {
        NSDictionary *initialPosition = array[i][screenResolution][@"initialPosition"];
        CGPoint initialPoint = CGPointMake([initialPosition[@"x"] intValue], [initialPosition[@"y"]intValue]);
        [initialPositionsArray addObject:[NSValue valueWithCGPoint:initialPoint]];
    }
}

- (SKSpriteNode *) maskForindex: (int) index
{
    NSString *easyMask_ = @"easyMask_";
    
    NSString *name = [NSString stringWithFormat:@"%d.png", index];
    name = [easyMask_ stringByAppendingString:name];
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithImageNamed:name];
    mask.xScale = mask.yScale = 0.2;
    mask.position = CGPointMake(0, 0);
    return mask;
}

-(SKSpriteNode *) sixTeenMaskForIndex:(int) index
{
    NSString *easyMask_ = @"mask_";
    
    NSString *name = [NSString stringWithFormat:@"%d.png", index];
    name = [easyMask_ stringByAppendingString:name];
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithImageNamed:name];
    mask.xScale = mask.yScale = 0.2;
    mask.position = CGPointMake(0, 0);
    return mask;
}

-(NSString *) getrandAnimalName
{
    
    NSString * animalName = [animalsArray objectAtIndex:0];
    
    return animalName;
}

-(void) shufflingArray:(NSMutableArray *)array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (NSMutableArray *) getPazzlsArray
{
    NSString *arrayName = [NSString stringWithFormat:@"OriginAnimals"];
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:arrayName ofType:@"plist"]];
    return  [[NSMutableArray alloc] initWithArray:array];
}

- (void) updateZpositions:(PuzzleSprite *) sprite{
    int max = 9;
    for (SKSpriteNode *spriteNode in self.children) {
        if (spriteNode != sprite) {
            if (max < spriteNode.zPosition) {
                max = spriteNode.zPosition;
            }
        }
    }
    sprite.zPosition = max + 1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point      = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    NSLog(@"%@", node.name);
    if ([node.name isEqualToString:@"homeButton"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"iseSelectedTakePicture"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SKView * skView = (SKView *)self.view;
        MenuScene *menuScene = [MenuScene sceneWithSize:skView.bounds.size];
        menuScene.scaleMode = SKSceneScaleModeAspectFill;
        [skView presentScene:menuScene ];
    }
    //
}


-(void)movePuzzles
{
    [originImgContur removeFromParent];
    [originImgContur removeAllActions];
    
    [self addBlackAreaImage];
    for (int i=0; i<cropNodesArray.count; i++)
    {
        PuzzleSprite *sprite = [cropNodesArray objectAtIndex:i];
        sprite.zPosition = 3;
        SKAction *moveUp = [SKAction moveTo:[[initialPositionsArray objectAtIndex:i] CGPointValue] duration:0.3];
        [sprite runAction:moveUp completion:^{
            
            sprite.touchArrea = CGRectMake(sprite.position.x - sprite.touchArrea.size.width/2,
                                           sprite.position.y - sprite.touchArrea.size.height/2,
                                           sprite.touchArrea.size.width,
                                           sprite.touchArrea.size.height);
            
        }];
        
        if (IS_IPHONE)
        {
            SKAction *scaleAction = [SKAction scaleTo:self.scaleForSelectedImg duration:0.3];
            [sprite runAction:scaleAction];
        }
        
        if (IS_IPAD)
        {
            SKAction *scaleAction = [SKAction scaleTo:self.scaleOut duration:0.3];
            [sprite runAction:scaleAction];
        }
        
        [self rotateByAngle:sprite];
    }
    
    [puzzlesMoveTimer invalidate];
    puzzlesMoveTimer = nil;
}

-(void) addBlackAreaImage
{
    if (IS_IPAD)
    {
        blackArea = [SKSpriteNode spriteNodeWithImageNamed:@"shavi pedi.png"];
        blackArea.position = CGPointMake(0,0);
        [originalImage addChild:blackArea];
        blackArea.xScale = blackArea.yScale = 1;
        blackArea.zPosition = 2;
        blackArea.name = @"blackkkk";
    }
    else
    {
        blackArea = [SKSpriteNode spriteNodeWithImageNamed:@"shavi 497.png"];
        blackArea.position = CGPointMake(0,0);
        [originalImage addChild:blackArea];
        blackArea.xScale = blackArea.yScale = 1;
        blackArea.zPosition = 2;
        blackArea.name = @"blackkkk";
    }
}

-(void)woundingPuzzleForIpad:(UIImage *) cropImage
{
    [self getPointsFropPlists];
    
    CGRect cropRect1 = CGRectMake(-140, -140, cropImage.size.width/3+155, cropImage.size.height/3+157);
    
    CGRect cropRect2 = CGRectMake(305, -97, cropImage.size.width/2, cropImage.size.height/2);
    
    CGRect cropRect3 = CGRectMake(797, -190, cropImage.size.width/2, cropImage.size.height/2);
    
    CGRect cropRect4 = CGRectMake(-105, 310, cropImage.size.width/2, cropImage.size.height/2);
    
    CGRect cropRect5 = CGRectMake(305, 308, cropImage.size.width/2, cropImage.size.height/2);
    
    CGRect cropRect6 = CGRectMake(713, 310, cropImage.size.height/2, cropImage.size.width/2);
    
    CGRect cropRect7 = CGRectMake(-191, 802, cropImage.size.height/2, cropImage.size.width/2);
    
    CGRect cropRect8 = CGRectMake(305, 710, cropImage.size.height/2, cropImage.size.width/2);
    
    CGRect cropRect9 = CGRectMake(797, 802, cropImage.size.height/2, cropImage.size.width/2);
    
    UIImage *image1 = [cropImage cropeImageWithFrame:cropRect1];
    UIImage *image2 = [cropImage cropeImageWithFrame:cropRect2];
    UIImage *image3 = [cropImage cropeImageWithFrame:cropRect3];
    UIImage *image4 = [cropImage cropeImageWithFrame:cropRect4];
    UIImage *image5 = [cropImage cropeImageWithFrame:cropRect5];
    UIImage *image6 = [cropImage cropeImageWithFrame:cropRect6];
    UIImage *image7 = [cropImage cropeImageWithFrame:cropRect7];
    UIImage *image8 = [cropImage cropeImageWithFrame:cropRect8];
    UIImage *image9 = [cropImage cropeImageWithFrame:cropRect9];
    
    SKTexture *textur1 = [SKTexture textureWithImage:image1];
    SKTexture *textur2 = [SKTexture textureWithImage:image2];
    SKTexture *textur3 = [SKTexture textureWithImage:image3];
    SKTexture *textur4 = [SKTexture textureWithImage:image4];
    SKTexture *textur5 = [SKTexture textureWithImage:image5];
    SKTexture *textur6 = [SKTexture textureWithImage:image6];
    SKTexture *textur7 = [SKTexture textureWithImage:image7];
    SKTexture *textur8 = [SKTexture textureWithImage:image8];
    SKTexture *textur9 = [SKTexture textureWithImage:image9];
    
    SKSpriteNode *pic1 = [SKSpriteNode spriteNodeWithTexture:textur1];
    pic1.xScale = pic1.yScale = 0.5;
    
    SKSpriteNode *pic2 = [SKSpriteNode spriteNodeWithTexture:textur2];
    pic2.xScale = pic2.yScale = 0.5;
    
    SKSpriteNode *pic3 = [SKSpriteNode spriteNodeWithTexture:textur3];
    pic3.xScale = pic3.yScale = 0.5;
    
    SKSpriteNode *pic4 = [SKSpriteNode spriteNodeWithTexture:textur4];
    pic4.xScale = pic4.yScale = 0.5;
    
    SKSpriteNode *pic5 = [SKSpriteNode spriteNodeWithTexture:textur5];
    pic5.xScale = pic5.yScale = 0.5;
    
    SKSpriteNode *pic6 = [SKSpriteNode spriteNodeWithTexture:textur6];
    pic6.xScale = pic6.yScale = 0.5;
    
    SKSpriteNode *pic7 = [SKSpriteNode spriteNodeWithTexture:textur7];
    pic7.xScale = pic7.yScale = 0.5;
    
    SKSpriteNode *pic8 = [SKSpriteNode spriteNodeWithTexture:textur8];
    pic8.xScale = pic8.yScale = 0.5;
    
    SKSpriteNode *pic9 = [SKSpriteNode spriteNodeWithTexture:textur9];
    pic9.xScale = pic9.yScale = 0.5;
    
    
    SKSpriteNode *mask1 = [self maskForindex:1];
    mask1.xScale = mask1.yScale = 0.5;
    
    SKSpriteNode *mask2 = [self maskForindex:2];
    mask2.xScale = mask2.yScale = 0.5;
    
    SKSpriteNode *mask3 = [self maskForindex:3];
    mask3.xScale = mask3.yScale = 0.5;
    
    SKSpriteNode *mask4 = [self maskForindex:4];
    mask4.xScale = mask4.yScale = 0.5;
    
    SKSpriteNode *mask5 = [self maskForindex:5];
    mask5.xScale = mask5.yScale = 0.5;
    
    SKSpriteNode *mask6 = [self maskForindex:6];
    mask6.xScale = mask6.yScale = 0.5;
    
    SKSpriteNode *mask7 = [self maskForindex:7];
    mask7.xScale = mask7.yScale = 0.5;
    
    SKSpriteNode *mask8 = [self maskForindex:8];
    mask8.xScale = mask8.yScale = 0.5;
    
    SKSpriteNode *mask9 = [self maskForindex:9];
    mask9.xScale = mask9.yScale = 0.5;
    
    
    SKCropNode *scropNode1 = [SKCropNode node];
    [scropNode1 addChild:pic1];
    [scropNode1 setMaskNode:mask1];
    
    SKCropNode *scropNode2 = [SKCropNode node];
    [scropNode2 addChild:pic2];
    [scropNode2 setMaskNode:mask2];
    
    SKCropNode *scropNode3 = [SKCropNode node];
    [scropNode3 addChild:pic3];
    [scropNode3 setMaskNode:mask3];
    
    SKCropNode *scropNode4 = [SKCropNode node];
    [scropNode4 addChild:pic4];
    [scropNode4 setMaskNode:mask4];
    
    SKCropNode *scropNode5 = [SKCropNode node];
    [scropNode5 addChild:pic5];
    [scropNode5 setMaskNode:mask5];
    
    SKCropNode *scropNode6 = [SKCropNode node];
    [scropNode6 addChild:pic6];
    [scropNode6 setMaskNode:mask6];
    
    SKCropNode *scropNode7 = [SKCropNode node];
    [scropNode7 addChild:pic7];
    [scropNode7 setMaskNode:mask7];
    
    SKCropNode *scropNode8 = [SKCropNode node];
    [scropNode8 addChild:pic8];
    [scropNode8 setMaskNode:mask8];
    
    SKCropNode *scropNode9 = [SKCropNode node];
    [scropNode9 addChild:pic9];
    [scropNode9 setMaskNode:mask9];
    
    
    PuzzleSprite *sprite1 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic1.size];
    sprite1.gameScene = self;
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(135, 585);
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, sprite1.position.y - sprite1.frame.size.height/2, 200, 200);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = YES;
    sprite1.zPosition = 1;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    sprite2.gameScene = self;
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(335, 562);
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, sprite2.position.y - sprite2.frame.size.height/2, 200, 200);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = YES;
    sprite2.zPosition = 1;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    sprite3.gameScene = self;
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(537, 585);
    sprite3.touchArrea = CGRectMake(sprite3.position.x-sprite3.frame.size.width/2, sprite3.position.y-sprite3.frame.size.height/2, 200, 200);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = YES;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    sprite4.gameScene = self;
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(157, 385);
    sprite4.touchArrea = CGRectMake(sprite4.position.x-sprite4.frame.size.width/2, sprite4.position.y-sprite4.frame.size.height/2, 200, 200);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = YES;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic5.size];
    sprite5.gameScene = self;
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(335, 384);
    sprite5.touchArrea = CGRectMake(sprite5.position.x-sprite5.frame.size.width/2, sprite5.position.y-sprite5.frame.size.height/2, 200, 200);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = YES;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
    
    PuzzleSprite *sprite6 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    sprite6.gameScene = self;
    [sprite6 addChild:scropNode6];
    sprite6.position = CGPointMake(515, 383);
    sprite6.touchArrea = CGRectMake(sprite6.position.x-sprite6.frame.size.width/2, sprite6.position.y-sprite6.frame.size.height/2, 200, 200);
    [self addChild:sprite6];
    sprite6.userInteractionEnabled = YES;
    sprite6.destinationPosition = sprite6.position;
    [cropNodesArray addObject:sprite6];
    
    PuzzleSprite *sprite7 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic7.size];
    sprite7.gameScene = self;
    [sprite7 addChild:scropNode7];
    sprite7.position = CGPointMake(136, 183);
    sprite7.touchArrea = CGRectMake(sprite7.position.x-sprite7.frame.size.width/2, sprite7.position.y-sprite7.frame.size.height/2, 200, 200);
    [self addChild:sprite7];
    sprite7.userInteractionEnabled = YES;
    sprite7.destinationPosition = sprite7.position;
    [cropNodesArray addObject:sprite7];
    
    PuzzleSprite *sprite8 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic8.size];
    sprite8.gameScene = self;
    [sprite8 addChild:scropNode8];
    sprite8.position = CGPointMake(336, 205);
    sprite8.touchArrea = CGRectMake(sprite8.position.x-sprite8.frame.size.width/2, sprite8.position.y-sprite8.frame.size.height/2, 200, 200);
    [self addChild:sprite8];
    sprite8.userInteractionEnabled = YES;
    sprite8.destinationPosition = sprite8.position;
    [cropNodesArray addObject:sprite8];
    
    PuzzleSprite *sprite9 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic9.size];
    sprite9.gameScene = self;
    [sprite9 addChild:scropNode9];
    sprite9.position = CGPointMake(537, 182);
    sprite9.touchArrea = CGRectMake(sprite9.position.x-sprite9.frame.size.width/2, sprite9.position.y-sprite9.frame.size.height/2, 200, 200);
    [self addChild:sprite9];
    sprite9.userInteractionEnabled = YES;
    sprite9.destinationPosition = sprite9.position;
    [cropNodesArray addObject:sprite9];

}

-(void)originalImageContur
{
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi_Pad"];
    originImgContur.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    originImgContur.xScale = originImgContur.yScale = 0.5;
    [self addChild:originImgContur];
    originImgContur.zPosition = 2;
}

-(void)addMaskPuzzleForIpad
{
    [self originalImageContur];
    
    UIImage *cropImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self.animalName stringByDeletingPathExtension] ofType:self.animalName.pathExtension]];
    
    [self woundingPuzzleForIpad:cropImage];
    
    [addMaskTime invalidate];
    addMaskTime = nil;
    //
    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
}

-(void) addImageCountur
{
    if (IS_IPAD) {
        originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@""];
        originImgContur.position = CGPointMake(centerPozitionX-175, centerPozitionY);
        [self addChild:originImgContur];
        originImgContur.xScale = originImgContur.yScale = 0.5;
        originImgContur.zPosition = 2;
    }else
    {
        originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi.png"];
        originImgContur.position = CGPointMake(158, 163);
         originImgContur.xScale = originImgContur.yScale = 0.5;
        if (IS_IPHONE_6) {
            originImgContur.position = CGPointMake(180, centerPozitionY);
            originImgContur.xScale = originImgContur.yScale = 0.59;
        }
        [self addChild:originImgContur];
        originImgContur.zPosition = 2;
    }
    [addImageConturTimer invalidate];
    addImageConturTimer=nil;
}

-(void) addImageCounturSixteen
{
    if (IS_IPAD)
    {
        originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazliskontur_16.png"];
        originImgContur.position = CGPointMake(centerPozitionX-175, centerPozitionY);
        [self addChild:originImgContur];
        originImgContur.xScale = originImgContur.yScale = 0.5;
        originImgContur.zPosition = 2;
    }
    else
    {
        originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi2 small.png"];
        originImgContur.position = CGPointMake(158, 163);
        originImgContur.xScale = originImgContur.yScale = 0.5;
        if (IS_IPHONE_6) {
            originImgContur.position = CGPointMake(180, centerPozitionY);
            originImgContur.xScale = originImgContur.yScale = 0.586;
        }
        [self addChild:originImgContur];
        originImgContur.zPosition = 2;
    }
    [addImageConturTimer invalidate];
    addImageConturTimer=nil;
}

-(void)addMaskPuzzle
{
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi.png"];
    originImgContur.position = CGPointMake(158, 163);
    originImgContur.xScale = originImgContur.yScale = 0.5;
    
    [self addChild:originImgContur];
    if (IS_IPHONE_6) {
        originImgContur.position = CGPointMake(180, centerPozitionY);
        originImgContur.xScale = originImgContur.yScale = 0.59;
    }
    originImgContur.zPosition = 2;
    //
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self.animalName stringByDeletingPathExtension] ofType:self.animalName.pathExtension]];
    
    
    [self woundingPuzzle:image];

    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
    [addMaskTime invalidate];
    addMaskTime = nil;
}

-(void) addSixteenmaskPuzzleForIpad
{
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazliskontur_16.png"];
    originImgContur.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    [self addChild:originImgContur];
    originImgContur.xScale = originImgContur.yScale = 0.5;
    originImgContur.zPosition = 2;
    
    UIImage *cropImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self.animalName stringByDeletingPathExtension] ofType:self.animalName.pathExtension]];
    
    [self woundingSixteenPuzzleForPad:cropImage];
    
    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
    [addSixteenPuzzleTimer invalidate];
    addSixteenPuzzleTimer = nil;
}

-(void) woundingSixteenPuzzleForPad:(UIImage *) image
{
    [self getSixTeenPointsFropPlists];
    
    CGRect cropRect1 = CGRectMake(0, -10, image.size.width/3+3, image.size.height/4);
    CGRect cropRect2 = CGRectMake(280, -10, image.size.width/4+50, image.size.height/3);
    CGRect cropRect3 = CGRectMake(460, -110, image.size.width/2, image.size.height/3);
    CGRect cropRect4 = CGRectMake(913, -10, image.size.width/3, image.size.height/3);
    CGRect cropRect5 = CGRectMake(-95, 135, image.size.width/3, image.size.height/2);
    CGRect cropRect6 = CGRectMake(151, 236, image.size.width/2, image.size.height/3);
    CGRect cropRect7 = CGRectMake(565, 139, image.size.width/3, image.size.height/2);
    CGRect cropRect8 = CGRectMake(820, 239, image.size.width/3, image.size.height/3);
    CGRect cropRect9 = CGRectMake(0, 550, image.size.width/3, image.size.height/3);
    CGRect cropRect10 = CGRectMake(254, 450, image.size.width/3, image.size.height/2);
    CGRect cropRect11 = CGRectMake(463, 552, image.size.width/2, image.size.height/3);
    CGRect cropRect12 = CGRectMake(918, 450, image.size.width/3, image.size.height/2);
    CGRect cropRect13 = CGRectMake(-95, 805, image.size.width/3, image.size.height/3+30);
    CGRect cropRect14 = CGRectMake(153, 900, image.size.width/2, image.size.height/3);
    CGRect cropRect15 = CGRectMake(565, 805, image.size.width/3, image.size.height/3+30);
    CGRect cropRect16 = CGRectMake(814, 906, image.size.width/3+30, image.size.height/3);
    
    UIImage *image1 = [image cropeImageWithFrame:cropRect1];
    UIImage *image2 = [image cropeImageWithFrame:cropRect2];
    UIImage *image3 = [image cropeImageWithFrame:cropRect3];
    UIImage *image4 = [image cropeImageWithFrame:cropRect4];
    UIImage *image5 = [image cropeImageWithFrame:cropRect5];
    UIImage *image6 = [image cropeImageWithFrame:cropRect6];
    UIImage *image7 = [image cropeImageWithFrame:cropRect7];
    UIImage *image8 = [image cropeImageWithFrame:cropRect8];
    UIImage *image9 = [image cropeImageWithFrame:cropRect9];
    UIImage *image10 = [image cropeImageWithFrame:cropRect10];
    UIImage *image11 = [image cropeImageWithFrame:cropRect11];
    UIImage *image12 = [image cropeImageWithFrame:cropRect12];
    UIImage *image13 = [image cropeImageWithFrame:cropRect13];
    UIImage *image14 = [image cropeImageWithFrame:cropRect14];
    UIImage *image15 = [image cropeImageWithFrame:cropRect15];
    UIImage *image16 = [image cropeImageWithFrame:cropRect16];
    
    SKTexture *textur1 = [SKTexture textureWithImage:image1];
    SKTexture *textur2 = [SKTexture textureWithImage:image2];
    SKTexture *textur3 = [SKTexture textureWithImage:image3];
    SKTexture *textur4 = [SKTexture textureWithImage:image4];
    SKTexture *textur5 = [SKTexture textureWithImage:image5];
    SKTexture *textur6 = [SKTexture textureWithImage:image6];
    SKTexture *textur7 = [SKTexture textureWithImage:image7];
    SKTexture *textur8 = [SKTexture textureWithImage:image8];
    SKTexture *textur9 = [SKTexture textureWithImage:image9];
    SKTexture *textur10 = [SKTexture textureWithImage:image10];
    SKTexture *textur11 = [SKTexture textureWithImage:image11];
    SKTexture *textur12 = [SKTexture textureWithImage:image12];
    SKTexture *textur13 = [SKTexture textureWithImage:image13];
    SKTexture *textur14 = [SKTexture textureWithImage:image14];
    SKTexture *textur15 = [SKTexture textureWithImage:image15];
    SKTexture *textur16 = [SKTexture textureWithImage:image16];
    
    SKSpriteNode *pic1 = [SKSpriteNode spriteNodeWithTexture:textur1];
    pic1.xScale = pic1.yScale = 0.5;
    
    SKSpriteNode *pic2 = [SKSpriteNode spriteNodeWithTexture:textur2];
    pic2.xScale = pic2.yScale = 0.5;
    
    SKSpriteNode *pic3 = [SKSpriteNode spriteNodeWithTexture:textur3];
    pic3.xScale = pic3.yScale = 0.5;
    
    SKSpriteNode *pic4 = [SKSpriteNode spriteNodeWithTexture:textur4];
    pic4.xScale = pic4.yScale = 0.5;
    
    SKSpriteNode *pic5 = [SKSpriteNode spriteNodeWithTexture:textur5];
    pic5.xScale = pic5.yScale = 0.5;
    
    SKSpriteNode *pic6 = [SKSpriteNode spriteNodeWithTexture:textur6];
    pic6.xScale = pic6.yScale = 0.5;
    
    SKSpriteNode *pic7 = [SKSpriteNode spriteNodeWithTexture:textur7];
    pic7.xScale = pic7.yScale = 0.5;
    
    SKSpriteNode *pic8 = [SKSpriteNode spriteNodeWithTexture:textur8];
    pic8.xScale = pic8.yScale = 0.5;
    
    SKSpriteNode *pic9 = [SKSpriteNode spriteNodeWithTexture:textur9];
    pic9.xScale = pic9.yScale = 0.5;
    
    SKSpriteNode *pic10 = [SKSpriteNode spriteNodeWithTexture:textur10];
    pic10.xScale = pic10.yScale = 0.5;
    
    SKSpriteNode *pic11 = [SKSpriteNode spriteNodeWithTexture:textur11];
    pic11.xScale = pic11.yScale = 0.5;
    
    SKSpriteNode *pic12 = [SKSpriteNode spriteNodeWithTexture:textur12];
    pic12.xScale = pic12.yScale = 0.5;
    
    SKSpriteNode *pic13 = [SKSpriteNode spriteNodeWithTexture:textur13];
    pic13.xScale = pic13.yScale = 0.5;
    
    SKSpriteNode *pic14 = [SKSpriteNode spriteNodeWithTexture:textur14];
    pic14.xScale = pic14.yScale = 0.5;
    
    SKSpriteNode *pic15 = [SKSpriteNode spriteNodeWithTexture:textur15];
    pic15.xScale = pic15.yScale = 0.5;
    
    SKSpriteNode *pic16 = [SKSpriteNode spriteNodeWithTexture:textur16];
    pic16.xScale = pic16.yScale = 0.5;
    
    ////
    
    SKSpriteNode *mask1 = [self sixTeenMaskForIndex:1];
    mask1.xScale = mask1.yScale = 0.5;
    
    SKSpriteNode *mask2 = [self sixTeenMaskForIndex:2];
    mask2.xScale = mask2.yScale = 0.5;
    
    SKSpriteNode *mask3 = [self sixTeenMaskForIndex:3];
    mask3.xScale = mask3.yScale = 0.5;
    
    SKSpriteNode *mask4 = [self sixTeenMaskForIndex:4];
    mask4.xScale = mask4.yScale = 0.5;
    
    SKSpriteNode *mask5 = [self sixTeenMaskForIndex:5];
    mask5.xScale = mask5.yScale = 0.5;
    
    SKSpriteNode *mask6 = [self sixTeenMaskForIndex:6];
    mask6.xScale = mask6.yScale = 0.5;
    
    SKSpriteNode *mask7 = [self sixTeenMaskForIndex:7];
    mask7.xScale = mask7.yScale = 0.5;
    
    SKSpriteNode *mask8 = [self sixTeenMaskForIndex:8];
    mask8.xScale = mask8.yScale = 0.5;
    
    SKSpriteNode *mask9 = [self sixTeenMaskForIndex:9];
    mask9.xScale = mask9.yScale = 0.5;
    
    SKSpriteNode *mask10 = [self sixTeenMaskForIndex:10];
    mask10.xScale = mask10.yScale = 0.5;
    
    SKSpriteNode *mask11 = [self sixTeenMaskForIndex:11];
    mask11.xScale = mask11.yScale = 0.5;
    
    SKSpriteNode *mask12 = [self sixTeenMaskForIndex:12];
    mask12.xScale = mask12.yScale = 0.5;
    
    SKSpriteNode *mask13 = [self sixTeenMaskForIndex:13];
    mask13.xScale = mask13.yScale = 0.5;
    
    SKSpriteNode *mask14 = [self sixTeenMaskForIndex:14];
    mask14.xScale = mask14.yScale = 0.5;
    
    SKSpriteNode *mask15 = [self sixTeenMaskForIndex:15];
    mask15.xScale = mask15.yScale = 0.5;
    
    SKSpriteNode *mask16 = [self sixTeenMaskForIndex:16];
    mask16.xScale = mask16.yScale = 0.5;
    
    SKCropNode *scropNode1 = [SKCropNode node];
    [scropNode1 addChild:pic1];
    [scropNode1 setMaskNode:mask1];
    
    SKCropNode *scropNode2 = [SKCropNode node];
    [scropNode2 addChild:pic2];
    [scropNode2 setMaskNode:mask2];
    
    SKCropNode *scropNode3 = [SKCropNode node];
    [scropNode3 addChild:pic3];
    [scropNode3 setMaskNode:mask3];
    
    SKCropNode *scropNode4 = [SKCropNode node];
    [scropNode4 addChild:pic4];
    [scropNode4 setMaskNode:mask4];
    
    SKCropNode *scropNode5 = [SKCropNode node];
    [scropNode5 addChild:pic5];
    [scropNode5 setMaskNode:mask5];
    
    SKCropNode *scropNode6 = [SKCropNode node];
    [scropNode6 addChild:pic6];
    [scropNode6 setMaskNode:mask6];
    
    SKCropNode *scropNode7 = [SKCropNode node];
    [scropNode7 addChild:pic7];
    [scropNode7 setMaskNode:mask7];
    
    SKCropNode *scropNode8 = [SKCropNode node];
    [scropNode8 addChild:pic8];
    [scropNode8 setMaskNode:mask8];
    
    SKCropNode *scropNode9 = [SKCropNode node];
    [scropNode9 addChild:pic9];
    [scropNode9 setMaskNode:mask9];
    
    SKCropNode *scropNode10 = [SKCropNode node];
    [scropNode10 addChild:pic10];
    [scropNode10 setMaskNode:mask10];
    
    SKCropNode *scropNode11 = [SKCropNode node];
    [scropNode11 addChild:pic11];
    [scropNode11 setMaskNode:mask11];
    
    SKCropNode *scropNode12 = [SKCropNode node];
    [scropNode12 addChild:pic12];
    [scropNode12 setMaskNode:mask12];
    
    SKCropNode *scropNode13 = [SKCropNode node];
    [scropNode13 addChild:pic13];
    [scropNode13 setMaskNode:mask13];
    
    SKCropNode *scropNode14 = [SKCropNode node];
    [scropNode14 addChild:pic14];
    [scropNode14 setMaskNode:mask14];
    
    SKCropNode *scropNode15 = [SKCropNode node];
    [scropNode15 addChild:pic15];
    [scropNode15 setMaskNode:mask15];
    
    SKCropNode *scropNode16 = [SKCropNode node];
    [scropNode16 addChild:pic16];
    [scropNode16 setMaskNode:mask16];
    
    PuzzleSprite *sprite1 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic1.size];
    sprite1.gameScene = self;
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(133, 617);
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, /*320 -*/ sprite1.position.y - sprite1.frame.size.height/2, 120, 120);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = YES;
    sprite1.zPosition = 1;
    sprite1.xScale = sprite1.yScale = self.scaleForSelectedImg;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    sprite2.gameScene = self;
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(259, 591);
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, /*320 -*/ sprite2.position.y - sprite2.frame.size.height/2, 120, 120);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = YES;
    sprite2.zPosition = 1;
    sprite2.xScale = sprite1.yScale = self.scaleForSelectedImg;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    sprite3.gameScene = self;
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(414, 617);
    sprite3.touchArrea = CGRectMake(sprite3.position.x - sprite3.frame.size.width/2, /*320 -*/ sprite3.position.y - sprite3.frame.size.height/2, 120, 120);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = YES;
    sprite3.zPosition = 1;
    sprite3.xScale = sprite3.yScale = self.scaleForSelectedImg;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    sprite4.gameScene = self;
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(565, 592);
    sprite4.touchArrea = CGRectMake(sprite4.position.x - sprite4.frame.size.width/2, /*320 -*/ sprite4.position.y - sprite4.frame.size.height/2, 120, 120);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = YES;
    sprite4.zPosition = 1;
    sprite4.xScale = sprite3.yScale = self.scaleForSelectedImg;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic5.size];
    sprite5.gameScene = self;
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(108, 470);
    sprite5.touchArrea = CGRectMake(sprite5.position.x - sprite5.frame.size.width/2, /*320 -*/ sprite5.position.y - sprite5.frame.size.height/2, 120, 120);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = YES;
    sprite5.zPosition = 1;
    sprite5.xScale = sprite5.yScale = self.scaleForSelectedImg;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
    
    PuzzleSprite *sprite6 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    sprite6.gameScene = self;
    [sprite6 addChild:scropNode6];
    sprite6.position = CGPointMake(259, 470);
    sprite6.touchArrea = CGRectMake(sprite6.position.x - sprite6.frame.size.width/2, /*320 -*/ sprite6.position.y - sprite6.frame.size.height/2, 120, 120);
    [self addChild:sprite6];
    sprite6.userInteractionEnabled = YES;
    sprite6.zPosition = 1;
    sprite6.xScale = sprite6.yScale = self.scaleForSelectedImg;
    sprite6.destinationPosition = sprite6.position;
    [cropNodesArray addObject:sprite6];
    
    PuzzleSprite *sprite7 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic7.size];
    sprite7.gameScene = self;
    [sprite7 addChild:scropNode7];
    sprite7.position = CGPointMake(415, 469);
    sprite7.touchArrea = CGRectMake(sprite7.position.x - sprite7.frame.size.width/2, /*320 -*/ sprite7.position.y - sprite7.frame.size.height/2, 120, 120);
    [self addChild:sprite7];
    sprite7.userInteractionEnabled = YES;
    sprite7.zPosition = 1;
    sprite7.xScale = sprite7.yScale = self.scaleForSelectedImg;
    sprite7.destinationPosition = sprite7.position;
    [cropNodesArray addObject:sprite7];
    
    PuzzleSprite *sprite8 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic8.size];
    sprite8.gameScene = self;
    [sprite8 addChild:scropNode8];
    sprite8.position = CGPointMake(541, 470);
    sprite8.touchArrea = CGRectMake(sprite8.position.x - sprite8.frame.size.width/2, /*320 -*/ sprite8.position.y - sprite8.frame.size.height/2, 120, 120);
    [self addChild:sprite8];
    sprite8.userInteractionEnabled = YES;
    sprite8.zPosition = 1;
    sprite8.xScale = sprite8.yScale = self.scaleForSelectedImg;
    sprite8.destinationPosition = sprite8.position;
    [cropNodesArray addObject:sprite8];
    
    PuzzleSprite *sprite9 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic9.size];
    sprite9.gameScene = self;
    [sprite9 addChild:scropNode9];
    sprite9.position = CGPointMake(133, 313);
    sprite9.touchArrea = CGRectMake(sprite9.position.x - sprite9.frame.size.width/2, /*320 -*/ sprite9.position.y - sprite9.frame.size.height/2, 120, 120);
    [self addChild:sprite9];
    sprite9.userInteractionEnabled = YES;
    sprite9.zPosition = 1;
    sprite9.xScale = sprite9.yScale = self.scaleForSelectedImg;
    sprite9.destinationPosition = sprite9.position;
    [cropNodesArray addObject:sprite9];
    
    PuzzleSprite *sprite10 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic10.size];
    sprite10.gameScene = self;
    [sprite10 addChild:scropNode10];
    sprite10.position = CGPointMake(259, 312);
    sprite10.touchArrea = CGRectMake(sprite10.position.x - sprite10.frame.size.width/2, /*320 -*/ sprite10.position.y - sprite10.frame.size.height/2, 120, 120);
    [self addChild:sprite10];
    sprite10.userInteractionEnabled = YES;
    sprite10.zPosition = 1;
    sprite10.xScale = sprite10.yScale = self.scaleForSelectedImg;
    sprite10.destinationPosition = sprite10.position;
    [cropNodesArray addObject:sprite10];
    
    PuzzleSprite *sprite11 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic11.size];
    sprite11.gameScene = self;
    [sprite11 addChild:scropNode11];
    sprite11.position = CGPointMake(415, 313);
    sprite11.touchArrea = CGRectMake(sprite11.position.x - sprite11.frame.size.width/2, /*320 -*/ sprite11.position.y - sprite11.frame.size.height/2, 120, 120);
    [self addChild:sprite11];
    sprite11.userInteractionEnabled = YES;
    sprite11.zPosition = 1;
    sprite11.xScale = sprite11.yScale = self.scaleForSelectedImg;
    sprite11.destinationPosition = sprite11.position;
    [cropNodesArray addObject:sprite11];
    
    PuzzleSprite *sprite12 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic12.size];
    sprite12.gameScene = self;
    [sprite12 addChild:scropNode12];
    sprite12.position = CGPointMake(566, 313);
    sprite12.touchArrea = CGRectMake(sprite12.position.x - sprite12.frame.size.width/2, /*320 -*/ sprite12.position.y - sprite12.frame.size.height/2, 120, 120);
    [self addChild:sprite12];
    sprite12.userInteractionEnabled = YES;
    sprite12.zPosition = 1;
    sprite12.xScale = sprite12.yScale = self.scaleForSelectedImg;
    sprite12.destinationPosition = sprite12.position;
    [cropNodesArray addObject:sprite12];
    
    PuzzleSprite *sprite13 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic13.size];
    sprite13.gameScene = self;
    [sprite13 addChild:scropNode13];
    sprite13.position = CGPointMake(109, 183);
    sprite13.touchArrea = CGRectMake(sprite13.position.x - sprite13.frame.size.width/2, /*320 -*/ sprite13.position.y - sprite13.frame.size.height/2, 120, 120);
    [self addChild:sprite13];
    sprite13.userInteractionEnabled = YES;
    sprite13.zPosition = 1;
    sprite13.xScale = sprite13.yScale = self.scaleForSelectedImg;
    sprite13.destinationPosition = sprite13.position;
    [cropNodesArray addObject:sprite13];
    
    PuzzleSprite *sprite14 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic14.size];
    sprite14.gameScene = self;
    [sprite14 addChild:scropNode14];
    sprite14.position = CGPointMake(260, 159);
    sprite14.touchArrea = CGRectMake(sprite14.position.x - sprite14.frame.size.width/2, /*320 -*/ sprite14.position.y - sprite14.frame.size.height/2, 120, 120);
    [self addChild:sprite14];
    sprite14.userInteractionEnabled = YES;
    sprite14.zPosition = 1;
    sprite14.xScale = sprite14.yScale = self.scaleForSelectedImg;
    sprite14.destinationPosition = sprite14.position;
    [cropNodesArray addObject:sprite14];
    
    PuzzleSprite *sprite15 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic15.size];
    sprite15.gameScene = self;
    [sprite15 addChild:scropNode15];
    sprite15.position = CGPointMake(415, 183);
    sprite15.touchArrea = CGRectMake(sprite15.position.x - sprite15.frame.size.width/2, /*320 -*/ sprite15.position.y - sprite15.frame.size.height/2, 120, 120);
    [self addChild:sprite15];
    sprite15.userInteractionEnabled = YES;
    sprite15.zPosition = 1;
    sprite15.xScale = sprite15.yScale = self.scaleForSelectedImg;
    sprite15.destinationPosition = sprite15.position;
    [cropNodesArray addObject:sprite15];
    
    PuzzleSprite *sprite16 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic16.size];
    sprite16.gameScene = self;
    [sprite16 addChild:scropNode16];
    sprite16.position = CGPointMake(541, 158);
    sprite16.touchArrea = CGRectMake(sprite16.position.x - sprite16.frame.size.width/2, /*320 -*/ sprite16.position.y - sprite16.frame.size.height/2, 120, 120);
    [self addChild:sprite16];
    sprite16.userInteractionEnabled = YES;
    sprite16.zPosition = 1;
    sprite16.xScale = sprite16.yScale = self.scaleForSelectedImg;
    sprite16.destinationPosition = sprite16.position;
    [cropNodesArray addObject:sprite16];
}

-(void)addSixteenMaskPuzzle
{
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi2 small.png"];
    originImgContur.position = CGPointMake(158, 163);
    originImgContur.xScale = originImgContur.yScale = 0.5;
    if (IS_IPHONE_6) {
        originImgContur.position=CGPointMake(180, centerPozitionY);
        originImgContur.xScale = originImgContur.yScale = 0.586;
    }
    [self addChild:originImgContur];
    originImgContur.zPosition = 2;
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self.animalName stringByDeletingPathExtension] ofType:self.animalName.pathExtension]];
    
    [self woundingSixteenPuzzle:image];
    
    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
    [addSixteenPuzzleTimer invalidate];
    addSixteenPuzzleTimer = nil;
}

-(void) woundingSixteenPuzzle:(UIImage *) image
{
    [self getSixTeenPointsFropPlists];
    
    CGRect cropRect1 = CGRectMake(0, -45, image.size.width/3, image.size.height/3);
    CGRect cropRect2 = CGRectMake(102, -7, image.size.width/3, image.size.height/3);
    CGRect cropRect3 = CGRectMake(186, -128, image.size.width/2, image.size.height/2);
    CGRect cropRect4 = CGRectMake(370, -90, image.size.width/2, image.size.height/2);
    CGRect cropRect5 = CGRectMake(-122, 54, image.size.width/2, image.size.height/2);
    CGRect cropRect6 = CGRectMake(61, 54, image.size.width/2, image.size.height/2);
    CGRect cropRect7 = CGRectMake(187, 54, image.size.width/2, image.size.height/2);
    CGRect cropRect8 = CGRectMake(330, 54, image.size.width/2, image.size.height/2);
    CGRect cropRect9 = CGRectMake(-83, 180, image.size.width/2, image.size.height/2);
    CGRect cropRect10 = CGRectMake(61, 181, image.size.width/2, image.size.height/2);
    CGRect cropRect11 = CGRectMake(187, 181, image.size.width/2, image.size.height/2);
    CGRect cropRect12 = CGRectMake(371, 181, image.size.width/2, image.size.height/2);
    CGRect cropRect13 = CGRectMake(-123, 326, image.size.width/2, image.size.height/2);
    CGRect cropRect14 = CGRectMake(62, 364, image.size.width/2, image.size.height/2);
    CGRect cropRect15 = CGRectMake(188, 322, image.size.width/2, image.size.height/2);
    CGRect cropRect16 = CGRectMake(331, 365, image.size.width/2, image.size.height/2);
    
    UIImage *image1 = [image cropeImageWithFrame:cropRect1];
    UIImage *image2 = [image cropeImageWithFrame:cropRect2];
    UIImage *image3 = [image cropeImageWithFrame:cropRect3];
    UIImage *image4 = [image cropeImageWithFrame:cropRect4];
    UIImage *image5 = [image cropeImageWithFrame:cropRect5];
    UIImage *image6 = [image cropeImageWithFrame:cropRect6];
    UIImage *image7 = [image cropeImageWithFrame:cropRect7];
    UIImage *image8 = [image cropeImageWithFrame:cropRect8];
    UIImage *image9 = [image cropeImageWithFrame:cropRect9];
    UIImage *image10 = [image cropeImageWithFrame:cropRect10];
    UIImage *image11 = [image cropeImageWithFrame:cropRect11];
    UIImage *image12 = [image cropeImageWithFrame:cropRect12];
    UIImage *image13 = [image cropeImageWithFrame:cropRect13];
    UIImage *image14 = [image cropeImageWithFrame:cropRect14];
    UIImage *image15 = [image cropeImageWithFrame:cropRect15];
    UIImage *image16 = [image cropeImageWithFrame:cropRect16];
    
    SKTexture *textur1 = [SKTexture textureWithImage:image1];
    SKTexture *textur2 = [SKTexture textureWithImage:image2];
    SKTexture *textur3 = [SKTexture textureWithImage:image3];
    SKTexture *textur4 = [SKTexture textureWithImage:image4];
    SKTexture *textur5 = [SKTexture textureWithImage:image5];
    SKTexture *textur6 = [SKTexture textureWithImage:image6];
    SKTexture *textur7 = [SKTexture textureWithImage:image7];
    SKTexture *textur8 = [SKTexture textureWithImage:image8];
    SKTexture *textur9 = [SKTexture textureWithImage:image9];
    SKTexture *textur10 = [SKTexture textureWithImage:image10];
    SKTexture *textur11 = [SKTexture textureWithImage:image11];
    SKTexture *textur12 = [SKTexture textureWithImage:image12];
    SKTexture *textur13 = [SKTexture textureWithImage:image13];
    SKTexture *textur14 = [SKTexture textureWithImage:image14];
    SKTexture *textur15 = [SKTexture textureWithImage:image15];
    SKTexture *textur16 = [SKTexture textureWithImage:image16];
    
    SKSpriteNode *pic1 = [SKSpriteNode spriteNodeWithTexture:textur1];
    pic1.xScale = pic1.yScale = 0.5;
    
    SKSpriteNode *pic2 = [SKSpriteNode spriteNodeWithTexture:textur2];
    pic2.xScale = pic2.yScale = 0.5;
    
    SKSpriteNode *pic3 = [SKSpriteNode spriteNodeWithTexture:textur3];
    pic3.xScale = pic3.yScale = 0.5;
    
    SKSpriteNode *pic4 = [SKSpriteNode spriteNodeWithTexture:textur4];
    pic4.xScale = pic4.yScale = 0.5;
    
    SKSpriteNode *pic5 = [SKSpriteNode spriteNodeWithTexture:textur5];
    pic5.xScale = pic5.yScale = 0.5;
    
    SKSpriteNode *pic6 = [SKSpriteNode spriteNodeWithTexture:textur6];
    pic6.xScale = pic6.yScale = 0.5;
    
    SKSpriteNode *pic7 = [SKSpriteNode spriteNodeWithTexture:textur7];
    pic7.xScale = pic7.yScale = 0.5;
    
    SKSpriteNode *pic8 = [SKSpriteNode spriteNodeWithTexture:textur8];
    pic8.xScale = pic8.yScale = 0.5;
    
    SKSpriteNode *pic9 = [SKSpriteNode spriteNodeWithTexture:textur9];
    pic9.xScale = pic9.yScale = 0.5;
    
    SKSpriteNode *pic10 = [SKSpriteNode spriteNodeWithTexture:textur10];
    pic10.xScale = pic10.yScale = 0.5;
    
    SKSpriteNode *pic11 = [SKSpriteNode spriteNodeWithTexture:textur11];
    pic11.xScale = pic11.yScale = 0.5;
    
    SKSpriteNode *pic12 = [SKSpriteNode spriteNodeWithTexture:textur12];
    pic12.xScale = pic12.yScale = 0.5;
    
    SKSpriteNode *pic13 = [SKSpriteNode spriteNodeWithTexture:textur13];
    pic13.xScale = pic13.yScale = 0.5;
    
    SKSpriteNode *pic14 = [SKSpriteNode spriteNodeWithTexture:textur14];
    pic14.xScale = pic14.yScale = 0.5;
    
    SKSpriteNode *pic15 = [SKSpriteNode spriteNodeWithTexture:textur15];
    pic15.xScale = pic15.yScale = 0.5;
    
    SKSpriteNode *pic16 = [SKSpriteNode spriteNodeWithTexture:textur16];
    pic16.xScale = pic16.yScale = 0.5;
    
    SKSpriteNode *mask1 = [self sixTeenMaskForIndex:1];
    SKSpriteNode *mask2 = [self sixTeenMaskForIndex:2];
    SKSpriteNode *mask3 = [self sixTeenMaskForIndex:3];
    SKSpriteNode *mask4 = [self sixTeenMaskForIndex:4];
    SKSpriteNode *mask5 = [self sixTeenMaskForIndex:5];
    SKSpriteNode *mask6 = [self sixTeenMaskForIndex:6];
    SKSpriteNode *mask7 = [self sixTeenMaskForIndex:7];
    SKSpriteNode *mask8 = [self sixTeenMaskForIndex:8];
    SKSpriteNode *mask9 = [self sixTeenMaskForIndex:9];
    SKSpriteNode *mask10 = [self sixTeenMaskForIndex:10];
    SKSpriteNode *mask11 = [self sixTeenMaskForIndex:11];
    SKSpriteNode *mask12 = [self sixTeenMaskForIndex:12];
    SKSpriteNode *mask13 = [self sixTeenMaskForIndex:13];
    SKSpriteNode *mask14 = [self sixTeenMaskForIndex:14];
    SKSpriteNode *mask15 = [self sixTeenMaskForIndex:15];
    SKSpriteNode *mask16 = [self sixTeenMaskForIndex:16];
    
    SKCropNode *scropNode1 = [SKCropNode node];
    [scropNode1 addChild:pic1];
    [scropNode1 setMaskNode:mask1];
    
    SKCropNode *scropNode2 = [SKCropNode node];
    [scropNode2 addChild:pic2];
    [scropNode2 setMaskNode:mask2];
    
    SKCropNode *scropNode3 = [SKCropNode node];
    [scropNode3 addChild:pic3];
    [scropNode3 setMaskNode:mask3];
    
    SKCropNode *scropNode4 = [SKCropNode node];
    [scropNode4 addChild:pic4];
    [scropNode4 setMaskNode:mask4];
    
    SKCropNode *scropNode5 = [SKCropNode node];
    [scropNode5 addChild:pic5];
    [scropNode5 setMaskNode:mask5];
    
    SKCropNode *scropNode6 = [SKCropNode node];
    [scropNode6 addChild:pic6];
    [scropNode6 setMaskNode:mask6];
    
    SKCropNode *scropNode7 = [SKCropNode node];
    [scropNode7 addChild:pic7];
    [scropNode7 setMaskNode:mask7];
    
    SKCropNode *scropNode8 = [SKCropNode node];
    [scropNode8 addChild:pic8];
    [scropNode8 setMaskNode:mask8];
    
    SKCropNode *scropNode9 = [SKCropNode node];
    [scropNode9 addChild:pic9];
    [scropNode9 setMaskNode:mask9];
    
    SKCropNode *scropNode10 = [SKCropNode node];
    [scropNode10 addChild:pic10];
    [scropNode10 setMaskNode:mask10];
    
    SKCropNode *scropNode11 = [SKCropNode node];
    [scropNode11 addChild:pic11];
    [scropNode11 setMaskNode:mask11];
    
    SKCropNode *scropNode12 = [SKCropNode node];
    [scropNode12 addChild:pic12];
    [scropNode12 setMaskNode:mask12];
    
    SKCropNode *scropNode13 = [SKCropNode node];
    [scropNode13 addChild:pic13];
    [scropNode13 setMaskNode:mask13];
    
    SKCropNode *scropNode14 = [SKCropNode node];
    [scropNode14 addChild:pic14];
    [scropNode14 setMaskNode:mask14];
    
    SKCropNode *scropNode15 = [SKCropNode node];
    [scropNode15 addChild:pic15];
    [scropNode15 setMaskNode:mask15];
    
    SKCropNode *scropNode16 = [SKCropNode node];
    [scropNode16 addChild:pic16];
    [scropNode16 setMaskNode:mask16];
    
    PuzzleSprite *sprite1 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic1.size];
    sprite1.gameScene = self;
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(75, 257);
    if (IS_IPHONE_6) {
        sprite1.position=CGPointMake(83, 298);
    }
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, /*320 -*/ sprite1.position.y - sprite1.frame.size.height/2, 80, 80);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = YES;
    sprite1.zPosition = 1;
    sprite1.xScale = sprite1.yScale = self.scaleForSelectedImg;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    sprite2.gameScene = self;
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(126, 247);
    if (IS_IPHONE_6) {
        sprite2.position=CGPointMake(143, 286);
    }
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, /*320 -*/ sprite2.position.y - sprite2.frame.size.height/2, 80, 80);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = YES;
    sprite2.zPosition = 1;
    sprite2.xScale = sprite2.yScale = self.scaleForSelectedImg;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    sprite3.gameScene = self;
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(189, 257);
    if (IS_IPHONE_6) {
        sprite3.position=CGPointMake(216, 298);
    }
    sprite3.touchArrea = CGRectMake(sprite3.position.x - sprite3.frame.size.width/2, /*320 -*/ sprite3.position.y - sprite3.frame.size.height/2, 80, 80);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = YES;
    sprite3.zPosition = 1;
    sprite3.xScale = sprite3.yScale = self.scaleForSelectedImg;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    sprite4.gameScene = self;
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(250, 247);
    if (IS_IPHONE_6) {
        sprite4.position=CGPointMake(288, 286);
    }
    sprite4.touchArrea = CGRectMake(sprite4.position.x - sprite4.frame.size.width/2, /*320 -*/ sprite4.position.y - sprite4.frame.size.height/2, 80, 80);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = YES;
    sprite4.zPosition = 1;
    sprite4.xScale = sprite4.yScale = self.scaleForSelectedImg;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    sprite5.gameScene = self;
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(65, 198);
    if (IS_IPHONE_6) {
        sprite5.position=CGPointMake(71, 228);
    }
    sprite5.touchArrea = CGRectMake(sprite5.position.x - sprite5.frame.size.width/2, /*320 -*/ sprite5.position.y - sprite5.frame.size.height/2, 80, 80);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = YES;
    sprite5.zPosition = 1;
    sprite5.xScale = sprite5.yScale = self.scaleForSelectedImg;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
    
    PuzzleSprite *sprite6 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    sprite6.gameScene = self;
    [sprite6 addChild:scropNode6];
    sprite6.position = CGPointMake(126, 198);
    if (IS_IPHONE_6) {
        sprite6.position=CGPointMake(143, 228);
    }
    sprite6.touchArrea = CGRectMake(sprite6.position.x - sprite6.frame.size.width/2, /*320 -*/ sprite6.position.y - sprite6.frame.size.height/2, 80, 80);
    [self addChild:sprite6];
    sprite6.userInteractionEnabled = YES;
    sprite6.zPosition = 1;
    sprite6.xScale = sprite6.yScale = self.scaleForSelectedImg;
    sprite6.destinationPosition = sprite6.position;
    [cropNodesArray addObject:sprite6];
    
    PuzzleSprite *sprite7 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic7.size];
    sprite7.gameScene = self;
    [sprite7 addChild:scropNode7];
    sprite7.position = CGPointMake(190, 197);
    if (IS_IPHONE_6) {
        sprite7.position=CGPointMake(217, 228);
    }
    sprite7.touchArrea = CGRectMake(sprite7.position.x - sprite7.frame.size.width/2, /*320 -*/ sprite7.position.y - sprite7.frame.size.height/2, 80, 80);
    [self addChild:sprite7];
    sprite7.userInteractionEnabled = YES;
    sprite7.zPosition = 1;
    sprite7.xScale = sprite7.yScale = self.scaleForSelectedImg;
    sprite7.destinationPosition = sprite7.position;
    [cropNodesArray addObject:sprite7];
    
    PuzzleSprite *sprite8 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic8.size];
    sprite8.gameScene = self;
    [sprite8 addChild:scropNode8];
    sprite8.position = CGPointMake(241, 197);
    if (IS_IPHONE_6) {
        sprite8.position=CGPointMake(277, 227);
    }
    sprite8.touchArrea = CGRectMake(sprite8.position.x - sprite8.frame.size.width/2, /*320 -*/ sprite8.position.y - sprite8.frame.size.height/2, 80, 80);
    [self addChild:sprite8];
    sprite8.userInteractionEnabled = YES;
    sprite8.zPosition = 1;
    sprite8.xScale = sprite8.yScale = self.scaleForSelectedImg;
    sprite8.destinationPosition = sprite8.position;
    [cropNodesArray addObject:sprite8];
    
    PuzzleSprite *sprite9 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic9.size];
    sprite9.gameScene = self;
    [sprite9 addChild:scropNode9];
    sprite9.position = CGPointMake(75, 134);
    if (IS_IPHONE_6) {
        sprite9.position=CGPointMake(83, 154);
    }
    sprite9.touchArrea = CGRectMake(sprite9.position.x - sprite9.frame.size.width/2, /*320 -*/ sprite9.position.y - sprite9.frame.size.height/2, 80, 80);
    [self addChild:sprite9];
    sprite9.userInteractionEnabled = YES;
    sprite9.zPosition = 1;
    sprite9.xScale = sprite9.yScale = self.scaleForSelectedImg;
    sprite9.destinationPosition = sprite9.position;
    [cropNodesArray addObject:sprite9];
    
    PuzzleSprite *sprite10 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic10.size];
    sprite10.gameScene = self;
    [sprite10 addChild:scropNode10];
    sprite10.position = CGPointMake(126, 134);
    if (IS_IPHONE_6) {
        sprite10.position=CGPointMake(143, 154);
    }
    sprite10.touchArrea = CGRectMake(sprite10.position.x - sprite10.frame.size.width/2, /*320 -*/ sprite10.position.y - sprite10.frame.size.height/2, 80, 80);
    [self addChild:sprite10];
    sprite10.userInteractionEnabled = YES;
    sprite10.zPosition = 1;
    sprite10.xScale = sprite10.yScale = self.scaleForSelectedImg;
    sprite10.destinationPosition = sprite10.position;
    [cropNodesArray addObject:sprite10];
    
    PuzzleSprite *sprite11 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic11.size];
    sprite11.gameScene = self;
    [sprite11 addChild:scropNode11];
    sprite11.position = CGPointMake(190, 134);
    if (IS_IPHONE_6) {
        sprite11.position=CGPointMake(217, 154);
    }
    sprite11.touchArrea = CGRectMake(sprite11.position.x - sprite11.frame.size.width/2, /*320 -*/ sprite11.position.y - sprite11.frame.size.height/2, 80, 80);
    [self addChild:sprite11];
    sprite11.userInteractionEnabled = YES;
    sprite11.zPosition = 1;
    sprite11.xScale = sprite11.yScale = self.scaleForSelectedImg;
    sprite11.destinationPosition = sprite11.position;
    [cropNodesArray addObject:sprite11];
    
    PuzzleSprite *sprite12 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic12.size];
    sprite12.gameScene = self;
    [sprite12 addChild:scropNode12];
    sprite12.position = CGPointMake(250, 134);
    if (IS_IPHONE_6) {
        sprite12.position=CGPointMake(289, 153);
    }
    sprite12.touchArrea = CGRectMake(sprite12.position.x - sprite12.frame.size.width/2, /*320 -*/ sprite12.position.y - sprite12.frame.size.height/2, 80, 80);
    [self addChild:sprite12];
    sprite12.userInteractionEnabled = YES;
    sprite12.zPosition = 1;
    sprite12.xScale = sprite12.yScale = self.scaleForSelectedImg;
    sprite12.destinationPosition = sprite12.position;
    [cropNodesArray addObject:sprite12];
    
    PuzzleSprite *sprite13 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic13.size];
    sprite13.gameScene = self;
    [sprite13 addChild:scropNode13];
    sprite13.position = CGPointMake(65, 81);
    if (IS_IPHONE_6) {
        sprite13.position=CGPointMake(71, 92);
    }
    sprite13.touchArrea = CGRectMake(sprite13.position.x - sprite13.frame.size.width/2, /*320 -*/ sprite13.position.y - sprite13.frame.size.height/2, 80, 80);
    [self addChild:sprite13];
    sprite13.userInteractionEnabled = YES;
    sprite13.zPosition = 1;
    sprite13.xScale = sprite13.yScale = self.scaleForSelectedImg;
    sprite13.destinationPosition = sprite13.position;
    [cropNodesArray addObject:sprite13];
    
    PuzzleSprite *sprite14 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic14.size];
    sprite14.gameScene = self;
    [sprite14 addChild:scropNode14];
    sprite14.position = CGPointMake(126, 72);
    if (IS_IPHONE_6) {
        sprite14.position=CGPointMake(143, 81);
    }
    sprite14.touchArrea = CGRectMake(sprite14.position.x - sprite14.frame.size.width/2, /*320 -*/ sprite14.position.y - sprite14.frame.size.height/2, 80, 80);
    [self addChild:sprite14];
    sprite14.userInteractionEnabled = YES;
    sprite14.zPosition = 1;
    sprite14.xScale = sprite14.yScale = self.scaleForSelectedImg;
    sprite14.destinationPosition = sprite14.position;
    [cropNodesArray addObject:sprite14];
    
    PuzzleSprite *sprite15 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic15.size];
    sprite15.gameScene = self;
    [sprite15 addChild:scropNode15];
    sprite15.position = CGPointMake(190, 82);
    if (IS_IPHONE_6) {
        sprite15.position=CGPointMake(217, 93);
    }
    sprite15.touchArrea = CGRectMake(sprite15.position.x - sprite15.frame.size.width/2, /*320 -*/ sprite15.position.y - sprite15.frame.size.height/2, 80, 80);
    [self addChild:sprite15];
    sprite15.userInteractionEnabled = YES;
    sprite15.zPosition = 1;
    sprite15.xScale = sprite15.yScale = self.scaleForSelectedImg;
    sprite15.destinationPosition = sprite15.position;
    [cropNodesArray addObject:sprite15];
    
    PuzzleSprite *sprite16 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic16.size];
    sprite16.gameScene = self;
    [sprite16 addChild:scropNode16];
    sprite16.position = CGPointMake(241, 72);
    if (IS_IPHONE_6) {
        sprite16.position=CGPointMake(277, 80);
    }
    sprite16.touchArrea = CGRectMake(sprite16.position.x - sprite16.frame.size.width/2, /*320 -*/ sprite16.position.y - sprite16.frame.size.height/2, 80, 80);
    [self addChild:sprite16];
    sprite16.userInteractionEnabled = YES;
    sprite16.zPosition = 1;
    sprite16.xScale = sprite16.yScale = self.scaleForSelectedImg;
    sprite16.destinationPosition = sprite16.position;
    [cropNodesArray addObject:sprite16];
}

-(void) woundingPuzzle:(UIImage *) image
{
    [self getPointsFropPlists];
    
    CGRect cropRect1 = CGRectMake(-35, -73, image.size.width/3+40, image.size.height/3+80);
    
    CGRect cropRect2 = CGRectMake(image.size.width/3-30-18, -40, image.size.width/3+90, image.size.height/3+80);
    
    CGRect cropRect3 = CGRectMake(2*image.size.width/3-14, -70, image.size.width/3+100, image.size.height/3+80);
    
    CGRect cropRect4 = CGRectMake(0, image.size.height/3-40, image.size.width/3+40, image.size.height/3+80);
    
    CGRect cropRect5 = CGRectMake(image.size.width/3-23, image.size.height/3-40, image.size.width/3+40, image.size.height/3+80);
    
    CGRect cropRect6 = CGRectMake(2*image.size.width/3-45, image.size.height/3-40, image.size.width/3+40, image.size.height/3+80);
    
    CGRect cropRect7 = CGRectMake(-37, 2*image.size.width/3-14, image.size.width/3+40, image.size.height/3+80);
    
    CGRect cropRect8 = CGRectMake(image.size.width/3-30-19, 2*image.size.width/3-45, image.size.width/3+90, image.size.height/3+140);
    
    CGRect cropRect9 = CGRectMake(2*image.size.width/3-12, 2*image.size.width/3-12, image.size.width/3+40, image.size.height/3+80);
    
    UIImage *image1 = [image cropeImageWithFrame:cropRect1];
    UIImage *image2 = [image cropeImageWithFrame:cropRect2];
    UIImage *image3 = [image cropeImageWithFrame:cropRect3];
    UIImage *image4 = [image cropeImageWithFrame:cropRect4];
    UIImage *image5 = [image cropeImageWithFrame:cropRect5];
    UIImage *image6 = [image cropeImageWithFrame:cropRect6];
    UIImage *image7 = [image cropeImageWithFrame:cropRect7];
    UIImage *image8 = [image cropeImageWithFrame:cropRect8];
    UIImage *image9 = [image cropeImageWithFrame:cropRect9];
    
    SKTexture *textur1 = [SKTexture textureWithImage:image1];
    SKTexture *textur2 = [SKTexture textureWithImage:image2];
    SKTexture *textur3 = [SKTexture textureWithImage:image3];
    SKTexture *textur4 = [SKTexture textureWithImage:image4];
    SKTexture *textur5 = [SKTexture textureWithImage:image5];
    SKTexture *textur6 = [SKTexture textureWithImage:image6];
    SKTexture *textur7 = [SKTexture textureWithImage:image7];
    SKTexture *textur8 = [SKTexture textureWithImage:image8];
    SKTexture *textur9 = [SKTexture textureWithImage:image9];
    
    SKSpriteNode *pic1 = [SKSpriteNode spriteNodeWithTexture:textur1];
    pic1.xScale = pic1.yScale = 0.5;
    
    SKSpriteNode *pic2 = [SKSpriteNode spriteNodeWithTexture:textur2];
    pic2.xScale = pic2.yScale = 0.5;
    
    SKSpriteNode *pic3 = [SKSpriteNode spriteNodeWithTexture:textur3];
    pic3.xScale = pic3.yScale = 0.5;
    
    SKSpriteNode *pic4 = [SKSpriteNode spriteNodeWithTexture:textur4];
    pic4.xScale = pic4.yScale = 0.5;
    
    SKSpriteNode *pic5 = [SKSpriteNode spriteNodeWithTexture:textur5];
    pic5.xScale = pic5.yScale = 0.5;
    
    SKSpriteNode *pic6 = [SKSpriteNode spriteNodeWithTexture:textur6];
    pic6.xScale = pic6.yScale = 0.5;
    
    SKSpriteNode *pic7 = [SKSpriteNode spriteNodeWithTexture:textur7];
    pic7.xScale = pic7.yScale = 0.5;
    
    SKSpriteNode *pic8 = [SKSpriteNode spriteNodeWithTexture:textur8];
    pic8.xScale = pic8.yScale = 0.5;
    
    SKSpriteNode *pic9 = [SKSpriteNode spriteNodeWithTexture:textur9];
    pic9.xScale = pic9.yScale = 0.5;
    
    SKSpriteNode *mask1 = [self maskForindex:1];
    SKSpriteNode *mask2 = [self maskForindex:2];
    SKSpriteNode *mask3 = [self maskForindex:3];
    SKSpriteNode *mask4 = [self maskForindex:4];
    SKSpriteNode *mask5 = [self maskForindex:5];
    SKSpriteNode *mask6 = [self maskForindex:6];
    SKSpriteNode *mask7 = [self maskForindex:7];
    SKSpriteNode *mask8 = [self maskForindex:8];
    SKSpriteNode *mask9 = [self maskForindex:9];
    
    
    SKCropNode *scropNode1 = [SKCropNode node];
    [scropNode1 addChild:pic1];
    [scropNode1 setMaskNode:mask1];
    
    SKCropNode *scropNode2 = [SKCropNode node];
    [scropNode2 addChild:pic2];
    [scropNode2 setMaskNode:mask2];
    
    SKCropNode *scropNode3 = [SKCropNode node];
    [scropNode3 addChild:pic3];
    [scropNode3 setMaskNode:mask3];
    
    SKCropNode *scropNode4 = [SKCropNode node];
    [scropNode4 addChild:pic4];
    [scropNode4 setMaskNode:mask4];
    
    SKCropNode *scropNode5 = [SKCropNode node];
    [scropNode5 addChild:pic5];
    [scropNode5 setMaskNode:mask5];

    SKCropNode *scropNode6 = [SKCropNode node];
    [scropNode6 addChild:pic6];
    [scropNode6 setMaskNode:mask6];
    
    SKCropNode *scropNode7 = [SKCropNode node];
    [scropNode7 addChild:pic7];
    [scropNode7 setMaskNode:mask7];
    
    SKCropNode *scropNode8 = [SKCropNode node];
    [scropNode8 addChild:pic8];
    [scropNode8 setMaskNode:mask8];
    
    SKCropNode *scropNode9 = [SKCropNode node];
    [scropNode9 addChild:pic9];
    [scropNode9 setMaskNode:mask9];
    
    PuzzleSprite *sprite1 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic1.size];
    sprite1.gameScene = self;
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(76, 244);
    if (IS_IPHONE_6) {
        sprite1.position = CGPointMake(84, 283);
    }
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, /*320 -*/ sprite1.position.y - sprite1.frame.size.height/2, 80, 80);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = YES;
    sprite1.zPosition = 1;
    sprite1.xScale = sprite1.yScale = self.scaleForSelectedImg;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    sprite2.gameScene = self;
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(157, 235);
    if (IS_IPHONE_6) {
        sprite2.position = CGPointMake(179, 272);
    }
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, 320 - sprite2.position.y - sprite2.frame.size.height/2, 80, 80);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = YES;
    sprite2.zPosition = 1;
    sprite2.xScale = sprite2.yScale = self.scaleForSelectedImg;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    sprite3.gameScene = self;
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(238, 244);
    if (IS_IPHONE_6) {
        sprite3.position=CGPointMake(275, 282.5);
    }
    sprite3.touchArrea = CGRectMake(sprite3.position.x - sprite3.frame.size.width/2, 320 - sprite3.position.y - sprite3.frame.size.height/2, 80, 80);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = YES;
    sprite3.zPosition = 1;
    sprite3.xScale = sprite3.yScale = self.scaleForSelectedImg;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    sprite4.gameScene = self;
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(85, 163);
    if (IS_IPHONE_6) {
        sprite4.position=CGPointMake(94, 188);
    }
    sprite4.touchArrea = CGRectMake(sprite4.position.x - sprite4.frame.size.width/2, 320 - sprite4.position.y - sprite4.frame.size.height/2, 80, 80);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = YES;
    sprite4.zPosition = 1;
    sprite4.xScale = sprite4.yScale = self.scaleForSelectedImg;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic5.size];
    sprite5.gameScene = self;
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(157, 163);
    if (IS_IPHONE_6) {
        sprite5.position=CGPointMake(179, 187);
    }
    sprite5.touchArrea = CGRectMake(sprite5.position.x - sprite5.frame.size.width/2, 320 - sprite5.position.y - sprite5.frame.size.height/2, 80, 80);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = YES;
    sprite5.zPosition = 1;
    sprite5.xScale = sprite5.yScale = self.scaleForSelectedImg;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
    
    PuzzleSprite *sprite6 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    sprite6.gameScene = self;
    [sprite6 addChild:scropNode6];
    sprite6.position = CGPointMake(230, 163);
    if (IS_IPHONE_6) {
        sprite6.position=CGPointMake(263.5, 187);
    }
    sprite6.touchArrea = CGRectMake(sprite6.position.x - sprite6.frame.size.width/2, 320 - sprite6.position.y - sprite6.frame.size.height/2, 80, 80);
    [self addChild:sprite6];
    sprite6.userInteractionEnabled = YES;
    sprite6.zPosition = 1;
    sprite6.xScale = sprite6.yScale = self.scaleForSelectedImg;
    sprite6.destinationPosition = sprite6.position;
    [cropNodesArray addObject:sprite6];
    
    PuzzleSprite *sprite7 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic7.size];
    sprite7.gameScene = self;
    [sprite7 addChild:scropNode7];
    sprite7.position = CGPointMake(76, 81);
    if (IS_IPHONE_6) {
        sprite7.position=CGPointMake(83.5, 92);
    }
    sprite7.touchArrea = CGRectMake(sprite7.position.x - sprite7.frame.size.width/2, 320 - sprite7.position.y - sprite7.frame.size.height/2, 80, 80);
    [self addChild:sprite7];
    sprite7.userInteractionEnabled = YES;
    sprite7.zPosition = 1;
    sprite7.xScale = sprite7.yScale = self.scaleForSelectedImg;
    sprite7.destinationPosition = sprite7.position;
    [cropNodesArray addObject:sprite7];
    
    PuzzleSprite *sprite8 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic8.size];
    sprite8.gameScene = self;
    [sprite8 addChild:scropNode8];
    sprite8.position = CGPointMake(157, 90);
    if (IS_IPHONE_6) {
        sprite8.position=CGPointMake(178, 102);
    }
    sprite8.touchArrea = CGRectMake(sprite8.position.x - sprite8.frame.size.width/2, 320 - sprite8.position.y - sprite8.frame.size.height/2, 80, 80);
    [self addChild:sprite8];
    sprite8.userInteractionEnabled = YES;
    sprite8.zPosition = 1;
    sprite8.xScale = sprite8.yScale = self.scaleForSelectedImg;
    sprite8.destinationPosition = sprite8.position;
    [cropNodesArray addObject:sprite8];
    
    PuzzleSprite *sprite9 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic9.size];
    sprite9.gameScene = self;
    [sprite9 addChild:scropNode9];
    sprite9.position = CGPointMake(239, 81);
    if (IS_IPHONE_6) {
        sprite9.position=CGPointMake(274, 92);
    }
    sprite9.touchArrea = CGRectMake(sprite9.position.x - sprite9.frame.size.width/2, 320 - sprite9.position.y - sprite9.frame.size.height/2, 80, 80);
    [self addChild:sprite9];
    sprite9.userInteractionEnabled = YES;
    sprite9.zPosition = 1;
    sprite9.xScale = sprite9.yScale = self.scaleForSelectedImg;
    sprite9.destinationPosition = sprite9.position;
    [cropNodesArray addObject:sprite9];
    
}

-(void) loadRedyPicture
{
    [originalImage removeFromParent];
    [originalImage removeAllActions];
    originalImage.texture = nil;
    
    [blackArea removeFromParent];
    [blackArea removeAllActions];
    blackArea.texture = nil;
    
    [importImageNode removeFromParent];
    [importImageNode removeAllActions];
    importImageNode.texture = nil;
    
    if (IS_IPHONE)
    {
        BOOL isselectedTakePicture = [[NSUserDefaults standardUserDefaults] boolForKey:@"iseSelectedTakePicture"];
        if (isselectedTakePicture == YES)
        {
            //daimportebuli imigebis texturit sheqmili ready piqcheri.....
            readyPictureNode = [SKSpriteNode spriteNodeWithTexture:saveTextureForimportImg];
        }
       else
       {
           // chveulebrivi suratebistvis wamogebuli cxovelis imigi.....
           readyPictureNode = [SKSpriteNode spriteNodeWithImageNamed:self.animalName];
       }
        
        if (IS_IPHONE_6) {
            readyPictureNode.zPosition = 2;
            readyPictureNode.position  = CGPointMake(180, centerPozitionY);
            readyPictureNode.xScale = readyPictureNode.yScale  = 0.59;
            [self addChild:readyPictureNode];
        }
        else
        {
            readyPictureNode.zPosition = 2;
            readyPictureNode.position  = CGPointMake(157, 163);
            readyPictureNode.xScale = readyPictureNode.yScale  = 0.495;
            [self addChild:readyPictureNode];
        }
        
        for (int i=0; i<cropNodesArray.count; i++)
        {
            PuzzleSprite * sprite = [cropNodesArray objectAtIndex:i];
            [sprite removeFromParent];
            [sprite removeAllActions];
            sprite.texture = nil;
        }
        
        SKAction *moveAction = [SKAction moveTo:CGPointMake(centerPozitionX, centerPozitionY) duration:0.5];
        [readyPictureNode runAction:moveAction];
        
        if (IS_IPHONE_6) {
            SKAction *scaleAction = [SKAction scaleTo:0.67 duration:0.5];
            [readyPictureNode runAction:scaleAction];
        }else{
            SKAction *scaleAction = [SKAction scaleTo:0.55 duration:0.5];
            [readyPictureNode runAction:scaleAction];
        }
    }
    else
    {
        readyPictureNode = [SKSpriteNode spriteNodeWithImageNamed:self.animalName];
        readyPictureNode.zPosition = 2;
        readyPictureNode.position  = CGPointMake(centerPozitionX-175, centerPozitionY);
        readyPictureNode.xScale = readyPictureNode.yScale  = 0.495;
        [self addChild:readyPictureNode];
        
        for (int i=0; i<cropNodesArray.count; i++){
            PuzzleSprite * sprite = [cropNodesArray objectAtIndex:i];
            [sprite removeFromParent];
            [sprite removeAllActions];
            sprite.texture = nil;
        }
        
        SKAction *moveAction = [SKAction moveTo:CGPointMake(centerPozitionX, centerPozitionY) duration:0.5];
        [readyPictureNode runAction:moveAction];
        
        SKAction *scaleAction = [SKAction scaleTo:0.56 duration:0.5];
        [readyPictureNode runAction:scaleAction];
    }
}


- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(void) rotateByAngle:(SKSpriteNode *)cropNode
{
    float minrotate = M_PI_2 / 3;
    float maxtotate = M_PI_2 / 1.5;
    self.puzzleRotate =  [self randomFloatBetween:minrotate and:maxtotate];
    cropNode.zRotation = _puzzleRotate;
}


- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void) loadBackground
{
    if (IS_IPAD)
    {
        backgroundImg = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
        backgroundImg.position = CGPointMake(centerPozitionX, centerPozitionY);
        backgroundImg.zPosition=-5;
        backgroundImg.xScale=backgroundImg.yScale=0.5;
        [self addChild:backgroundImg];
    }
    else
    {
        if (isIphone5)
        {
            backgroundImg = [SKSpriteNode spriteNodeWithImageNamed:@"background_iphone5.jpg"];
            backgroundImg.position = CGPointMake(centerPozitionX, centerPozitionY);
            backgroundImg.zPosition=-5;
            backgroundImg.xScale=backgroundImg.yScale=0.5;
            if (IS_IPHONE_6) {
                 backgroundImg.xScale=backgroundImg.yScale=0.59;
            }
            [self addChild:backgroundImg];
        }
        else
        {
            backgroundImg = [SKSpriteNode spriteNodeWithImageNamed:@"background 960.jpg"];
            backgroundImg.position = CGPointMake(centerPozitionX, centerPozitionY);
            backgroundImg.zPosition=-5;
            backgroundImg.xScale=backgroundImg.yScale=0.5;
            [self addChild:backgroundImg];
        }
    }
}

-(void)dealloc
{
     
}

@end

//
//  GameScene.m
//  Puzzle
//
//  Created by anzori  on 10/3/14.
//  Copyright (c) 2014 anzori . All rights reserved.
//

//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
//#define IS_IPAD    (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

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



#import "GameScene.h"
#import "UIImage+Crop.h"
#import "ImportImageScene.h"

@implementation GameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size])
    {
        cropNodesArray      = [[NSMutableArray alloc] init];
        PuzzlsArray         = [[NSMutableArray alloc] init];
        animalsArray        = [[NSMutableArray alloc] init];
        puzzlesSpritesArray = [[NSMutableArray alloc] init];
        readyPuzzlesArray   = [[NSMutableArray alloc] init];
        
        initialPositionsArray     = [[NSMutableArray alloc] init];
        destinationPositionsArray = [[NSMutableArray alloc] init];
        
        centerPozitionX = [[UIScreen mainScreen] bounds].size.width/2;
        centerPozitionY = [[UIScreen mainScreen] bounds].size.height/2;
        zPositionCounter = 0;
        setPuzzlesCounter = 0;

        if (IS_IPAD)
        {
            self.scaleIn = 1;
            self.scaleOut = 0.75;
            self.JumpScale = 1.1;
            self.moveArea = 720;
            self.maxMveX  = 1020;
            self.maxMoveY = 740;
            self.minMoveY = 10;
            
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(1024, 768)];
            background.position = CGPointMake(centerPozitionX, centerPozitionY);
            [self addChild:background];
            background.zPosition = -10;
            
            
        }
        if (IS_IPHONE)
        {
            if (IS_IPHONE_5)
            {
                self.scaleIn = 1;
                self.scaleOut = 1;
                self.JumpScale = 1.1;
                self.moveArea  = 350;
                self.maxMveX   = 520;
                self.maxMoveY  = 278;
                self.minMoveY  = 45;
                self.scaleForSelectedImg = 1.0;
            }
            else
            {
                self.maxMveX = 443;
                self.minMoveY = 37;
                self.maxMoveY = 285;
                self.moveArea = 335;
                self.scaleOut = 1;
                self.scaleIn = 1;
                self.JumpScale = 1.1;
                self.scaleForSelectedImg = 1.0;
                
            }
//            SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(590, 500)];
//            background.position = CGPointMake(centerPozitionX, centerPozitionY);
//            [self addChild:background];
//            background.zPosition = -10;
        }
        
    
        
        PuzzlsArray = [self getPazzlsArray];
        [self shufflingArray:PuzzlsArray];
        
        for (int i = 0; i<PuzzlsArray.count; i++)
        {
            [animalsArray addObject:PuzzlsArray[i][@"name"]];
        }
        
        [self getrandAnimalName];
        
//        addOriginAndblackPTimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                                   target:self
//                                                                 selector:@selector(addNinePuzzlesModel)
//                                                                 userInfo:nil repeats:NO];
        
        addOriginAndblackPTimerForSixTeen = [NSTimer scheduledTimerWithTimeInterval:1
                                                                   target:self
                                                                 selector:@selector(addSixteenPuzzlesModel)
                                                                 userInfo:nil repeats:NO];
        
        
        
        [self getPointsFropPlists];
        
      //  [self addimportImage];
        
//        SelectedImage = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(50, 30)];
//        SelectedImage.position = CGPointMake (centerPozitionX + 180, centerPozitionY - 100);
//        SelectedImage.name = @"slectedImage";
//        [self addChild:SelectedImage];
//        SelectedImage.zPosition = 20;
//        
//        takeImage     = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(50, 30)];
//        takeImage.position = CGPointMake(centerPozitionX-180, centerPozitionY -100);
//        takeImage.name = @"takeImage";
//        [self addChild:takeImage];
//        takeImage.zPosition = 20;
    }
    return self;
}

-(void) addSixteenPuzzlesModel
{
    if (IS_IPHONE)
    {
        addSixteenPuzzleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addSixteenMaskPuzzle) userInfo:nil repeats:NO];
        [self addOriginalAndBlackPicturesForIphone];
    }
    else
    {
        [self addOriginalAndBlackPicturesForPad];
    }
    
    [addOriginAndblackPTimer invalidate];
    addOriginAndblackPTimer = nil;
}

-(void) addNinePuzzlesModel
{
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
    originalImage = [SKSpriteNode spriteNodeWithImageNamed:@"spilo.png"];
    originalImage.position = CGPointMake(158, 162);
    originalImage.xScale = originalImage.yScale = 0.5;
    [self addChild:originalImage];
    NSLog(@"%f %f %f %f", originalImage.position.x, originalImage.position.y, originalImage.frame.size.width, originalImage.frame.size.height);
    
    blackPictureNode = [SKSpriteNode spriteNodeWithImageNamed:@"spiloblack.png"];
    blackPictureNode.position = CGPointMake(157, 163);
    blackPictureNode.xScale = blackPictureNode.yScale = 0.495;
    [self addChild:blackPictureNode];
    blackPictureNode.zPosition = -1;
}

-(void) addOriginalAndBlackPicturesForPad
{
    originalImage = [SKSpriteNode spriteNodeWithImageNamed:@"spilo_pad.png"];
    originalImage.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    originalImage.xScale = originalImage.yScale = 0.5;
    [self addChild:originalImage];
    
    blackPictureNode = [SKSpriteNode spriteNodeWithImageNamed:@"spilo_pad_black.png"];
    blackPictureNode.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    blackPictureNode.xScale = blackPictureNode.yScale = 0.5;
    [self addChild:blackPictureNode];
    blackPictureNode.zPosition = -1;
}

-(void)getPointsFropPlists
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PuzzlesPoints" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    if (IS_IPAD)
    {
        screenResolution = @"iPad";
    }
    
    if (IS_IPHONE)
    {
        if (IS_IPHONE_5)
        {
            screenResolution = @"r4";
        }
        else
        {
            screenResolution = @"r3.5";
        }
    }
    
       destinationPosition = array[0][screenResolution][@"destinationPosition"];
    
    
    
    CGPoint point = CGPointMake([destinationPosition[@"x"] intValue], [destinationPosition[@"y"] intValue]);
    [destinationPositionsArray addObject:[NSValue valueWithCGPoint:point]];
    CGPoint positiion = [[destinationPositionsArray objectAtIndex:0] CGPointValue];
    NSLog(@"%f %f",positiion.x, positiion.y);
    
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
    //   if(IS_IPAD) arrayName = [arrayName stringByAppendingString:@"_ipad"];
    NSArray * array = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:arrayName ofType:@"plist"]];
    return  [[NSMutableArray alloc] initWithArray:array];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    zPositionCounter +=3;
    UITouch *touch = [touches anyObject];
    CGPoint point      = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:point];
    //
    float MaxZValue = 0.0f;
    //
    for (int i=0; i<cropNodesArray.count; i++)
    {
        PuzzleSprite * sprite = [cropNodesArray objectAtIndex:i];
        CGRect frame = sprite.touchArrea;
        
        if (CGRectContainsPoint(frame, point))
        {
            //
            if(zPositionCounter == 1)
            {
                selectedCropNode = sprite;
                selectedCropNode.zPosition = 2;
                return;
            }
            //
            if(MaxZValue <= sprite.zPosition)
            {
                MaxZValue = sprite.zPosition;
                selectedCropNode = sprite;
                selectedCropNode.zPosition = zPositionCounter;
            }
            //
        }
    }
    SKAction *rotation1 =  [SKAction rotateToAngle:0 duration:0.3];
    [selectedCropNode runAction:rotation1];
    
    //
    if ([node.name isEqualToString:@"importImage"])
    {
        [self removeAllChildren];
        [self removeAllActions];
        
        ImportImageScene *menuScene = [ImportImageScene sceneWithSize:self.view.frame.size];
        menuScene.scaleMode = SKSceneScaleModeFill;
        [self.view presentScene:menuScene];
    }
    
    if ([node.name isEqualToString:@"slectedImage"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker
                                                                                                 animated:YES
                                                                                               completion:^{
                                                                                                   
                                                                                               }];
    }
    
    if ([node.name isEqualToString:@"takeImage"])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker
                                                                                                 animated:YES
                                                                                               completion:^{
                                                                                               }];
    }
}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    curTouchPoint      = [touch locationInView:self.view];
    previousTouchPoint = [touch previousLocationInView:self.view];
    
    selectedCropNode.position   = CGPointMake( selectedCropNode.position.x + (curTouchPoint.x - previousTouchPoint.x), selectedCropNode.position.y - (curTouchPoint.y - previousTouchPoint.y));
    
    selectedCropNode.touchArrea = CGRectMake(selectedCropNode.position.x - selectedCropNode.touchArrea.size.width/2,
                                             selectedCropNode.position.y - selectedCropNode.touchArrea.size.height/2,
                                             selectedCropNode.touchArrea.size.width,
                                             selectedCropNode.touchArrea.size.height);
    if (IS_IPAD)
    {
        if (self.moveArea > selectedCropNode.position.x)
        {
            if(!_isRotate)
            {
                SKAction *action = [SKAction scaleTo:self.scaleIn duration:0.3];
                [selectedCropNode runAction:action];
                
                SKAction *rotation1 =  [SKAction rotateToAngle:0 duration:0.3];
                [selectedCropNode runAction:rotation1];
                self.isRotate = YES;
            }
        }
        
        if (self.moveArea <= selectedCropNode.position.x)
        {
            if(_isRotate)
            {
                SKAction *action = [SKAction scaleTo:self.scaleOut duration:0.3];
                [selectedCropNode runAction:action];
                
                SKAction *rotation2 = [SKAction rotateToAngle:_puzzleRotate duration:0.3];
                [selectedCropNode runAction:rotation2];
                self.isRotate  = NO;
            }
        }
    }
    
    if (selectedCropNode.position.x >= self.maxMveX)
    {
        selectedCropNode.position = CGPointMake(self.maxMveX, selectedCropNode.position.y);
    }
    
    if (selectedCropNode.position.y <= self.minMoveY)
    {
        selectedCropNode.position = CGPointMake(selectedCropNode.position.x, self.minMoveY);
    }
    
    if (selectedCropNode.position.y >= self.maxMoveY)
    {
        selectedCropNode.position = CGPointMake(selectedCropNode.position.x, self.maxMoveY);
    }
    if (selectedCropNode.position.x < 0)
    {
        selectedCropNode.position = CGPointMake(0, selectedCropNode.position.y);
    }
    
    
    NSLog(@"%f %f", selectedCropNode.position.x, selectedCropNode.position.y);
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect destFrame = selectedCropNode.touchArrea;
    
    
    if (CGRectContainsPoint(destFrame, selectedCropNode.destinationPosition))
    {
        [selectedCropNode setUserInteractionEnabled:NO];
        
        [selectedCropNode runAction:[SKAction moveTo:selectedCropNode.destinationPosition duration:0.3] completion:^{
            
            [selectedCropNode runAction:[SKAction scaleTo:self.JumpScale duration:0.1] completion:^{
                
                [selectedCropNode runAction:[SKAction scaleTo:self.scaleForSelectedImg duration:0.3]completion:^{
                    setPuzzlesCounter+=1;
                    if (setPuzzlesCounter == 9)
                    {
                        [self loadRedyPicture];
                    }
                    
                }];
                    selectedCropNode = nil;
                }];
            }];
        
     
        [cropNodesArray removeObject:selectedCropNode];
        
        [readyPuzzlesArray addObject:selectedCropNode];
    }
    else
    {
        [selectedCropNode setUserInteractionEnabled:NO];
        
        SKAction *rotation2 = [SKAction rotateToAngle:_puzzleRotate duration:0.3];
        [selectedCropNode runAction:rotation2];
        
        
        
        if (self.moveArea > selectedCropNode.position.x )
        {
            SKAction *scaleAction = [SKAction scaleTo:self.scaleForSelectedImg duration:0.3];
            [selectedCropNode runAction:scaleAction];
            
            SKAction *movePuzzleOut = [SKAction moveTo:CGPointMake(self.moveArea, selectedCropNode.position.y) duration:0.3];
            [selectedCropNode runAction:movePuzzleOut];
                
            selectedCropNode.touchArrea = CGRectMake(self.moveArea - selectedCropNode.touchArrea.size.width/2,
                                                         selectedCropNode.position.y - selectedCropNode.touchArrea.size.height/2,
                                                         selectedCropNode.touchArrea.size.width,
                                                         selectedCropNode.touchArrea.size.height);
            
            
            
            
        }else
        {
          //  selectedCropNode.position = selectedCropNode.position;
        }
    }
    _isRotate = NO;
}


-(void)movePuzzles
{
//    [originImgContur removeFromParent];
//    [originImgContur removeAllActions];
    
//    [originalImage removeFromParent];
//    [originalImage removeAllActions];
    
    NSLog(@"%lu", (unsigned long)cropNodesArray.count);
    for (int i=0; i<cropNodesArray.count; i++)
    {
        PuzzleSprite *sprite = [cropNodesArray objectAtIndex:i];
        SKAction *moveUp = [SKAction moveTo:[[initialPositionsArray objectAtIndex:i] CGPointValue] duration:0.3];
        [sprite runAction:moveUp completion:^{
            
            sprite.touchArrea = CGRectMake(sprite.position.x - sprite.touchArrea.size.width/2,
                                           sprite.position.y - sprite.touchArrea.size.height/2,
                                           sprite.touchArrea.size.width,
                                           sprite.touchArrea.size.height);
            
            NSLog(@"%f %f", sprite.position.x, sprite.position.y);
        }];
        
        SKAction *scaleAction = [SKAction scaleTo:self.scaleForSelectedImg duration:0.3];
        [sprite runAction:scaleAction];
        
      //  [self rotateByAngle:sprite];
    }
    
    [puzzlesMoveTimer invalidate];
    puzzlesMoveTimer = nil;
}

-(void) addimportImage
{
    ImportImageBt = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(50, 50)];
    ImportImageBt.position = CGPointMake(centerPozitionX-200, centerPozitionY-130);
    ImportImageBt.zPosition = 10;
    [ImportImageBt setName:@"importImage"];
    [self addChild:ImportImageBt];
}

-(void)addMaskPuzzleForIpad
{
//    [originalImage removeFromParent];
//    [originalImage removeAllActions];
//    originalImage.texture = nil;
    
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi_Pad"];
    originImgContur.position = CGPointMake(centerPozitionX-175, centerPozitionY);
    [self addChild:originImgContur];
    originImgContur.xScale = originImgContur.yScale = 0.5;
    originImgContur.zPosition = 2;
    
    UIImage *cropImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spilo_pad" ofType:@"png"]];
    
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
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(135, 585);
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, sprite1.position.y - sprite1.frame.size.height/2, 200, 200);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = NO;
    sprite1.zPosition = 1;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(335, 562);
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, sprite2.position.y - sprite2.frame.size.height/2, 200, 200);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = NO;
    sprite2.zPosition = 1;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(537, 585);
    sprite3.touchArrea = CGRectMake(sprite3.position.x-sprite3.frame.size.width/2, sprite3.position.y-sprite3.frame.size.height/2, 200, 200);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = NO;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(157, 385);
    sprite4.touchArrea = CGRectMake(sprite4.position.x-sprite4.frame.size.width/2, sprite4.position.y-sprite4.frame.size.height/2, 200, 200);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = NO;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic5.size];
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(335, 384);
    sprite5.touchArrea = CGRectMake(sprite5.position.x-sprite5.frame.size.width/2, sprite5.position.y-sprite5.frame.size.height/2, 200, 200);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = NO;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
    
    PuzzleSprite *sprite6 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    [sprite6 addChild:scropNode6];
    sprite6.position = CGPointMake(515, 383);
    sprite6.touchArrea = CGRectMake(sprite6.position.x-sprite6.frame.size.width/2, sprite6.position.y-sprite6.frame.size.height/2, 200, 200);
    [self addChild:sprite6];
    sprite6.userInteractionEnabled = NO;
    sprite6.destinationPosition = sprite6.position;
    [cropNodesArray addObject:sprite6];
    
    PuzzleSprite *sprite7 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic7.size];
    [sprite7 addChild:scropNode7];
    sprite7.position = CGPointMake(136, 183);
    sprite7.touchArrea = CGRectMake(sprite7.position.x-sprite7.frame.size.width/2, sprite7.position.y-sprite7.frame.size.height/2, 200, 200);
    [self addChild:sprite7];
    sprite7.userInteractionEnabled = NO;
    sprite7.destinationPosition = sprite7.position;
    [cropNodesArray addObject:sprite7];
    
    PuzzleSprite *sprite8 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic8.size];
    [sprite8 addChild:scropNode8];
    sprite8.position = CGPointMake(336, 205);
    sprite8.touchArrea = CGRectMake(sprite8.position.x-sprite8.frame.size.width/2, sprite8.position.y-sprite8.frame.size.height/2, 200, 200);
    [self addChild:sprite8];
    sprite8.userInteractionEnabled = NO;
    sprite8.destinationPosition = sprite8.position;
    [cropNodesArray addObject:sprite8];
    
    PuzzleSprite *sprite9 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic9.size];
    [sprite9 addChild:scropNode9];
    sprite9.position = CGPointMake(537, 182);
    sprite9.touchArrea = CGRectMake(sprite9.position.x-sprite9.frame.size.width/2, sprite9.position.y-sprite9.frame.size.height/2, 200, 200);
    [self addChild:sprite9];
    sprite8.userInteractionEnabled = NO;
     sprite9.destinationPosition = sprite9.position;
    [cropNodesArray addObject:sprite9];
    
    [addMaskTime invalidate];
    addMaskTime = nil;
    //
    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
}

-(void) addOriginalImageContur
{
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi2 small.png"];
    originImgContur.position = CGPointMake(158, 163);
    [self addChild:originImgContur];
    originImgContur.xScale = originImgContur.yScale = 0.5;
    originImgContur.zPosition = 2;
}

-(void)addMaskPuzzle
{
    [self addOriginalImageContur];
    //
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spilo" ofType:@"png"]];
    [self woundingPuzzle:image];

    
    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
    [addMaskTime invalidate];
    addMaskTime = nil;
}

-(void)addSixteenMaskPuzzle
{
    [self addOriginalImageContur];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spilo" ofType:@"png"]];
    
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
    CGRect cropRect1 = CGRectMake(0, -45, image.size.width/3, image.size.height/3);
    CGRect cropRect2 = CGRectMake(100, -7, image.size.width/3, image.size.height/3);
    CGRect cropRect3 = CGRectMake(186, -128, image.size.width/2, image.size.height/2);
    CGRect cropRect4 = CGRectMake(370, -90, image.size.width/2, image.size.height/2);
    CGRect cropRect5 = CGRectMake(-50, 30, image.size.width/2, image.size.height/2);
    
    UIImage *image1 = [image cropeImageWithFrame:cropRect1];
    UIImage *image2 = [image cropeImageWithFrame:cropRect2];
    UIImage *image3 = [image cropeImageWithFrame:cropRect3];
    UIImage *image4 = [image cropeImageWithFrame:cropRect4];
    UIImage *image5 = [image cropeImageWithFrame:cropRect5];
    
    SKTexture *textur1 = [SKTexture textureWithImage:image1];
    SKTexture *textur2 = [SKTexture textureWithImage:image2];
    SKTexture *textur3 = [SKTexture textureWithImage:image3];
    SKTexture *textur4 = [SKTexture textureWithImage:image4];
    SKTexture *textur5 = [SKTexture textureWithImage:image5];
    
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
    
    SKSpriteNode *mask1 = [self sixTeenMaskForIndex:1];
    SKSpriteNode *mask2 = [self sixTeenMaskForIndex:2];
    SKSpriteNode *mask3 = [self sixTeenMaskForIndex:3];
    SKSpriteNode *mask4 = [self sixTeenMaskForIndex:4];
    SKSpriteNode *mask5 = [self sixTeenMaskForIndex:5];
    
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
    
    PuzzleSprite *sprite1 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic1.size];
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(75, 257);
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, /*320 -*/ sprite1.position.y - sprite1.frame.size.height/2, 80, 80);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = NO;
    sprite1.zPosition = 1;
    sprite1.xScale = sprite1.yScale = self.scaleForSelectedImg;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(126, 247);
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, /*320 -*/ sprite2.position.y - sprite2.frame.size.height/2, 80, 80);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = NO;
    sprite2.zPosition = 1;
    sprite2.xScale = sprite2.yScale = self.scaleForSelectedImg;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(189, 257);
    sprite3.touchArrea = CGRectMake(sprite3.position.x - sprite3.frame.size.width/2, /*320 -*/ sprite3.position.y - sprite3.frame.size.height/2, 80, 80);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = NO;
    sprite3.zPosition = 1;
    sprite3.xScale = sprite3.yScale = self.scaleForSelectedImg;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(250, 247);
    sprite4.touchArrea = CGRectMake(sprite4.position.x - sprite4.frame.size.width/2, /*320 -*/ sprite4.position.y - sprite4.frame.size.height/2, 80, 80);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = NO;
    sprite4.zPosition = 1;
    sprite4.xScale = sprite4.yScale = self.scaleForSelectedImg;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(75, 200);
    sprite5.touchArrea = CGRectMake(sprite5.position.x - sprite5.frame.size.width/2, /*320 -*/ sprite5.position.y - sprite5.frame.size.height/2, 80, 80);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = NO;
    sprite4.zPosition = 1;
    sprite5.xScale = sprite5.yScale = self.scaleForSelectedImg;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
}

-(void) woundingPuzzle:(UIImage *) image
{
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
    [sprite1 addChild:scropNode1];
    sprite1.position = CGPointMake(76, 244);
    sprite1.touchArrea = CGRectMake(sprite1.position.x - sprite1.frame.size.width/2, /*320 -*/ sprite1.position.y - sprite1.frame.size.height/2, 80, 80);
    [self addChild:sprite1];
    sprite1.userInteractionEnabled = NO;
    sprite1.zPosition = 1;
    sprite1.xScale = sprite1.yScale = self.scaleForSelectedImg;
    sprite1.destinationPosition = sprite1.position;
    [cropNodesArray addObject:sprite1];
    
    PuzzleSprite *sprite2 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic2.size];
    [sprite2 addChild:scropNode2];
    sprite2.position = CGPointMake(157, 235);
    sprite2.touchArrea = CGRectMake(sprite2.position.x - sprite2.frame.size.width/2, 320 - sprite2.position.y - sprite2.frame.size.height/2, 80, 80);
    [self addChild:sprite2];
    sprite2.userInteractionEnabled = NO;
    sprite2.zPosition = 1;
    sprite2.xScale = sprite2.yScale = self.scaleForSelectedImg;
    sprite2.destinationPosition = sprite2.position;
    [cropNodesArray addObject:sprite2];
    
    PuzzleSprite *sprite3 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic3.size];
    [sprite3 addChild:scropNode3];
    sprite3.position = CGPointMake(238, 244);
    sprite3.touchArrea = CGRectMake(sprite3.position.x - sprite3.frame.size.width/2, 320 - sprite3.position.y - sprite3.frame.size.height/2, 80, 80);
    [self addChild:sprite3];
    sprite3.userInteractionEnabled = NO;
    sprite3.zPosition = 1;
    sprite3.xScale = sprite3.yScale = self.scaleForSelectedImg;
    sprite3.destinationPosition = sprite3.position;
    [cropNodesArray addObject:sprite3];
    
    PuzzleSprite *sprite4 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic4.size];
    [sprite4 addChild:scropNode4];
    sprite4.position = CGPointMake(85, 163);
    sprite4.touchArrea = CGRectMake(sprite4.position.x - sprite4.frame.size.width/2, 320 - sprite4.position.y - sprite4.frame.size.height/2, 80, 80);
    [self addChild:sprite4];
    sprite4.userInteractionEnabled = NO;
    sprite4.zPosition = 1;
    sprite4.xScale = sprite4.yScale = self.scaleForSelectedImg;
    sprite4.destinationPosition = sprite4.position;
    [cropNodesArray addObject:sprite4];
    
    PuzzleSprite *sprite5 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic5.size];
    [sprite5 addChild:scropNode5];
    sprite5.position = CGPointMake(157, 163);
    sprite5.touchArrea = CGRectMake(sprite5.position.x - sprite5.frame.size.width/2, 320 - sprite5.position.y - sprite5.frame.size.height/2, 80, 80);
    [self addChild:sprite5];
    sprite5.userInteractionEnabled = NO;
    sprite5.zPosition = 1;
    sprite5.xScale = sprite5.yScale = self.scaleForSelectedImg;
    sprite5.destinationPosition = sprite5.position;
    [cropNodesArray addObject:sprite5];
    
    PuzzleSprite *sprite6 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic6.size];
    [sprite6 addChild:scropNode6];
    sprite6.position = CGPointMake(230, 163);
    sprite6.touchArrea = CGRectMake(sprite6.position.x - sprite6.frame.size.width/2, 320 - sprite6.position.y - sprite6.frame.size.height/2, 80, 80);
    [self addChild:sprite6];
    sprite6.userInteractionEnabled = NO;
    sprite6.zPosition = 1;
    sprite6.xScale = sprite6.yScale = self.scaleForSelectedImg;
    sprite6.destinationPosition = sprite6.position;
    [cropNodesArray addObject:sprite6];
    
    PuzzleSprite *sprite7 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic7.size];
    [sprite7 addChild:scropNode7];
    sprite7.position = CGPointMake(76, 81);
    sprite7.touchArrea = CGRectMake(sprite7.position.x - sprite7.frame.size.width/2, 320 - sprite7.position.y - sprite7.frame.size.height/2, 80, 80);
    [self addChild:sprite7];
    sprite7.userInteractionEnabled = NO;
    sprite7.zPosition = 1;
    sprite7.xScale = sprite7.yScale = self.scaleForSelectedImg;
    sprite7.destinationPosition = sprite7.position;
    [cropNodesArray addObject:sprite7];
    
    PuzzleSprite *sprite8 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic8.size];
    [sprite8 addChild:scropNode8];
    sprite8.position = CGPointMake(157, 91);
    sprite8.touchArrea = CGRectMake(sprite8.position.x - sprite8.frame.size.width/2, 320 - sprite8.position.y - sprite8.frame.size.height/2, 80, 80);
    [self addChild:sprite8];
    sprite8.userInteractionEnabled = NO;
    sprite8.zPosition = 1;
    sprite8.xScale = sprite8.yScale = self.scaleForSelectedImg;
    sprite8.destinationPosition = sprite8.position;
    [cropNodesArray addObject:sprite8];
    
    PuzzleSprite *sprite9 = [PuzzleSprite spriteNodeWithColor:[UIColor clearColor] size:pic9.size];
    [sprite9 addChild:scropNode9];
    sprite9.position = CGPointMake(239, 81);
    sprite9.touchArrea = CGRectMake(sprite9.position.x - sprite9.frame.size.width/2, 320 - sprite9.position.y - sprite9.frame.size.height/2, 80, 80);
    [self addChild:sprite9];
    sprite9.userInteractionEnabled = NO;
    sprite9.zPosition = 1;
    sprite9.xScale = sprite9.yScale = self.scaleForSelectedImg;
    sprite9.destinationPosition = sprite9.position;
    [cropNodesArray addObject:sprite9];
    
}

-(void) loadRedyPicture
{
    if (IS_IPHONE)
    {
        readyPictureNode = [SKSpriteNode spriteNodeWithImageNamed:@"spilo.png"];
        readyPictureNode.zPosition = 2;
        readyPictureNode.position  = CGPointMake(157, 163);
        readyPictureNode.xScale = readyPictureNode.yScale  = 0.495;
        [self addChild:readyPictureNode];
        
        for (int i=0; i<readyPuzzlesArray.count; i++)
        {
            PuzzleSprite * sprite = [readyPuzzlesArray objectAtIndex:i];
            [sprite removeFromParent];
            [sprite removeAllActions];
            sprite.texture = nil;
        }
        
        [blackPictureNode removeAllActions];
        [blackPictureNode removeFromParent];
        blackPictureNode.texture = nil;
        
        SKAction *moveAction = [SKAction moveTo:CGPointMake(centerPozitionX, centerPozitionY) duration:0.5];
        [readyPictureNode runAction:moveAction];
        
        SKAction *scaleAction = [SKAction scaleTo:0.55 duration:0.5];
        [readyPictureNode runAction:scaleAction];
    }
    else
    {
        readyPictureNode = [SKSpriteNode spriteNodeWithImageNamed:@"spilo_pad.png"];
        readyPictureNode.zPosition = 2;
        readyPictureNode.position  = CGPointMake(centerPozitionX-175, centerPozitionY);
        readyPictureNode.xScale = readyPictureNode.yScale  = 0.495;
        [self addChild:readyPictureNode];
        
        for (int i=0; i<readyPuzzlesArray.count; i++)
        {
            PuzzleSprite * sprite = [readyPuzzlesArray objectAtIndex:i];
            [sprite removeFromParent];
            [sprite removeAllActions];
            sprite.texture = nil;
        }
        
        [blackPictureNode removeAllActions];
        [blackPictureNode removeFromParent];
        blackPictureNode.texture = nil;
        
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

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(590, 500)];
    background.position = CGPointMake(centerPozitionX, centerPozitionY);
    [self addChild:background];
    background.zPosition = -10;
    
    [self removeAllChildren];
    [self removeAllActions];
    originalImage.texture=nil;
    originImgContur.texture=nil;
    
    for (int i=0; i<cropNodesArray.count; i++)
    {
        PuzzleSprite * sprite = [cropNodesArray objectAtIndex:i];
        [sprite removeFromParent];
        [sprite removeAllActions];
        sprite.texture = nil;
    }
    
    for (int i=0; i<readyPuzzlesArray.count; i++)
    {
        PuzzleSprite * sprite = [readyPuzzlesArray objectAtIndex:i];
        [sprite removeAllActions];
        sprite.texture = nil;
    }
    
    UIImage *cropImage;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        cropImage = info[UIImagePickerControllerOriginalImage];
        
        NSLog(@"%f %f", cropImage.size.width, cropImage.size.height);
        
        NSLog(@"%ld", cropImage.imageOrientation);
        
        if (cropImage.imageOrientation == 1)
        {
            CGRect cropRect = CGRectMake((cropImage.size.width-cropImage.size.height)/2, 0, cropImage.size.height, cropImage.size.height);   // set frame as you need
            cropImage = [self croppIngimageByImageName:cropImage toRect:cropRect];
            cropImage = [UIImage imageWithCGImage:[cropImage CGImage] scale:1.0 orientation: UIImageOrientationDown];
        }
        
        if (cropImage.imageOrientation == 0)
        {
            CGRect cropRect = CGRectMake((cropImage.size.width-cropImage.size.height)/2, 0, cropImage.size.height, cropImage.size.height);   // set frame as you need
            cropImage = [self croppIngimageByImageName:cropImage toRect:cropRect];
        }
        if (cropImage.imageOrientation == 3)
        {
            CGRect cropRect = CGRectMake((cropImage.size.height-cropImage.size.width)/2, 0, cropImage.size.width, cropImage.size.width);   // set frame as you need
            cropImage = [self croppIngimageByImageName:cropImage toRect:cropRect];
            cropImage = [UIImage imageWithCGImage:[cropImage CGImage] scale:1.0 orientation: UIImageOrientationRight];
        }
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        cropImage = info[UIImagePickerControllerEditedImage];
        
        NSLog(@"%f %f", cropImage.size.width, cropImage.size.height);
        
        NSLog(@"%ld", cropImage.imageOrientation);
        
        if (cropImage.size.height<640)
        {
            CGRect cropRect = CGRectMake((cropImage.size.width-cropImage.size.height)/2, 0, cropImage.size.height, cropImage.size.height);   // set frame as you need
            cropImage = [self croppIngimageByImageName:cropImage toRect:cropRect];
        }
    }
    
    CGSize size = CGSizeMake(497, 497);
    UIGraphicsBeginImageContext(size);
    [cropImage drawInRect:CGRectMake(0,0,size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%f %f", newImage.size.width, newImage.size.height);
 
    SKTexture *texture = [SKTexture textureWithImage:newImage];
    importImageNode = [SKSpriteNode spriteNodeWithTexture:texture];
    [importImageNode setAnchorPoint:CGPointMake(0.5, 0.5)];
    importImageNode.position = CGPointMake(158, 162);
    importImageNode.xScale = importImageNode.yScale = 0.5;
    [self addChild:importImageNode];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //
    
    [self woundingPuzzle:newImage];
    
    //
    
    originImgContur = [SKSpriteNode spriteNodeWithImageNamed:@"pazlis konturebi.png"];
    originImgContur.position = CGPointMake(158, 163);
    [self addChild:originImgContur];
    originImgContur.zPosition = 200;
    originImgContur.xScale = originImgContur.yScale = 0.5;
    originImgContur.zPosition = 2;
    
    
    puzzlesMoveTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                      selector:@selector(movePuzzles)
                                                      userInfo:nil repeats:NO];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end

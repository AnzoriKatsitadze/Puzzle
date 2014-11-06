//
//  GameScene.h
//  Puzzle
//

//  Copyright (c) 2014 anzori . All rights reserved.
//

#import "PuzzleSprite.h"
#import "AVCamViewController.h"
#import <SpriteKit/SpriteKit.h>
static NSString * const completeAnNodeName = @"notMovable";

@class MenuScene;
@class PuzzleSprite;

@interface GameScene : SKScene<UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCamViewControllerDelegate>
{
    //selected images property
    SKSpriteNode *importImageNode;
    
    SKSpriteNode *SelectedImage;
    SKSpriteNode *takeImage;
    
    //
    
    PuzzleSprite *selectedCropNode;
    
    SKSpriteNode *ImportImageBt;
    SKSpriteNode *selectedPhoto;
    SKSpriteNode *takePhoto;
    
    PuzzleSprite *puzzleSprite1;
    
    
    CGPoint curTouchPoint;
    CGPoint previousTouchPoint;
    
    NSMutableArray * cropNodesArray;
    NSMutableArray * PuzzlsArray;
    NSMutableArray * animalsArray;
    NSMutableArray * puzzlesSpritesArray;
    
    SKSpriteNode *picFrame;
    
    // 9 Puzzles Timer
    NSTimer *puzzlesMoveTimer;
    NSTimer *addMaskTime;
    NSTimer *addOriginAndblackPTimer;
    NSTimer *addImageConturTimer;
    
    // 16 puzzles Timer
    NSTimer *addOriginAndblackPTimerForSixTeen;
    NSTimer *addSixteenPuzzleTimer;
    
    SKSpriteNode *originalImage;
    SKSpriteNode *originImgContur;
    SKSpriteNode *readyPictureNode;
    
    SKSpriteNode *backgroundImg;
    
    float centerPozitionX;
    float centerPozitionY;
    
    float uiscreenWidth;
    float uiscreenHeight;
    
    int zPositionCounter;
    
    NSMutableArray *initialPositionsArray;
    NSMutableArray *destinationPositionsArray;
    
    int setPuzzlesCounter;
    
    NSDictionary *destinationPosition;
    NSString * screenResolution;
    
    SKSpriteNode *blackArea;
    
    SKSpriteNode *homeButton;
    SKTexture *saveTextureForimportImg;
    
    BOOL isIphone5;
    
    AVCamViewController* avCamViewCont;
}
@property (nonatomic, assign) BOOL    isRotate;

@property (nonatomic, assign) CGPoint savePuzzlePoint;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) float puzzleRotate;

@property (nonatomic) int setPuzzlesCounter;

@property (nonatomic) float scaleIn;
@property (nonatomic) float scaleOut;
@property (nonatomic) float JumpScale;
@property (nonatomic) int   moveArea;
@property (nonatomic) int   maxMoveY;
@property (nonatomic) int   minMoveY;
@property (nonatomic) int   maxMveX;
@property (nonatomic) float scaleForSelectedImg;

@property (nonatomic, strong) MenuScene *menuScene;

@property (nonatomic) int saveAnimalIndex;
@property (nonatomic) NSString *animalName;

@property (nonatomic, strong) UIImage *teakeImage;
- (void) useImage;

-(void) loadRedyPicture;
- (void) updateZpositions:(PuzzleSprite *) sprite;

@end

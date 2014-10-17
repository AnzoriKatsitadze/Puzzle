//
//  GameScene.h
//  Puzzle
//

//  Copyright (c) 2014 anzori . All rights reserved.
//

#import "PuzzleSprite.h"
#import <SpriteKit/SpriteKit.h>

static NSString * const completeAnNodeName = @"notMovable";

@interface GameScene : SKScene<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    
    NSMutableArray * readyPuzzlesArray;
    NSMutableArray * cropNodesArray;
    NSMutableArray * PuzzlsArray;
    NSMutableArray * animalsArray;
    NSMutableArray * puzzlesSpritesArray;
    
    SKSpriteNode *picFrame;
    
    // 9 Puzzles Timer
    NSTimer *puzzlesMoveTimer;
    NSTimer *addMaskTime;
    NSTimer *addOriginAndblackPTimer;
    
    // 16 puzzles Timer
    NSTimer *addOriginAndblackPTimerForSixTeen;
    NSTimer *addSixteenPuzzleTimer;
    
    SKSpriteNode *originalImage;
    SKSpriteNode *originImgContur;
    SKSpriteNode *blackPictureNode;
    SKSpriteNode *readyPictureNode;
    
    float centerPozitionX;
    float centerPozitionY;
    int zPositionCounter;
    
    NSMutableArray *initialPositionsArray;
    NSMutableArray *destinationPositionsArray;
    
    int setPuzzlesCounter;
    
    NSDictionary *destinationPosition;
    NSString * screenResolution;
    
}
@property (nonatomic, assign) BOOL    isRotate;

@property (nonatomic, assign) CGPoint savePuzzlePoint;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) float puzzleRotate;

@property (nonatomic) float scaleIn;
@property (nonatomic) float scaleOut;
@property (nonatomic) float JumpScale;
@property (nonatomic) int   moveArea;
@property (nonatomic) int   maxMoveY;
@property (nonatomic) int   minMoveY;
@property (nonatomic) int   maxMveX;
@property (nonatomic) float scaleForSelectedImg;

@end
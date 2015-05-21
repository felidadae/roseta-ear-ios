
#ifndef Earing_Colors_h
#define Earing_Colors_h

#define MAIN_B 1
#define MAIN_F 0

//BackgroundColor for MainView
#define BACKGROUND_COLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]
//#define BACKGROUND_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:0]
#define BACKGROUND_COLORxsd [UIColor colorWithRed:MAIN_B green:MAIN_B blue:MAIN_B alpha:0.6]


//Containers
#define CONTAINERS_BACKGROUND_ALPHA 0.05
#define CONTAINERS_BACKGROUND_COLOR [UIColor colorWithRed:MAIN_F green:MAIN_F blue:MAIN_F alpha:CONTAINERS_BACKGROUND_ALPHA]

//Fretboard
#define X_NOTE_SPACE 0.2
#define Y_NOTE_SPACE 0.2
#define CONTAINER_MIN_X_MARGIN 50
#define CONTAINER_MIN_Y_MARGIN 50

//Note
//Backgroundcolor
#define NOTE_COLOUR colorWithRed:MAIN_B green:MAIN_B blue:MAIN_B
#define NOTE_BASE_ALPHA 0.3
#define NOTE_DELTA_STEP_ALPHA 0.006
#define NOTE_GLIDING_DELTA_STEP_ALPHA 0.001
//Border
#define NOTE_BORDER 0.75
#define NOTE_BORDER_COLOUR [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0]
//Size for >>layout<<
#define NOTE_RADIUS 32
#define NOTE_DIAMETER 2*NOTE_RADIUS
//Size for >>unactive<< note
#define NOTE_UNACTIVE_RADIUS 32
//Size and alpha delta for >>active<<
#define NOTE_TOUCHED_DELTA_ALPHA 0.2
#define NOTE_TOUCHED_RADIUS 15
#define NOTE_TOUCHED_DIAMETER 2*NOTE_TOUCHED_RADIUS
#define NOTE_ROUNDNESS NOTE_UNACTIVE_RADIUS 

//Buttons
#define BUTTON_COLOUR [UIColor colorWithRed:147.f/256.f green:98.f/256.f blue:63.f/256.f alpha:0.3]
#define BUTTON_BORDER_COLOR [UIColor colorWithRed:168.f/256.f green:95.f/256.f blue:80.f/256.f alpha:0.18]
#define BUTTON_HEIGHT 80
#define BUTTON_ALPHA 1
#define DELTA_ALPHA_STATE_CONSTANT 2
#define K 2

//TabsContainer
#define HEIGHT_OF_TABS_CONTAINER 105
#define MAGICNUMBER 0


#endif


#ifndef Earing_TunerDelegate_h
#define Earing_TunerDelegate_h

#import "NotePosition.h"


@protocol TunerDelegate <NSObject>

/* To set new tuning. >>tuning<< array contain how "strings" are tuned comparing to each other beginning from
 bottom (bottom of FretboardView); >>base<< means what frequency has note in the left bottom corner;*/
- (void) setTuning: (NSArray*) tuning withBase: (NSUInteger) base;

/* To get tuning info from NotePosition. 
 Precisely to get FrequencyIndex (the lowest frequency note in the fretboard has index == 0).
 frequencyIndex(x+1)=frequencyIndex(x)*root(12,2) */
- (unsigned) getFrequencyIndexFromPosition:  (NotePosition*) notePosition;


/* @TODO create new class for below functions. Its not logical part of Tuner*/
/* To get tuning info (NotePosition) from FrequencyIndex.*/
- (NotePosition*) getNotePositionFromFrequencyIndex: (NSUInteger) frequencyIndex;
/* To get tuning info (NotePosition) from FrequencyIndex.*/
- (NotePosition*) getNotePositionWithPreviousNotePosition: (NotePosition*) previousNotePosition withInterval: (NSUInteger) interval;
/* For two previous functions to give NotePosition in the existing fretboard*/
- (void) setFretboardSize: (NotePosition*) fretboardSize;

@end

#endif

' ============================================================
' Naive BASIC - PLAY Tutorial
' For Naive BASIC 0.8.4G and newer
' ============================================================
'
' PLAY executes a music string. Several strings separated by commas
' play simultaneously: these are channels/voices.
'
' Main parameters:
'   Txxx  - tempo
'   O0..8 - octave
'   V0..15 - volume
'   I0..10 - instrument
'
' Notes:
'   A B C D E F G - notes
'   # before a note - sharp
'   $ before a note - flat
'   & - a rest with the current note duration
'
' Durations:
'   1..12 before a note or &
'
' IMPORTANT:
'   a lowercase note plays in the current O;
'   an uppercase note plays one octave above the current O.
' ============================================================


' ------------------------------------------------------------
1 print " SIMPLEST MELODY"
' ------------------------------------------------------------
' By default: T120, O4, V15, I0.
PLAY "CDEFGAB"


' ------------------------------------------------------------
2 print " NOTES AND DURATIONS"
' ------------------------------------------------------------
' The number before a note sets its duration.
' 5 - one beat, 7 - two beats, 3 - half a beat.
PLAY "T120 O4 5c5d5e7g 3e3d 5c"


' ------------------------------------------------------------
3 print " RESTS"
' ------------------------------------------------------------
' & means a rest. Its duration can be specified before &.
PLAY "T120 O4 5c & 5e & 5g & 7c"


' ------------------------------------------------------------
4 print " TEMPO"
' ------------------------------------------------------------
' The same motif sounds at different speeds with different T values.
PLAY "T80 O4 5c5d5e5f5g5a5b5c"
PLAY "T180 O4 5c5d5e5f5g5a5b5c"


' ------------------------------------------------------------
5 print " OCTAVES"
' ------------------------------------------------------------
' O sets the current octave.
' Lowercase c,d,e... play in the current octave.
' Uppercase C,D,E... - one octave above the current octave.
PLAY "T120 O3 5c5d5e 5g5a5b O4 5c5d5e 5g5a5b O5 5c"


' ------------------------------------------------------------
6 print " SHARPS AND FLATS"
' ------------------------------------------------------------
' #C = C#, $D = Db. These are two ways to specify a black key.
PLAY "T120 O4 5c5#c5d5#d5e5f5#f5g5#g5a5#a5b5c"


' ------------------------------------------------------------
7 print " VOLUME"
' ------------------------------------------------------------
' V0..15. This is a parameter of the current channel.
PLAY "T120 O4 V4 5c5d5e5f V8 5g5a5b5c V15 5C"


' ------------------------------------------------------------
8 print " SIMPLE TWO-VOICE"
' ------------------------------------------------------------
' Two PLAY strings are separated by a comma and play simultaneously.
PLAY "T120 O4 5c5d5e5g5e5d5c","T120 O3 7c&7g&7c&7g&"


' ------------------------------------------------------------
9 print " THREE-VOICE"
' ------------------------------------------------------------
' More independent voices can be added.
PLAY "T120 O5 5c5d5e5g5e5d5c","T120 O4 5e5f5g5b5g5f5e","T120 O3 7c&7g&7c&7g&"


' ------------------------------------------------------------
10 print " EIGHT VOICES"
' ------------------------------------------------------------
' PLAY supports up to eight independent music strings.
' Here each voice has its own pattern.
PLAY "T120 O5 5c5e5g5e5c5e5g5e","T120 O5 5d5f5a5f5d5f5a5f","T120 O4 5e5g5b5g5e5g5b5g","T120 O4 5c5e5g5c5e5g5c5e","T120 O3 7c&7g&7c&7g&","T120 O3 7e&7b&7e&7b&","T120 O2 5c&5c&5g&5g&","T120 O2 7c&7c&7g&7g&"


' ------------------------------------------------------------
11 print " INSTRUMENTS: I PARAMETER"
' ------------------------------------------------------------
' I0  Piano     - decaying sine wave
' I1  Organ     - several harmonics
' I2  Guitar    - short pluck
' I3  Bass      - soft low tone
' I4  Trumpet   - rich harmonics
' I5  Flute     - almost a sine wave
' I6  Clarinet  - odd harmonics
' I7  Violin    - sustained tone + harmonics
' I8  Square    - square wave
' I9  Saw       - sawtooth wave
' I10 Noise    - noise generator
'
' I - the current channel parameter, so it can be changed
' directly inside the music string.
PLAY "T120 O5 V12 I0 cdefg I1 cdefg I2 cdefg I4 cdefg","T120 O5 V11 I5 gfedc I7 gfedc I6 gfedc I1 gfedc","T120 O4 V12 I7 c2g2c2g2 I0 cegcgecg I4 ggggcccc I5 e2e2g2g2","T120 O4 V10 I6 gfedcdef I2 cccgggcc I7 egegegeg I4 c2c2g2g2","T120 O3 V11 I3 c2c2g2g2 I8 cdefgabg I9 gfedcdef I3 c2g2c2g2","T120 O3 V9 I8 cgcgcgcg I10 c&c&g&g& I3 c2g2c2g2 I6 g2e2c2e2","T120 O2 V9 I9 cdefgabc I10 c&g&c&g& I3 c2c2g2g2 I7 c2g2c2g2","T120 O2 V8 I10 c&c&g&g& I8 cgcgcgcg I1 c2g2c2g2 I0 c2c2c2c2"


' ------------------------------------------------------------
12 print " INSTRUMENTS ONE BY ONE"
' ------------------------------------------------------------
' Naive BASIC has 11 built-in instruments.
' I selects the current timbre for that voice.
' 0 Piano   - piano, decaying sine wave.
' 1 Organ   - organ, several harmonics.
' 2 Guitar  - guitar, short pluck.
' 3 Bass    - bass, soft low tone.
' 4 Trumpet - trumpet, rich harmonics.
' 5 Flute   - flute, almost a pure sine wave.
' 6 Clarinet- clarinet, odd harmonics.
' 7 Violin  - violin, sustained tone with harmonics.
' 8 Square  - square wave.
' 9 Saw     - sawtooth wave.
' 10 Noise  - noise generator.
'
' Below, each instrument plays the same short phrase.
' This makes the timbre differences easy to hear.
PLAY "T120 O4 V12 I0 cdefg"
PLAY "T120 O4 V12 I1 cdefg"
PLAY "T120 O4 V12 I2 cdefg"
PLAY "T120 O3 V12 I3 cdefg"
PLAY "T120 O4 V12 I4 cdefg"
PLAY "T120 O5 V12 I5 cdefg"
PLAY "T120 O4 V12 I6 cdefg"
PLAY "T120 O4 V12 I7 cdefg"
PLAY "T120 O4 V12 I8 cdefg"
PLAY "T120 O4 V12 I9 cdefg"
PLAY "T120 O4 V12 I10 cdefg"


' ------------------------------------------------------------
13 print " CHANGING INSTRUMENT WITHIN ONE VOICE"
' ------------------------------------------------------------
' Here the same music string successively changes
' timbre: piano -> guitar -> flute -> violin.
PLAY "T120 O5 V13 I0 cdef I2 gfed I5 cdef I7 gfed I0 c"


' ------------------------------------------------------------
14 print " FINALE: MOZART"
' ------------------------------------------------------------
' The first approximately 15-20-second Allegro phrase from
' Eine kleine Nachtmusik, K.525, Part I.
'
' This is the same tested eight-voice fragment, but now
' each voice has its own instrument.
' Here it is especially clear why I0..I7 are useful:
' the ensemble sounds much closer to a live performance.
' ============================================================
PLAY! "T134 I0 9&O2 5g3&1d1&5g3&1d1&O4 1g1&O3 1d1&O2 1g1&O3 1b1&5d5&O6 5c3&O2 1a1&O6 5c3&O5 1a1&O3 1c1&O2 1a1&O3 1#f1&O2 1a1&O5 5d1d4&1g4&5g1g1&3b3&1g1&3g3&6#f3&O6 1c1&O5 1#f1&3a3&6g3&3a3&3g3&6#f3&O6 1c1&O5 1#f1&1g1&1g1&1c1&1c1&1g1&1g1&1b1&O2 1#f1&O4 1g1&O5 1b1&O6 1d1&O5 1b1&O6 4d5&1&","T134 I7 9&O4 5b3&3d6&O5 1d1&O2 1g1&O5 1d1&O3 1g1&O4 1b1&5d5&O3 5c3&O4 1a1&O3 5c3&O2 1a1&O4 1c1&O3 1a1&O5 1#f1&O3 1a1&5d5&O4 3b7&3&O5 1a4&1a1&1#f6&1&3a3&O4 1a1&9g3&O5 1#f6&1&3a3&O4 1a1&O3 4b1&O5 1g1&1e1&O2 1b1&3b1&O5 1a1&O4 1a3&1g1&1#f1&O2 3a7&","T134 I1 9&O5 5g3&1d1&4g4&O3 1d1&1g1&O2 1d1&O5 1g1&1b1&4d5&1&O4 5c3&O5 1a1&5c3&O4 1a1&O5 1c1&O4 1a1&O2 1#f1&O4 1a1&5d1d4&O2 9g9g9g9g1g1&3g1&O5 1#f1&1#f5&3c1&1a3&O2 1g1&1a1&O4 1#f1&O2 5b1b4&","T134 I3 9&O3 5g3&3d6&O4 1d1&O5 1g1&O4 1d1&1g1&O2 1b1&O6 5d5&O5 5c3&O3 1a1&O4 5c3&O3 1a1&O6 1c1&O5 1a1&O4 1#f1&O5 1a1&O2 5d5&O4 9g7&3&O5 1c1&O4 3#f3&O3 9b7&3&O5 1c1&O4 3#f3&O5 9d8d5&","T134 I6 9&O4 4d5&1&4g9&9&9&5&1&9d9d9d9d4d1&O2 1a1&3a5&1#f1&O5 1g1&O2 1g5&O6 1c1&1c7&","T134 I5 9&7&O3 5g9&9&9&5&9b9&3&O5 1g6&1&3b3&1g1&1a9&8&1&O4 1b7&1&5g1g4&","T134 I2 9&9&9&9&9&9&O4 7a3a9&6&7a3a9&9&6&","T134 I4 9&O1 5g3&1dO2 1dO1 5g3&1d1&1g1&1d1&1g1&1b1&O2 5d5&5c3&O1 1a1&O2 5c3&O1 1a1&O2 1c1&O1 1a1&1#f1&1a1&5dO3 1d4&O1 9g9g9g9g1gO2 1bO1 3g1aO4 1dO1 3a1bO4 1dO1 3b1#fO4 1cO1 1#fO3 1aO1 1gO4 1dO1 1gO4 1dO1 1aO4 1dO1 3a5b1b4&"

REM **LOGICAL OPERAND PLAY**
REM while music is playing =1, when music is not playing =0
REM Provides a simple way to make continuous background music:
IF NOT PLAY THEN PLAY! "abcdefg"
PRINT "MUSIC PLAYING? 0=NO 1=YES ";PLAY

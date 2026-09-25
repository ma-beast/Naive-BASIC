REM ============================================================
REM Naive BASIC 0.8.1G
REM GENERAL TUTORIAL
REM From "HELLO WORLD!" to external NBM memory
REM ============================================================
REM
REM IMPORTANT:
REM 1. Line numbers are not needed unless the line is a label
REM    for GOTO/GOSUB.
REM 2. Each section ends with PAUSE. Press any key
REM    or touch the screen to continue to the next section.
REM ============================================================


CLS
PRINT "HELLO WORLD! HELLO WORLD!"
PRINT "STARTING WITH THE SIMPLEST THING"
REM PRINT prints text and expressions on the screen.
REM A string in quotation marks prints exactly that text.
PAUSE


CLS
PRINT "SECTION 1. COMMENTS AND OUTPUT"
REM REM lets you write explanations that BASIC does not execute.
REM An apostrophe ' also starts a comment.
REM PRINT prints text, numbers, and expression results.
PRINT "THIS IS PRINT"
PRINT 123
PRINT "TEXT";123
PRINT "FIRST LINE"
PRINT "SECOND LINE"

PAUSE


CLS
PRINT "SECTION 2. POSITION AND COLOR"
REM PRINT AT sets the output position: row, column.
REM Numbering starts at zero.
PRINT AT 2,5;"TEXT AT POSITION 2,5"
INK 255
PRINT "BRIGHT WHITE TEXT"
INK 100
PRINT "ANOTHER COLOR"
PAPER 0
PRINT "PAPER 0 BACKGROUND"
REM INK and PAPER accept palette values 0..255.
REM TAB N moves the current output position by N character cells.
TAB 5
PRINT "AFTER TAB"
PAUSE


CLS
PRINT "SECTION 3. CLEARING AND SCREEN MODE"
REM CLS clears the current screen.
PRINT "THIS WILL BE ERASED NOW"
CLS
PRINT "CLS CLEARED THE SCREEN"
REM SCREEN sets the screen mode and character-cell size.
REM SCREEN 0,0 = 320x240, landscape, 8x8.
REM SCREEN 0,1 = 320x240, landscape, 4x8.
SCREEN 0,0
PRINT "SCREEN 0,0"
PRINT "SCREEN SIZE:";SCREENX;"X";SCREENY
PAUSE


CLS
PRINT "SECTION 4. FIRST SOUND"
REM BEEP duration,pitch produces a single sound.
REM duration sets the duration, pitch — pitch.
BEEP 0.25,440
PRINT "BEEP 0.25,440"
BEEP 0.15,880
PRINT "AND ONE MORE"
PAUSE


CLS
PRINT "SECTION 5. TEXT INPUT"
REM INPUT reads a value entered by the user.
REM A string variable ends with the $ symbol.
INPUT "WHAT IS YOUR NAME? ";NAME$
PRINT "HELLO, ";NAME$
REM INPUT can also be used for a number.
INPUT "HOW OLD ARE YOU? ";AGE
PRINT "YOU ARE";AGE
PAUSE


CLS
PRINT "SECTION 6. VARIABLES"
REM LET assigns a value to a variable.
REM A numeric variable does not use the $ sign.
LET A=10
LET B=25
PRINT "A=";A
PRINT "B=";B
LET A=B
PRINT "AFTER LET A=B: A=";A
REM Assignment can also be written without LET.
C=7
PRINT "C=";C
PAUSE


CLS
PRINT "SECTION 7. ARITHMETIC"
REM + addition
REM - subtraction
REM * multiplication
REM / division
REM ^ raising to a power
PRINT "2+3=";2+3
PRINT "10-4=";10-4
PRINT "6*7=";6*7
PRINT "20/5=";20/5
PRINT "2^8=";2^8
REM Parentheses determine the order of evaluation.
PRINT "(2+3)*10=";(2+3)*10
PAUSE


CLS
PRINT "SECTION 8. PERCENT AND MOD"
REM % divides a number by 100 or calculates a percentage of the following expression.
PRINT "25%=";25%
PRINT "200*15%=";200*15%
REM MOD gives the remainder after division.
PRINT "17 MOD 5=";17 MOD 5
PRINT "100 MOD 9=";100 MOD 9
PAUSE


CLS
PRINT "SECTION 9. STRING VARIABLES"
REM Strings are stored in variables ending with $.
A$="NAIVE"
B$="BASIC"
REM + joins parts of a string.
C$=A$+" "+B$+"!"
PRINT A$
PRINT B$
PRINT C$
REM STR$ converts a number to a string.
N=42
S$="ANSWER: "+STR$(N)
PRINT S$
PAUSE


CLS
PRINT "SECTION 10. STRING FUNCTIONS"
REM LEN returns the length of a string.
PRINT "LEN=";LEN("HELLO")
REM CHR$ creates a character from a numeric code.
PRINT "CHR$(65)=";CHR$(65)
REM CODE returns the code of the first character in a string.
PRINT "CODE(""A"")=";CODE("A")
REM VAL converts numeric text to a number.
PRINT "VAL(""123"")+7=";VAL("123")+7
REM INKEY$ returns the string value of the current key.
REM For a simple demonstration, we simply display it.
PRINT "INKEY$=";INKEY$
PAUSE


CLS
PRINT "SECTION 11. RANDOM NUMBERS"
REM RND returns a random number from 0 to 1.
PRINT "RND=";RND
PRINT "RND=";RND
REM RANDOMIZE starts/restarts the random-number sequence.
RANDOMIZE
PRINT "AFTER RANDOMIZE:";RND
PAUSE


CLS
PRINT "SECTION 12. FOR...NEXT LOOP"
REM FOR starts a loop.
REM TO sets the final value.
REM NEXT returns execution to FOR.
FOR I=1 TO 5
PRINT "I=";I
NEXT I
REM The loop step is one by default.
PAUSE


CLS
PRINT "SECTION 13. IF...THEN"
REM IF checks a condition.
REM THEN performs an action if the condition is true.
A=10
IF A>5 THEN PRINT "A IS GREATER THAN 5"
IF A=10 THEN PRINT "A EQUALS 10"
IF A<5 THEN PRINT "THIS WILL NOT BE PRINTED"
PAUSE


CLS
PRINT "SECTION 14. COMPARISONS"
REM = equal to
REM <> not equal to
REM < less than
REM > greater than
REM <= less than or equal to
REM >= greater than or equal to
PRINT "5=5 ->";5=5
PRINT "5<>7 ->";5<>7
PRINT "3<7 ->";3<7
PRINT "7>3 ->";7>3
PRINT "5<=5 ->";5<=5
PRINT "5>=3 ->";5>=3
REM False = 0, true = 1.
PAUSE



CLS
PRINT "SECTION 16. GOTO — JUMP"
REM GOTO requires a line-label number.
REM The numbers here are used as jump addresses.
PRINT "BEFORE THE JUMP"
GOTO 100
PRINT "THIS WILL NOT EXECUTE"
100 PRINT "GOTO BROUGHT US HERE"
PAUSE


CLS
PRINT "SECTION 17. GOSUB AND RETURN"
REM GOSUB calls a subroutine.
REM RETURN returns execution to the point of the call.
GOSUB 200
PRINT "SUBROUTINE FINISHED"
GOTO 210
200 PRINT "THIS IS A SUBROUTINE"
PRINT "IT CAN CONTAIN SEVERAL LINES"
RETURN
210 PRINT "RETURN SUCCESSFUL"
PAUSE


CLS
PRINT "SECTION 18. COMBINING CONDITIONS"
A=7
B=12
IF A<10 AND B>10 THEN PRINT "BOTH CONDITIONS ARE TRUE"
IF A=7 OR B=0 THEN PRINT "AT LEAST ONE IS TRUE"
IF NOT A=0 THEN PRINT "A IS NOT ZERO"
REM This is how comparisons and logic are combined to control a program.
PAUSE

CLS
PRINT "SECTION 15. LOGIC"
REM AND — AND
REM OR  — OR
REM NOT — NOT
PRINT "1 AND 1 =";1 AND 1
PRINT "1 AND 0 =";1 AND 0
PRINT "0 OR 1 =";0 OR 1
PRINT "0 OR 0 =";0 OR 0
PRINT "NOT 0 =";NOT 0
PRINT "NOT 1 =";NOT 1
REM Logical operations return 0 or 1.
PAUSE


CLS
PRINT "SECTION 19. DATA: DATA, READ, RESTORE"
REM DATA stores the program's initial data.
REM READ reads the next values from DATA.
REM RESTORE moves the DATA pointer back to the beginning.
DATA 10,20,30
READ A,B,C
PRINT A;B;C
RESTORE
READ D
PRINT "AFTER RESTORE D=";D
PAUSE


CLS
PRINT "SECTION 20. MATHEMATICAL FUNCTIONS"
REM ABS — absolute value
REM INT — integer part rounded down
REM SGN — sign of a number
REM SQR — square root
PRINT "ABS(-12)=";ABS(-12)
PRINT "INT(3.9)=";INT(3.9)
PRINT "SGN(-8)=";SGN(-8)
PRINT "SQR(81)=";SQR(81)
PAUSE


CLS
PRINT "SECTION 21. TRIGONOMETRY"
REM SIN, COS, TAN, COT use angles in radians.
PRINT "SIN(PI/2)=";SIN(PI/2)
PRINT "COS(0)=";COS(0)
PRINT "TAN(PI/4)=";TAN(PI/4)
PRINT "COT(PI/4)=";COT(PI/4)
PRINT "PI=";PI
PAUSE


CLS
PRINT "SECTION 22. INVERSE TRIGONOMETRY"
REM ASN — arcsin
REM ACS — arccos
REM ATN — arctan
PRINT "ASN(1)=";ASN(1)
PRINT "ACS(1)=";ACS(1)
PRINT "ATN(1)=";ATN(1)
PAUSE


CLS
PRINT "SECTION 23. EXPONENTIAL AND LOGARITHM"
REM EXP — exponential function
REM LN — natural logarithm
PRINT "EXP(1)=";EXP(1)
PRINT "LN(EXP(1))=";LN(EXP(1))
PAUSE


CLS
PRINT "SECTION 24. SCREEN AND GRAPHICS"
REM PLOT plots one point and makes it the current graphics position.
REM DRAW draws a line from the current position by a relative offset.
PLOT 40,40
DRAW 80,0
DRAW 0,60
DRAW -80,0
DRAW 0,-60
PRINT AT 2,2;"SQUARE"
PAUSE


CLS
PRINT "SECTION 25. LINE"
REM LINE x1,y1,x2,y2 draws an absolute line.
LINE 20,20,180,20
LINE 180,20,180,100
LINE 180,100,20,100
LINE 20,100,20,20
REM LINE x2,y2 continues a line from the current graphics position.
PLOT 220,40
LINE 280,100
PAUSE


CLS
PRINT "SECTION 26. CIRCLE AND PCIRCLE"
REM CIRCLE draws an unfilled circle/ellipse.
REM PCIRCLE draws a filled circle/ellipse.
CIRCLE 80,80,50
CIRCLE 220,80,60,35
PCIRCLE 80,180,30
PCIRCLE 220,180,45,25
PAUSE


CLS
PRINT "SECTION 27. TRIANGLE AND PTRIANGLE"
REM TRIANGLE draws a triangle outline.
REM PTRIANGLE draws a filled triangle.
TRIANGLE 40,40,140,40,90,130
PTRIANGLE 180,40,300,40,240,130
PAUSE


CLS
PRINT "SECTION 28. PAINT"
REM PAINT fills a closed area with the current INK.
INK 255
CIRCLE 100,100,60
PAINT 100,100
INK 180
CIRCLE 220,100,60
PAINT 220,100
PAUSE


CLS
PRINT "SECTION 29. SCROLL AND ROLL"
REM SCROLL shifts the image; the newly freed area is filled with PAPER.
REM ROLL shifts the area cyclically, wrapping the edges to the opposite side.
PRINT AT 5,5;"SCROLL / ROLL"
PLOT 40,120
DRAW 200,0
DRAW 0,40
DRAW -200,0
DRAW 0,-40
SCROLL 30,0
ROLL 30,0
PAUSE


CLS
PRINT "SECTION 30. DEVICE AND INPUT"
REM KEY — the numeric code of the current key.
REM TOUCH — 1 when touching, otherwise 0.
REM TOUCHX and TOUCHY — the touch coordinates.
PRINT "KEY=";KEY
PRINT "TOUCH=";TOUCH
PRINT "TOUCHX=";TOUCHX
PRINT "TOUCHY=";TOUCHY
PAUSE


CLS
PRINT "SECTION 31. GYROSCOPE"
REM GIRO — the screen orientation number 0..3.
REM GIROX и GIROY — device tilt values
REM as fractions from -1 to 1.
PRINT "GIRO=";GIRO
PRINT "GIROX=";GIROX
PRINT "GIROY=";GIROY
PAUSE


CLS
PRINT "SECTION 32. TIME AND DATE"
REM TIME$ returns the current time HH:MM:SS.
REM DATE$ returns the current date DD:MM:YYYY.
PRINT "TIME$=";TIME$
PRINT "DATE$=";DATE$
PAUSE


CLS
PRINT "SECTION 33. DIM ARRAYS"
REM DIM creates an array.
REM Indexes start at zero!
REM Therefore DIM A(3) creates elements A(0)..A(3).
DIM A(3)
A(0)=10
A(1)=20
A(2)=30
A(3)=40
PRINT A(0);A(1);A(2);A(3)
REM A two-dimensional array is also indexed from zero.
DIM M(2,2)
M(0,0)=1
M(1,1)=5
M(2,2)=9
PRINT "CENTER=";M(1,1);" CORNER=";M(2,2)
PAUSE


CLS
PRINT "SECTION 34. STRING ARRAYS"
REM DIM S$(3) creates S$(0)..S$(3).
DIM S$(2)
S$(0)="NAIVE"
S$(1)="BASIC"
S$(2)="!"
PRINT S$(0)+" "+S$(1)+S$(2)
PAUSE


CLS
PRINT "SECTION 35. USER FUNCTION DEFFN"
REM DEFFN creates a custom numeric function.
REM FN calls it.
DEFFN DOUBLE(X)=X*2
PRINT "FN DOUBLE(21)=";FN DOUBLE(21)
DEFFN SQUARE(X)=X*X
PRINT "FN SQUARE(7)=";FN SQUARE(7)
PAUSE


CLS
PRINT "SECTION 36. PLAY — MUSIC"
REM PLAY plays a music string and waits for it to finish.
REM PLAY! starts it in the background and immediately continues the program.
REM T — tempo, O — octave, V — volume, I — instrument.
REM A note duration is given by the number before the note.
PLAY "T140 O4 V12 I0 CDEFG"
PRINT "PLAY FINISHED, AND ONLY THEN DID WE SEE THIS"
PLAY! "T120 O4 V12 I0 5C5D5E5G"
PRINT "PLAY! IS ALREADY PLAYING IN THE BACKGROUND"
REM PLAY returns 1 while background PLAY! is active, otherwise 0.
IF NOT PLAY THEN PLAY! "T120 O4 V12 I0 5C5D5E5G"
PRINT "BACKGROUND MUSIC CHECKED"
PAUSE


CLS
PRINT "SECTION 37. MAKE — CREATING NBM"
REM MAKE X,Y,"NAME" creates an external one-byte two-dimensional array.
REM The .nbm extension is added automatically.
REM The file has no header or service bytes.
REM File size = (X+1)*(Y+1) bytes.
MAKE 15,15,"TUTORIALMEM"
POKE 0,0,255
POKE 1,2,123
POKE 15,15,42
PRINT "NBM CREATED"
PAUSE


CLS
PRINT "SECTION 38. OPEN, PEEK AND POKE"
REM OPEN(X,Y,"NAME") tries to open an existing NBM.
REM Returns 1 if the file is large enough for the specified dimensions.
REM Returns 0 if the file is missing or too small.
REM PEEK(X,Y) reads a byte.
REM POKE X,Y,BYTE writes a byte.
C=OPEN(10,10,"TUTORIALMEM")
PRINT "OPEN=";C
IF C=1 THEN PRINT "PEEK 1,2=";PEEK(1,2)
POKE 5,5,200
PRINT "AFTER POKE=";PEEK(5,5)
REM OPEN dimensions may be smaller than the dimensions used to create the file.
C=OPEN(5,5,"TUTORIALMEM")
PRINT "OPEN 5,5=";C
PAUSE


CLS
PRINT "SECTION 39. MAXIMUM NBM"
REM Dimensions use the same logic as DIM:
REM indexes start at zero.
REM Therefore MAKE 255,255 creates 256*256 = 65536 bytes.
MAKE 255,255,"TUTORIALMEM"
POKE 255,255,255
PRINT "MAXIMUM NBM=";PEEK(255,255)
PRINT "65536 BYTE = 64 KiB"
PAUSE


CLS
PRINT "FINAL. NAIVE BASIC IS A SYSTEM"
REM We started with PRINT "HELLO WORLD!"
REM and reached:
REM variables, strings, loops, conditions, and logic,
REM graphics, device input, mathematics, and arrays,
REM music, and external memory.
REM
REM The next step is not a new command, but your own programs.
PRINT "HELLO WORLD! HELLO WORLD!"
PRINT "YOU HAVE EVERYTHING YOU NEED."
PAUSE

REM **LOGICAL OPERAND PLAY**
REM while music is playing =1, when music is not playing =0
REM Provides a simple way to make continuous background music:
IF NOT PLAY THEN PLAY! "abcdefg"
PRINT "MUSIC PLAYING? 0=NO 1=YES ";PLAY

REM ============================================================
REM Naive BASIC 0.8.1G
REM ОБЩИЙ УЧЕБНИК
REM От "HELLO WORLD!" до внешней памяти NBM
REM ============================================================
REM
REM ВАЖНО:
REM 1. Номера строк не нужны, пока строка не является меткой
REM    для GOTO/GOSUB.
REM 2. Каждый раздел заканчивается PAUSE. Нажмите любую клавишу
REM    или коснитесь экрана, чтобы перейти к следующему разделу.
REM ============================================================


CLS
PRINT "HELLO WORLD! ПРИВЕТ МИР!"
PRINT "НАЧИНАЕМ С САМОГО ПРОСТОГО"
REM PRINT выводит текст и выражения на экран.
REM Строка в кавычках печатает именно этот текст.
PAUSE


CLS
PRINT "РАЗДЕЛ 1. КОММЕНТАРИИ И ВЫВОД"
REM REM позволяет писать пояснения, которые BASIC не выполняет.
REM Апостроф ' тоже начинает комментарий.
REM PRINT печатает текст, числа и результаты выражений.
PRINT "ЭТО PRINT"
PRINT 123
PRINT "ТЕКСТ";123
PRINT "ПЕРВАЯ СТРОКА"
PRINT "ВТОРАЯ СТРОКА"

PAUSE


CLS
PRINT "РАЗДЕЛ 2. ПОЗИЦИЯ И ЦВЕТ"
REM PRINT AT задаёт позицию вывода: строка, столбец.
REM Нумерация начинается с нуля.
PRINT AT 2,5;"ТЕКСТ В ПОЗИЦИИ 2,5"
INK 255
PRINT "ЯРКО-БЕЛЫЙ ТЕКСТ"
INK 100
PRINT "ДРУГОЙ ЦВЕТ"
PAPER 0
PRINT "ФОН PAPER 0"
REM INK и PAPER принимают значения палитры 0..255.
REM TAB N сдвигает текущую позицию вывода на N знакомест.
TAB 5
PRINT "ПОСЛЕ TAB"
PAUSE


CLS
PRINT "РАЗДЕЛ 3. ОЧИСТКА И РЕЖИМ ЭКРАНА"
REM CLS очищает текущий экран.
PRINT "ЭТО СЕЙЧАС БУДЕТ СТЁРТО"
CLS
PRINT "CLS ОЧИСТИЛ ЭКРАН"
REM SCREEN задаёт режим экрана и размер знакоместа.
REM SCREEN 0,0 = 320x240, альбом, 8x8.
REM SCREEN 0,1 = 320x240, альбом, 4x8.
SCREEN 0,0
PRINT "SCREEN 0,0"
PRINT "РАЗМЕР ЭКРАНА:";SCREENX;"X";SCREENY
PAUSE


CLS
PRINT "РАЗДЕЛ 4. ПЕРВЫЙ ЗВУК"
REM BEEP duration,pitch издаёт одиночный звук.
REM duration задаёт длительность, pitch — высоту.
BEEP 0.25,440
PRINT "BEEP 0.25,440"
BEEP 0.15,880
PRINT "И ЕЩЁ ОДИН"
PAUSE


CLS
PRINT "РАЗДЕЛ 5. ВВОД ТЕКСТА"
REM INPUT читает значение, введённое пользователем.
REM Строковая переменная заканчивается символом $.
INPUT "КАК ТЕБЯ ЗОВУТ? ";NAME$
PRINT "ПРИВЕТ, ";NAME$
REM INPUT может использоваться и для числа.
INPUT "СКОЛЬКО ТЕБЕ ЛЕТ? ";AGE
PRINT "ТЕБЕ";AGE
PAUSE


CLS
PRINT "РАЗДЕЛ 6. ПЕРЕМЕННЫЕ"
REM LET присваивает значение переменной.
REM Для числовой переменной знак $ не используется.
LET A=10
LET B=25
PRINT "A=";A
PRINT "B=";B
LET A=B
PRINT "ПОСЛЕ LET A=B: A=";A
REM Присваивание можно писать и без LET.
C=7
PRINT "C=";C
PAUSE


CLS
PRINT "РАЗДЕЛ 7. АРИФМЕТИКА"
REM + сложение
REM - вычитание
REM * умножение
REM / деление
REM ^ возведение в степень
PRINT "2+3=";2+3
PRINT "10-4=";10-4
PRINT "6*7=";6*7
PRINT "20/5=";20/5
PRINT "2^8=";2^8
REM Скобки задают порядок вычислений.
PRINT "(2+3)*10=";(2+3)*10
PAUSE


CLS
PRINT "РАЗДЕЛ 8. ПРОЦЕНТ И MOD"
REM % делит число на 100 или вычисляет процент от следующего выражения.
PRINT "25%=";25%
PRINT "200*15%=";200*15%
REM MOD даёт остаток от деления.
PRINT "17 MOD 5=";17 MOD 5
PRINT "100 MOD 9=";100 MOD 9
PAUSE


CLS
PRINT "РАЗДЕЛ 9. СТРОКОВЫЕ ПЕРЕМЕННЫЕ"
REM Строки хранятся в переменных с $.
A$="NAIVE"
B$="BASIC"
REM + соединяет части строки.
C$=A$+" "+B$+"!"
PRINT A$
PRINT B$
PRINT C$
REM STR$ превращает число в строку.
N=42
S$="ОТВЕТ: "+STR$(N)
PRINT S$
PAUSE


CLS
PRINT "РАЗДЕЛ 10. СТРОКОВЫЕ ФУНКЦИИ"
REM LEN возвращает длину строки.
PRINT "LEN=";LEN("HELLO")
REM CHR$ создаёт символ по числовому коду.
PRINT "CHR$(65)=";CHR$(65)
REM CODE возвращает код первого символа строки.
PRINT "CODE(""A"")=";CODE("A")
REM VAL превращает числовую строку в число.
PRINT "VAL(""123"")+7=";VAL("123")+7
REM INKEY$ возвращает строковое значение текущей клавиши.
REM Для простой демонстрации просто покажем его.
PRINT "INKEY$=";INKEY$
PAUSE


CLS
PRINT "РАЗДЕЛ 11. СЛУЧАЙНЫЕ ЧИСЛА"
REM RND возвращает случайное число от 0 до 1.
PRINT "RND=";RND
PRINT "RND=";RND
REM RANDOMIZE запускает/перезапускает последовательность случайных чисел.
RANDOMIZE
PRINT "ПОСЛЕ RANDOMIZE:";RND
PAUSE


CLS
PRINT "РАЗДЕЛ 12. ЦИКЛ FOR...NEXT"
REM FOR задаёт цикл.
REM TO задаёт конечное значение.
REM NEXT возвращает выполнение к FOR.
FOR I=1 TO 5
PRINT "I=";I
NEXT I
REM По умолчанию шаг цикла равен единице.
PAUSE


CLS
PRINT "РАЗДЕЛ 13. IF...THEN"
REM IF проверяет условие.
REM THEN выполняет действие, если условие истинно.
A=10
IF A>5 THEN PRINT "A БОЛЬШЕ 5"
IF A=10 THEN PRINT "A РАВНО 10"
IF A<5 THEN PRINT "ЭТО НЕ НАПЕЧАТАЕТСЯ"
PAUSE


CLS
PRINT "РАЗДЕЛ 14. СРАВНЕНИЯ"
REM = равно
REM <> не равно
REM < меньше
REM > больше
REM <= меньше или равно
REM >= больше или равно
PRINT "5=5 ->";5=5
PRINT "5<>7 ->";5<>7
PRINT "3<7 ->";3<7
PRINT "7>3 ->";7>3
PRINT "5<=5 ->";5<=5
PRINT "5>=3 ->";5>=3
REM Ложь = 0, истина = 1.
PAUSE



CLS
PRINT "РАЗДЕЛ 16. GOTO — ПЕРЕХОД"
REM GOTO требует номера строки-метки.
REM Номера здесь нужны именно как адреса перехода.
PRINT "ПЕРЕД ПЕРЕХОДОМ"
GOTO 100
PRINT "ЭТО НЕ ВЫПОЛНИТСЯ"
100 PRINT "GOTO ПРИВЁЛ СЮДА"
PAUSE


CLS
PRINT "РАЗДЕЛ 17. GOSUB И RETURN"
REM GOSUB вызывает подпрограмму.
REM RETURN возвращает выполнение туда, откуда был вызов.
GOSUB 200
PRINT "ПОДПРОГРАММА ЗАКОНЧИЛАСЬ"
GOTO 210
200 PRINT "ЭТО ПОДПРОГРАММА"
PRINT "ОНА МОЖЕТ СОСТОЯТЬ ИЗ НЕСКОЛЬКИХ СТРОК"
RETURN
210 PRINT "ВОЗВРАТ УСПЕШЕН"
PAUSE


CLS
PRINT "РАЗДЕЛ 18. СОВМЕСТНОЕ ИСПОЛЬЗОВАНИЕ УСЛОВИЙ"
A=7
B=12
IF A<10 AND B>10 THEN PRINT "ОБА УСЛОВИЯ ИСТИННЫ"
IF A=7 OR B=0 THEN PRINT "ХОТЯ БЫ ОДНО ИСТИННО"
IF NOT A=0 THEN PRINT "A НЕ РАВНО НУЛЮ"
REM Так из сравнений и логики строится управление программой.
PAUSE

CLS
PRINT "РАЗДЕЛ 15. ЛОГИКА"
REM AND — И
REM OR  — ИЛИ
REM NOT — НЕ
PRINT "1 AND 1 =";1 AND 1
PRINT "1 AND 0 =";1 AND 0
PRINT "0 OR 1 =";0 OR 1
PRINT "0 OR 0 =";0 OR 0
PRINT "NOT 0 =";NOT 0
PRINT "NOT 1 =";NOT 1
REM Логические операции возвращают 0 или 1.
PAUSE


CLS
PRINT "РАЗДЕЛ 19. ДАННЫЕ: DATA, READ, RESTORE"
REM DATA хранит исходные данные программы.
REM READ читает следующие значения из DATA.
REM RESTORE возвращает указатель DATA в начало.
DATA 10,20,30
READ A,B,C
PRINT A;B;C
RESTORE
READ D
PRINT "ПОСЛЕ RESTORE D=";D
PAUSE


CLS
PRINT "РАЗДЕЛ 20. МАТЕМАТИЧЕСКИЕ ФУНКЦИИ"
REM ABS — модуль
REM INT — целая часть вниз
REM SGN — знак числа
REM SQR — квадратный корень
PRINT "ABS(-12)=";ABS(-12)
PRINT "INT(3.9)=";INT(3.9)
PRINT "SGN(-8)=";SGN(-8)
PRINT "SQR(81)=";SQR(81)
PAUSE


CLS
PRINT "РАЗДЕЛ 21. ТРИГОНОМЕТРИЯ"
REM SIN, COS, TAN, COT работают с углом в радианах.
PRINT "SIN(PI/2)=";SIN(PI/2)
PRINT "COS(0)=";COS(0)
PRINT "TAN(PI/4)=";TAN(PI/4)
PRINT "COT(PI/4)=";COT(PI/4)
PRINT "PI=";PI
PAUSE


CLS
PRINT "РАЗДЕЛ 22. ОБРАТНАЯ ТРИГОНОМЕТРИЯ"
REM ASN — arcsin
REM ACS — arccos
REM ATN — arctan
PRINT "ASN(1)=";ASN(1)
PRINT "ACS(1)=";ACS(1)
PRINT "ATN(1)=";ATN(1)
PAUSE


CLS
PRINT "РАЗДЕЛ 23. ЭКСПОНЕНТА И ЛОГАРИФМ"
REM EXP — экспонента
REM LN — натуральный логарифм
PRINT "EXP(1)=";EXP(1)
PRINT "LN(EXP(1))=";LN(EXP(1))
PAUSE


CLS
PRINT "РАЗДЕЛ 24. ЭКРАН И ГРАФИКА"
REM PLOT ставит одну точку и делает её текущей графической позицией.
REM DRAW рисует линию от текущей позиции на относительное смещение.
PLOT 40,40
DRAW 80,0
DRAW 0,60
DRAW -80,0
DRAW 0,-60
PRINT AT 2,2;"КВАДРАТ"
PAUSE


CLS
PRINT "РАЗДЕЛ 25. LINE"
REM LINE x1,y1,x2,y2 рисует абсолютную линию.
LINE 20,20,180,20
LINE 180,20,180,100
LINE 180,100,20,100
LINE 20,100,20,20
REM LINE x2,y2 продолжает линию от текущей графической позиции.
PLOT 220,40
LINE 280,100
PAUSE


CLS
PRINT "РАЗДЕЛ 26. CIRCLE И PCIRCLE"
REM CIRCLE рисует незаполненный круг/эллипс.
REM PCIRCLE рисует заполненный круг/эллипс.
CIRCLE 80,80,50
CIRCLE 220,80,60,35
PCIRCLE 80,180,30
PCIRCLE 220,180,45,25
PAUSE


CLS
PRINT "РАЗДЕЛ 27. TRIANGLE И PTRIANGLE"
REM TRIANGLE рисует контур треугольника.
REM PTRIANGLE рисует заполненный треугольник.
TRIANGLE 40,40,140,40,90,130
PTRIANGLE 180,40,300,40,240,130
PAUSE


CLS
PRINT "РАЗДЕЛ 28. PAINT"
REM PAINT заполняет замкнутую область текущим INK.
INK 255
CIRCLE 100,100,60
PAINT 100,100
INK 180
CIRCLE 220,100,60
PAINT 220,100
PAUSE


CLS
PRINT "РАЗДЕЛ 29. SCROLL И ROLL"
REM SCROLL сдвигает изображение; освободившаяся область заполняется PAPER.
REM ROLL сдвигает область циклически, возвращая края на противоположную сторону.
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
PRINT "РАЗДЕЛ 30. УСТРОЙСТВО И ВВОД"
REM KEY — числовой код текущей клавиши.
REM TOUCH — 1 при касании, иначе 0.
REM TOUCHX и TOUCHY — координаты касания.
PRINT "KEY=";KEY
PRINT "TOUCH=";TOUCH
PRINT "TOUCHX=";TOUCHX
PRINT "TOUCHY=";TOUCHY
PAUSE


CLS
PRINT "РАЗДЕЛ 31. ГИРОСКОП"
REM GIRO — номер ориентации экрана 0..3.
REM GIROX и GIROY — значения наклона устройства
REM в долях от -1 до 1.
PRINT "GIRO=";GIRO
PRINT "GIROX=";GIROX
PRINT "GIROY=";GIROY
PAUSE


CLS
PRINT "РАЗДЕЛ 32. ВРЕМЯ И ДАТА"
REM TIME$ возвращает текущее время HH:MM:SS.
REM DATE$ возвращает текущую дату DD:MM:YYYY.
PRINT "TIME$=";TIME$
PRINT "DATE$=";DATE$
PAUSE


CLS
PRINT "РАЗДЕЛ 33. МАССИВЫ DIM"
REM DIM создаёт массив.
REM Индексы начинаются с нуля!
REM Поэтому DIM A(3) создаёт элементы A(0)..A(3).
DIM A(3)
A(0)=10
A(1)=20
A(2)=30
A(3)=40
PRINT A(0);A(1);A(2);A(3)
REM Двумерный массив также индексируется с нуля.
DIM M(2,2)
M(0,0)=1
M(1,1)=5
M(2,2)=9
PRINT "ЦЕНТР=";M(1,1);" УГОЛ=";M(2,2)
PAUSE


CLS
PRINT "РАЗДЕЛ 34. СТРОКОВЫЕ МАССИВЫ"
REM DIM S$(3) создаёт S$(0)..S$(3).
DIM S$(2)
S$(0)="NAIVE"
S$(1)="BASIC"
S$(2)="!"
PRINT S$(0)+" "+S$(1)+S$(2)
PAUSE


CLS
PRINT "РАЗДЕЛ 35. ПОЛЬЗОВАТЕЛЬСКАЯ ФУНКЦИЯ DEFFN"
REM DEFFN создаёт собственную числовую функцию.
REM FN вызывает её.
DEFFN DOUBLE(X)=X*2
PRINT "FN DOUBLE(21)=";FN DOUBLE(21)
DEFFN SQUARE(X)=X*X
PRINT "FN SQUARE(7)=";FN SQUARE(7)
PAUSE


CLS
PRINT "РАЗДЕЛ 36. PLAY — МУЗЫКА"
REM PLAY воспроизводит музыкальную строку и ждёт окончания.
REM PLAY! запускает её в фоне и сразу продолжает программу.
REM T — темп, O — октава, V — громкость, I — инструмент.
REM Длительность ноты задаётся числом перед нотой.
PLAY "T140 O4 V12 I0 CDEFG"
PRINT "PLAY ДОИГРАЛ И ТОЛЬКО ПОТОМ МЫ УВИДЕЛИ ЭТО"
PLAY! "T120 O4 V12 I0 5C5D5E5G"
PRINT "А PLAY! УЖЕ ИГРАЕТ В ФОНЕ"
REM PLAY возвращает 1, пока работает фоновый PLAY!, иначе 0.
IF NOT PLAY THEN PLAY! "T120 O4 V12 I0 5C5D5E5G"
PRINT "ФОНОВАЯ МУЗЫКА ПРОВЕРЕНА"
PAUSE


CLS
PRINT "РАЗДЕЛ 37. MAKE — СОЗДАНИЕ NBM"
REM MAKE X,Y,"NAME" создаёт внешний однобайтный двумерный массив.
REM Расширение .nbm добавляется автоматически.
REM В файле нет служебных байтов и заголовка.
REM Размер файла = (X+1)*(Y+1) байт.
MAKE 15,15,"TUTORIALMEM"
POKE 0,0,255
POKE 1,2,123
POKE 15,15,42
PRINT "NBM СОЗДАН"
PAUSE


CLS
PRINT "РАЗДЕЛ 38. OPEN, PEEK И POKE"
REM OPEN(X,Y,"NAME") пытается открыть существующий NBM.
REM Возвращает 1, если файл достаточно велик для указанной размерности.
REM Возвращает 0, если файла нет или размера недостаточно.
REM PEEK(X,Y) читает байт.
REM POKE X,Y,BYTE записывает байт.
C=OPEN(10,10,"TUTORIALMEM")
PRINT "OPEN=";C
IF C=1 THEN PRINT "PEEK 1,2=";PEEK(1,2)
POKE 5,5,200
PRINT "ПОСЛЕ POKE=";PEEK(5,5)
REM Размерность OPEN может быть меньше той, с которой файл создан.
C=OPEN(5,5,"TUTORIALMEM")
PRINT "OPEN 5,5=";C
PAUSE


CLS
PRINT "РАЗДЕЛ 39. МАКСИМАЛЬНЫЙ NBM"
REM Размерности используют ту же логику, что DIM:
REM индексы идут от нуля.
REM Поэтому MAKE 255,255 создаёт 256*256 = 65536 байт.
MAKE 255,255,"TUTORIALMEM"
POKE 255,255,255
PRINT "MAXIMUM NBM=";PEEK(255,255)
PRINT "65536 BYTE = 64 KiB"
PAUSE


CLS
PRINT "ФИНАЛ. NAIVE BASIC — ЭТО СИСТЕМА"
REM Мы начали с PRINT "HELLO WORLD!"
REM и дошли до:
REM переменных, строк, циклов, условий, логики,
REM графики, устройства, математики, массивов,
REM музыки и внешней памяти.
REM
REM Следующий шаг — не новая команда, а собственные программы.
PRINT "HELLO WORLD! ПРИВЕТ МИР!"
PRINT "У ТЕБЯ ЕСТЬ ВСЁ НЕОБХОДИМОЕ."
PAUSE

REM **ЛОГИЧЕСКИЙ ОПЕРАНД PLAY**
REM пока играет музыка =1, музыка не играет =0
REM Позволяет простым путём сделать непрерывную фоновую музыку:
IF NOT PLAY THEN PLAY! "abcdefg"
PRINT "МУЗЫКА ИГРАЕТ? 0=НЕТ 1=ДА ";PLAY

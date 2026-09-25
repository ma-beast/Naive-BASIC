![Naive BASIC — retro computing, old and new hardware](docs/images/Naive-BASIC-banner.png)

# Naive BASIC 1.0

**Лёгкий BASIC-интерпретатор для Android — включая Android 2.3 / ARMv6.**

Naive BASIC ориентирован по синтаксису и духу на классический BASIC и ZX Spectrum / Spectrum 128 BASIC, но **не является эмулятором Spectrum**. Это самостоятельный интерпретатор со своим экраном, charset, графикой, звуком, сенсорным вводом и файловой памятью.

Идея проста: написал BASIC-программу → `RUN` → сразу получил результат.

## Игры, музыка и примеры

**[Examples-BAS — готовые программы для Naive BASIC](https://github.com/ma-beast/Examples-BAS)**

Отдельная пополняемая библиотека `.bas`: игры, музыкальные демонстрации и тесты возможностей языка. Эти программы можно запускать непосредственно в **Naive BASIC 1.0**, а также использовать как готовые исходники для **bas2apk / NaiveWORK** при создании самостоятельных Android APK.

## Возможности релиза 1.0

- Android 2.3+ (`minSdk 9`), цель — работа в том числе на ARMv6.
- Числа, строки, массивы, `DATA/READ/RESTORE`, `FOR/NEXT`, `IF/THEN`, `GOSUB/RETURN`, пользовательские `DEFFN/FN`.
- Математика, тригонометрия, логические операции, `%`, `MOD`, степень и генератор случайных чисел.
- Собственный экран и charset; `INK/PAPER`, `AT`, `TAB`, `PRINT`.
- Графика: `PLOT`, `POINT`, `DRAW`, `LINE`, `CIRCLE`, `PCIRCLE`, `TRIANGLE`, `PTRIANGLE`, `PAINT`, `SCROLL`, `ROLL`.
- Клавиатура и сенсор: `KEY`, `INKEY$`, `TOUCH`, `TOUCHX`, `TOUCHY`.
- Ориентация и наклон устройства: `GIRO`, `GIROX`, `GIROY`.
- Звук: `BEEP`, синхронный `PLAY` и фоновый `PLAY!`.
- Внешняя байтовая память NBM: `MAKE`, `OPEN`, `PEEK`, `POKE`.
- Встроенные учебники на русском и английском.
- Сохранение, загрузка, удаление и экспорт `.bas` программ.

В 1.0 исправлена работа `PLOT` в `SCREEN 1/3`: используется безопасный графический буфер 320×320 с проверкой координат по текущему размеру экрана.

## Документация

- [Справочник команд и операторов — русский](docs/COMMAND_REFERENCE_RU.md)
- [Command and operator reference — English](docs/COMMAND_REFERENCE_EN.md)
- [Полный справочник релиза 1.0 — русский](docs/Naive_BASIC_1.0_README_RU.txt)
- [Full 1.0 release reference — English](docs/Naive_BASIC_1.0_README_EN.txt)
- Встроенные учебники находятся в `app/src/main/assets/programs/`.

## Исходный код

Репозиторий содержит исходный Android-проект релиза **Naive BASIC 1.0**. Основной интерпретатор находится в `app/src/main/java/com/naivebasic/BasicInterpreter.java`.

## Naive BASIC bas2apk / NaiveWORK

Для Naive BASIC также существует готовый **bas2apk 1.0 с NaiveWORK** — инструмент, превращающий BASIC-программу в самостоятельный Android APK. Его исходники и релиз будут оформлены отдельно от исходников интерпретатора, чтобы два готовых инструмента не смешивались в одну кодовую базу.

Для проверки bas2apk можно использовать те же программы из **[Examples-BAS](https://github.com/ma-beast/Examples-BAS)**: взять готовый `.bas` и собрать из него отдельное приложение.

## Принцип проекта

> Один небольшой проверяемый шаг за раз. Рабочие версии не ломаем ради косметических изменений.

Проект вырос из желания писать небольшие программы непосредственно на старом Android-железе — без современного тяжёлого toolchain там, где достаточно BASIC.

---

**Автор:** Михаил Зверев / MA-BEAST  
[Профиль MA-BEAST](https://github.com/ma-beast)

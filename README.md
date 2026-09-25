<a id="top"></a>

![Naive BASIC — retro computing, old and new hardware](docs/images/Naive-BASIC-banner.png)

[English](#english) | [Русский](#russian)

<a id="english"></a>

# Naive BASIC 1.0

**A lightweight BASIC interpreter for Android — including Android 2.3 / ARMv6.**

Naive BASIC follows the syntax and spirit of classic BASIC and ZX Spectrum / Spectrum 128 BASIC, but **it is not a Spectrum emulator**. It is an independent interpreter with its own screen, character set, graphics, sound, touch input and file-backed memory.

The idea is simple: write a BASIC program → `RUN` → get the result immediately.

## Games, music and examples

**[Examples-BAS — ready-to-run programs for Naive BASIC](https://github.com/ma-beast/Examples-BAS)**

A growing library of `.bas` games, music programs and language tests. The same programs can be run directly in **Naive BASIC 1.0** or used as source programs for **bas2apk / NaiveWORK** to create standalone Android APKs.

### “Cockroach” — from source to ending

<table><tr>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_20260911-010409.png" alt="Cockroach BASIC source"></td>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_20260911-010424.png" alt="Cockroach game start"></td>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-21-55-41-284_com.naivebasic.jpg" alt="Cockroach gameplay"></td>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_20260911-010459.png" alt="Cockroach game ending"></td>
</tr></table>

### RPG “Three Talismans”

<table><tr>
<td width="33%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-21-10-43-320_com.naivebasic.jpg" alt="Three Talismans swamp"></td>
<td width="33%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-21-11-34-862_com.naivebasic.jpg" alt="Three Talismans village"></td>
<td width="33%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-21-12-07-259_com.naivebasic.jpg" alt="Three Talismans ending"></td>
</tr></table>

### Music editor written in BASIC

On-screen music editing built on `PLAY` / `PLAY!`. The sound itself has to be heard; the screenshots show the editor.

<table><tr>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-22-11-22-545_com.naivebasic.jpg" alt="BASIC music editor"></td>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-22-12-40-862_com.naivebasic.jpg" alt="BASIC music editor"></td>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-22-14-17-723_com.naivebasic.jpg" alt="BASIC music editor"></td>
<td width="25%"><img src="https://raw.githubusercontent.com/ma-beast/Examples-BAS/main/docs/images/Screenshot_2026-09-25-22-14-46-438_com.naivebasic.jpg" alt="BASIC music editor"></td>
</tr></table>

More games, tests, music programs and demonstrations are available in **[Examples-BAS](https://github.com/ma-beast/Examples-BAS)**.

## Naive BASIC 1.0 features

- Android 2.3+ (`minSdk 9`), including the goal of ARMv6 compatibility.
- Numbers, strings, arrays, `DATA/READ/RESTORE`, `FOR/NEXT`, `IF/THEN`, `GOSUB/RETURN`, user functions `DEFFN/FN`.
- Mathematics, trigonometry, logical operations, `%`, `MOD`, powers and random numbers.
- Own screen and character set; `INK/PAPER`, `AT`, `TAB`, `PRINT`.
- Graphics: `PLOT`, `POINT`, `DRAW`, `LINE`, `CIRCLE`, `PCIRCLE`, `TRIANGLE`, `PTRIANGLE`, `PAINT`, `SCROLL`, `ROLL`.
- Keyboard and touch: `KEY`, `INKEY$`, `TOUCH`, `TOUCHX`, `TOUCHY`.
- Device orientation and tilt: `GIRO`, `GIROX`, `GIROY`.
- Sound: `BEEP`, synchronous `PLAY` and background `PLAY!`.
- External byte memory NBM: `MAKE`, `OPEN`, `PEEK`, `POKE`.
- Built-in tutorials in Russian and English.
- Save, load, delete and export `.bas` programs.

In 1.0, `PLOT` in `SCREEN 1/3` was fixed by using a safe 320×320 graphics buffer with coordinate checks against the current screen size.

## Documentation

- [Command and operator reference — English](docs/COMMAND_REFERENCE_EN.md)
- [Full 1.0 release reference — English](docs/Naive_BASIC_1.0_README_EN.txt)
- [Справочник команд и операторов — русский](docs/COMMAND_REFERENCE_RU.md)
- [Полный справочник релиза 1.0 — русский](docs/Naive_BASIC_1.0_README_RU.txt)
- Built-in tutorials are stored in `app/src/main/assets/programs/`.

## Source code

This repository contains the Android source project for **Naive BASIC 1.0**. The main interpreter is `app/src/main/java/com/naivebasic/BasicInterpreter.java`.

## Naive BASIC bas2apk / NaiveWORK

**[Naive BASIC bas2apk 1.0](https://github.com/ma-beast/Naive-BASIC-bas2apk)** is the finished tool for turning Naive BASIC `.bas` programs **and any compatible BASIC programs** into standalone Android APKs directly on an Android device.

It includes **NaiveWORK 0.2G**, the runtime/template for generated applications. The bas2apk and NaiveWORK sources are preserved in their own repository together with the required template and export files. The tested release supports older BASIC programs, `PLAY!` and numeric `PLAY` in generated standalone APKs.

The programs from **[Examples-BAS](https://github.com/ma-beast/Examples-BAS)** can be run in Naive BASIC first and then built into separate applications with bas2apk.

## Project principle

> One small, testable step at a time. Do not break working versions for cosmetic changes.

The project grew from the wish to write small programs directly on old Android hardware — without a modern heavyweight toolchain where BASIC is enough.

**Author:** Mikhail Zverev / MA-BEAST

[Русский](#russian) | [↑ Top](#top)

---

<a id="russian"></a>

# Naive BASIC 1.0 — Русский

**Лёгкий BASIC-интерпретатор для Android — включая Android 2.3 / ARMv6.**

Naive BASIC ориентирован по синтаксису и духу на классический BASIC и ZX Spectrum / Spectrum 128 BASIC, но **не является эмулятором Spectrum**. Это самостоятельный интерпретатор со своим экраном, charset, графикой, звуком, сенсорным вводом и файловой памятью.

Идея проста: написал BASIC-программу → `RUN` → сразу получил результат.

## Игры, музыка и примеры

**[Examples-BAS — готовые программы для Naive BASIC](https://github.com/ma-beast/Examples-BAS)**

Отдельная пополняемая библиотека `.bas`: игры, музыкальные программы и тесты возможностей языка. Эти программы можно запускать непосредственно в **Naive BASIC 1.0**, а также использовать как готовые исходники для **bas2apk / NaiveWORK** при создании самостоятельных Android APK.

Скриншоты игр и музыкального редактора находятся в общей витрине выше: **[перейти к примерам](#games-music-and-examples)**.

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
- [Полный справочник релиза 1.0 — русский](docs/Naive_BASIC_1.0_README_RU.txt)
- [Command and operator reference — English](docs/COMMAND_REFERENCE_EN.md)
- [Full 1.0 release reference — English](docs/Naive_BASIC_1.0_README_EN.txt)
- Встроенные учебники находятся в `app/src/main/assets/programs/`.

## Исходный код

Репозиторий содержит исходный Android-проект релиза **Naive BASIC 1.0**. Основной интерпретатор находится в `app/src/main/java/com/naivebasic/BasicInterpreter.java`.

## Naive BASIC bas2apk / NaiveWORK

**[Naive BASIC bas2apk 1.0](https://github.com/ma-beast/Naive-BASIC-bas2apk)** — готовый инструмент для превращения программ Naive BASIC `.bas` **и любых совместимых BASIC-программ** в самостоятельные Android APK непосредственно на Android-устройстве.

В комплект входит **NaiveWORK 0.2G** — runtime/template для создаваемых приложений. Исходники bas2apk и NaiveWORK сохранены в отдельном репозитории вместе с необходимыми шаблонами и экспортными файлами. Проверенный релиз поддерживает старые BASIC-программы, `PLAY!` и числовой операнд `PLAY` в созданных автономных APK.

Для проверки и собственных сборок можно использовать те же программы из **[Examples-BAS](https://github.com/ma-beast/Examples-BAS)**: запустить `.bas` в Naive BASIC, а затем собрать эту же программу через bas2apk в отдельное приложение.

## Принцип проекта

> Один небольшой проверяемый шаг за раз. Рабочие версии не ломаем ради косметических изменений.

Проект вырос из желания писать небольшие программы непосредственно на старом Android-железе — без современного тяжёлого toolchain там, где достаточно BASIC.

**Автор:** Михаил Зверев / MA-BEAST

[English](#english) | [↑ Наверх](#top)

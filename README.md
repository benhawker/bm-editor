![Travis Build](https://travis-ci.org/benhawker/bm-editor.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/benhawker/bm-editor/badge.svg?branch=master&service=github)](https://coveralls.io/github/benhawker/bm-editor?branch=master)

# Bitmap Editor - Ruby App

A work in progress as of September 2016.

A Ruby 2.3 program that simulates a basic interactive bitmap editor. Bitmaps are represented as an M x N matrix of pixels with each element representing a colour.

The input consists of a string containing a sequence of commands, where a command is represented by a single capital letter at the beginning of the line. Parameters of the command are separated by white spaces and they follow the command character.

Pixel co-ordinates are a pair of integers: a column number between 1 and 250, and a row number between 1 and 250. Bitmaps starts at coordinates 1,1. Colours are specified by capital letters.

===================

### Commands:

There are 8 supported commands:

* I M N - Create a new M x N image with all pixels coloured white (O).
* C - Clears the table, setting all pixels to white (O).
* L X Y C - Colours the pixel (X,Y) with colour C.
* V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
* H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
* S - Show the contents of the current image
* ? - Displays help text
* X - Terminate the session


===================

### Usage:

```
ruby runner.rb
```

Run the specs:
```
rspec
```

===================

### Example usage:

* S (Show Command)

```
> S
    1    2    3    4    5    6
1 ["O", "O", "O", "O", "O", "O"]
2 ["O", "O", "O", "O", "O", "O"]
3 ["O", "O", "O", "O", "O", "O"]
4 ["O", "O", "O", "O", "O", "O"]
5 ["O", "O", "O", "O", "O", "O"]
6 ["O", "O", "O", "O", "O", "O"]
Command executed successfully.
```

* L 1 1 C (Paint a single pixel of color C in pixel 1,1)

```
> L 1 1 C
Command executed successfully.
--------
> S
    1    2    3    4    5    6
1 ["C", "O", "O", "O", "O", "O"]
2 ["O", "O", "O", "O", "O", "O"]
3 ["O", "O", "O", "O", "O", "O"]
4 ["O", "O", "O", "O", "O", "O"]
5 ["O", "O", "O", "O", "O", "O"]
6 ["O", "O", "O", "O", "O", "O"]
Command executed successfully.
--------
```

* V 1 1 6 C - Draw a vertical segment of colour C in column 1 between rows 1 and 6
```
> V 1 1 6 C
Command executed successfully.
--------
> S
    1    2    3    4    5    6
1 ["C", "O", "O", "O", "O", "O"]
2 ["C", "O", "O", "O", "O", "O"]
3 ["C", "O", "O", "O", "O", "O"]
4 ["C", "O", "O", "O", "O", "O"]
5 ["C", "O", "O", "O", "O", "O"]
6 ["C", "O", "O", "O", "O", "O"]
Command executed successfully.
--------
```

* C - Clears the bitmap
```
> C
Command executed successfully.
--------
> S
    1    2    3    4    5    6
1 ["O", "O", "O", "O", "O", "O"]
2 ["O", "O", "O", "O", "O", "O"]
3 ["O", "O", "O", "O", "O", "O"]
4 ["O", "O", "O", "O", "O", "O"]
5 ["O", "O", "O", "O", "O", "O"]
6 ["O", "O", "O", "O", "O", "O"]
Command executed successfully.
--------
```


* H 1 6 1 C - Draw a horizontal segment of colour C in row 1 between columns 1 and 6
```
> H 1 6 1 C
Command executed successfully.
--------
> S
    1    2    3    4    5    6
1 ["C", "C", "C", "C", "C", "C"]
2 ["O", "O", "O", "O", "O", "O"]
3 ["O", "O", "O", "O", "O", "O"]
4 ["O", "O", "O", "O", "O", "O"]
5 ["O", "O", "O", "O", "O", "O"]
6 ["O", "O", "O", "O", "O", "O"]
Command executed successfully.
--------
```


* F 1 1 C - Colours horizontally or vertically adjacent cells in the specified color if they are the same original color as the one being targeted.
```
Given the following grid:
> S
    1    2    3    4    5    6
1 ["A", "A", "O", "O", "O", "O"]
2 ["O", "A", "O", "O", "O", "O"]
3 ["O", "A", "A", "A", "O", "O"]
4 ["O", "O", "O", "A", "O", "O"]
5 ["O", "O", "O", "O", "O", "O"]
6 ["O", "O", "O", "O", "O", "O"]
Command executed successfully.
--------
> F 1 1 C
Command executed successfully.
--------
> S
    1    2    3    4    5    6
1 ["C", "C", "O", "O", "O", "O"]
2 ["O", "C", "O", "O", "O", "O"]
3 ["O", "C", "C", "C", "O", "O"]
4 ["O", "O", "O", "C", "O", "O"]
5 ["O", "O", "O", "O", "O", "O"]
6 ["O", "O", "O", "O", "O", "O"]
Command executed successfully.
--------
```

===================

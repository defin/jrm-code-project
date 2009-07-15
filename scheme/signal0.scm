(declare (usual-integrations))

(define *raw-time-series*
  #(0  0  0   0   0   0   0   0   0   0  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0  0  0  0  0  0  0
    0  0  0   0   0   0   0   1   0   0  0  0  0  0  0  0  0  0  0   0   0   0   1   0   0  0  0  0  0  0  0
    2  2  0   0   0   0   1   1   0   0  0  0  0  0  0  0  0  0  0   1   0   0   1   0   0  1  1  0  0  1  0
    1  4  2   1   0   1   3   1   1   1  0  0  3  1  2  1  5  3  4   1   0   5   4   3   5  2  4  2  4  2  1
    3  24 5   1   4   5   4   4   1   6  5  2  2  6  4  3  9  22 6   5   5   4   4   9   4  5  12 11 5  10 10
    6  46 14  7   11  8   12  10  11  6  11 9  7  11 7  9  26 46 8   5   9   12  11  12  14 12 7  8  13 14 20
    11 48 36  18  15  10  16  11  10  14 23 15 9  13 24 12 13 83 23  13  13  15  14  12  13 18 12 20 16 20 15
    18 51 80  15  16  20  16  17  15  11 16 18 15 22 18 19 14 98 60  28  20  19  20  25  30 30 25 20 24 32 22
    25 40 150 20  21  27  16  18  17  18 22 19 21 17 24 20 23 77 124 24  33  29  20  31  24 17 23 22 21 28 25
    33 37 166 69  24  30  32  26  20  22 21 24 26 29 32 37 21 54 168 31  22  29  44  27  28 39 23 20 35 33 34
    28 36 149 119 41  40  26  33  30  28 42 34 30 26 28 37 30 48 167 61  36  40  27  28  32 35 37 25 42 27 28
    39 37 92  137 28  28  37  31  25  32 33 31 22 23 29 33 26 35 162 98  42  37  25  27  29 38 29 39 32 27 47
    35 34 57  217 30  27  35  37  33  34 39 41 26 29 37 34 38 38 131 164 43  24  31  32  37 35 31 31 35 32 33
    29 24 47  182 82  35  24  32  31  35 42 30 22 29 36 39 40 34 81  186 31  35  38  32  37 36 34 28 42 45 42
    26 46 35  140 122 25  35  53  37  28 37 41 35 32 40 30 37 32 63  214 54  30  33  30  44 36 25 43 40 30 28
    32 30 47  116 152 38  34  29  27  30 40 35 36 35 37 32 32 38 53  164 105 33  29  20  35 26 27 31 28 34 24
    39 31 29  60  242 27  32  30  29  26 25 30 31 27 27 29 20 32 36  130 149 43  27  33  39 48 31 28 32 25 31
    27 29 31  49  158 68  30  35  32  41 34 25 28 24 37 31 32 42 27  91  186 37  26  34  46 33 27 36 38 34 19
    20 43 32  49  144 103 30  26  26  32 32 27 26 39 29 31 29 27 27  60  184 69  27  24  29 20 31 26 26 39 25
    36 33 29  36  79  143 27  41  21  33 24 30 32 36 33 36 31 36 35  50  153 84  44  33  37 26 29 22 36 24 24
    26 26 32  37  49  212 24  28  23  35 30 44 31 22 25 23 34 27 35  30  104 120 34  28  26 26 30 26 25 33 31
    33 30 26  37  34  144 65  36  24  26 28 29 30 24 20 20 20 29 25  29  61  157 21  23  21 25 23 19 25 29 33
    26 28 20  33  31  103 69  24  21  34 20 27 30 18 24 27 24 15 36  36  47  150 47  26  19 21 27 24 23 31 27
    24 25 26  23  36  61  127 21  38  25 19 32 33 26 26 21 19 28 23  35  44  108 96  20  19 27 26 24 25 26 23
    24 21 22  22  31  58  168 23  18  18 24 22 29 23 19 25 22 23 29  28  33  78  103 15  25 32 24 28 24 31 27
    22 17 19  24  26  42  130 46  24  23 24 25 18 16 26 18 23 20 32  22  29  57  122 28  24 32 25 25 23 26 25
    23 17 23  19  20  40  80  81  29  23 21 20 25 23 23 24 19 25 24  31  29  25  144 37  14 23 21 23 24 18 27
    18 20 14  12  28  26  58  105 22  21 23 31 19 20 21 20 28 18 19  24  13  32  90  62  21 27 20 17 25 27 25
    18 14 24  23  25  23  26  118 18  22 14 23 26 28 25 22 19 17 24  32  17  25  54  81  24 23 24 19 30 27 19
    22 21 15  19  17  22  22  114 60  17 19 17 29 22 26 27 19 24 26  13  19  23  40  105 24 22 26 16 12 24 18
    29 20 30  24  23  18  35  65  81  20 18 33 11 26 24 24 13 13 15  16  20  34  30  120 34 19 14 23 20 24 23
    23 24 16  32  14  18  28  46  96  24 23 22 17 23 19 17 12 19 27  22  23  26  29  85  50 18 19 23 14 14 23
    14 16 23  17  22  13  25  29  106 23 32 18 14 15 11 20 22 20 20  20  21  13  37  54  75 20 21 18 9  23 22
    15 17 19  17  25  28  28  32  76  30 22 19 13 18 17 21 23 18 19  21  20  14  24  30  93 15 13 17 20 19 18
    15 18 19  18  18  9   24  30  74  73 15 18 27 20 23 23 19 26 25  15  15  18  17  22  95 24 10 13 14 10 17
    26 22 17  13  21  13  16  23  40  74 17 12 10 19 22 27 29 14 19  7   16  17  20  21  65 41 16 22 12 15 17
    13 20 13  8   21  23  13  19  13  99 24 33 14 20 25 25 26 18 18  24  15  19  18  27  36 52 20 19 13 20 21
    11 15 16  22  22  24  21  20  31  75 38 18 15 24 19 16 15 17 16  17  24  17  23  25  35 94 15 16 16 18 12
    9  20 12  20  25  9   14  19  17  63 54 22 18 18 28 22 15 15 10  12  16  17  21  18  20 84 28 18 20 16 15
    20 19 25  22  21  13  13  23  22  30 56 16 22 17 10 16 10 11 12  11  15  20  18  22  13 55 50 10 11 17 16
    22 19 20  16  16  20  11  17  23  13 74 21 14 19 10 13 18 18 18  18  19  16  25  20  28 37 58 17 20 13 18
    12 17 16  16  17  15  21  13  18  25 70 29 13 14 11 12 22 16 11  13  20  16  21  15  14 23 82 14 11 15 10
    15 12 27  11  8   22  14  23  22  16 64 49 15 13 13 9  13 14 11  18  20  16  6   13  14 17 68 26 14 9  9
    16 16 8   10  18  12  6   12  18  28 38 65 11 18 17 11 13 12 14  17  9   10  17  15  21 12 68 49 14 19 18
    9  15 15  10  9   17  12  15  21  17 11 81 18 13 6  15 10 19 20  13  14  8   14  11  18 18 40 50 19 11 10
    14 9  16  12  18  12  18  23  12  18 24 73 23 16 11 16 6  12 9   8   13  12  16  13  19 12 24 84 22 18 9
    16 13 16  11  10  21  21  17  13  12 6  37 49 11 18 17 20 12 20  7   10  6   15  8   13 23 16 74 24 17 15
    14 11 10  12  11  15  16  8   23  14 23 24 56 11 13 15 12 13 19  15  8   17  9   14  10 18 20 52 42 5  9
    5  15 7   18  23  17  8   14  20  14 12 11 57 12 14 16 8  8  13  14  14  10  5   14  13 22 10 34 47 16 12
    11 7  14  13  11  9   16  11  13  11 14 23 57 26 12 14 11 7  6   10  11  15  16  14  8  18 15 16 70 14 9
    14 12 18  10  12  9   8   14  11  9  22 22 46 53 10 24 16 11 14  15  9   11  12  4   15 12 17 12 52 22 13
    13 16 12  18  13  12  13  8   12  14 22 9  31 64 6  7  7  9  8   11  16  12  14  11  13 7  18 12 60 31 8
    16 10 6   11  14  10  13  12  13  10 20 16 18 68 14 9  13 6  12  12  11  10  15  9   15 6  19 10 29 56 9
    12 8  12  11  10  11  8   9   10  13 17 11 8  49 33 9  15 5  8   15  16  20  13  8   12 6  16 5  11 61 11
    13 6  14  7   12  10  7   12  12  18 15 15 7  42 36 9  8  10 16  8   6   17  11  9   9  13 16 9  14 54 20
    9  11 16  10  11  17  10  12  9   7  13 14 13 23 51 12 11 10 11  10  7   9   3   15  10 11 12 11 12 42 36
    16 13 7   6   11  7   15  7   8   9  8  17 12 7  65 12 17 13 11  6   5   12  12  10  9  7  13 10 15 34 35
    9  10 11  12  7   7   8   8   11  10 10 10 11 12 46 27 13 8  6   13  6   3   8   6   6  14 11 15 11 16 65
    7  4  16  16  11  13  11  6   13  5  5  8  15 6  36 31 7  11 8   6   12  13  6   10  11 13 13 7  11 7  47
    17 8  13  7   17  12  8   11  4   9  6  9  11 14 25 43 8  7  11  8   9   6   8   11  10 15 9  7  10 10 36
    23 6  12  8   15  9   11  10  10  4  6  7  13 12 16 46 11 9  9   7   9   10  11  7   9  8  10 7  14 15 33
    35 14 14  6   6   13  6   10  12  9  3  13 10 8  10 52 18 10 7   9   3   10  14  4   7  8  5  11 10 9  16
    47 11 7   9   7   12  7   8   8   8  8  7  11 9  4  33 35 6  8   9   4   8   4   2   6  13 10 4  14 5  8
    55 10 1   14  7   6   7   9   5   4  6  7  10 10 5  15 43 2  5   8   9   13  5   9   6  10 7  8  13 9  13
    36 34 0   7   3   11  5   11  4   9  5  6  16 13 2  9  39 9  4   10  4   5   8   5   8  7  12 8  13 13 9
    31 21 7   7   8   15  4   10  11  2  6  8  8  14 6  10 51 29 16  5   2   11  9   9   13 4  10 6  11 10 7
    15 46 6   6   7   5   5   9   11  10 6  3  9  14 8  10 19 36 7   6   8   11  16  11  6  4  5  7  8  8  7
    5  39 12  8   4   3   7   8   10  11 5  4  8  9  15 5  19 36 8   6   8   5   7   5   4  4  17 9  7  12 10
    4  22 20  12  4   15  6   11  1   6  5  14 7  12 7  11 8  49 7   4   5   12  5   8   2  5  6  2  5  9  9
    15 19 22  6   8   6   4   6   10  5  3  8  4  4  10 7  5  33 19  7   7   6   7   12  14 7  9  4  6  9  12
    5  9  45  7   3   4   5   7   6   9  5  4  10 7  8  11 4  27 25  4   3   8   8   6   11 4  4  6  9  10 8
    8  10 56  18  6   7   1   5   4   11 9  6  13 6  9  5  3  14 32  9   9   3   12  10  9  1  10 9  9  8  9
    6  9  28  22  7   3   5   12  8   6  7  4  8  8  13 10 8  5  43  7   5   7   10  6   6  8  6  6  4  6  12
    6  7  28  43  12  7   7   7   8   3  11 8  8  4  6  8  9  10 35  14  7   4   6   5   6  7  4  7  3  4  9
    13 5  11  30  7   9   6   7   6   4  11 0  5  4  6  7  8  8  22  31  2   7   5   7   8  2  4  6  5  6  8
    9  3  5   46  10  9   6   6   4   6  1  9  4  6  4  5  5  3  12  39  6   7   7   5   6  10 8  5  4  5  5
    7  10 9   27  18  7   3   8   7   7  6  5  5  8  3  13 9  3  8   40  4   9   3   6   7  8  4  7  4  6  6
    6  6  3   17  29  6   3   4   6   4  7  5  5  6  4  8  8  3  5   31  16  7   6   8   2  6  6  2  3  8  6
    8  4  8   11  36  4   8   3   5   5  2  6  2  6  6  10 8  7  7   23  24  7   8   3   4  3  10 2  4  1  6
    10 6  2   8   39  9   5   2   3   8  4  2  5  9  3  10 5  3  4   21  28  6   5   6   4  3  3  7  5  8  6
    6  7  6   9   26  13  5   6   4   4  6  5  7  3  7  2  5  5  5   5   38  9   5   5   2  6  9  5  5  6  6
    4  7  8   3   16  17  4   6   5   6  3  6  7  8  3  2  6  6  3   5   38  8   5   8   4  3  6  7  5  3  5
    10 12 5   2   6   27  8   3   6   6  6  8  5  4  3  5  4  6  4   6   16  25  7   2   9  5  3  3  5  5  4
    7  9  6   2   3   38  7   4   7   3  4  9  6  1  3  8  4  7  4   3   16  38  5   4   2  1  3  6  4  5  5
    4  7  8   3   4   24  23  6   6   4  6  4  5  2  1  6  3  3  4   1   7   45  5   5   5  6  5  5  5  6  5
    0  8  5   4   6   18  24  1   5   2  6  5  7  2  2  5  5  4  2   7   4   35  13  6   1  4  5  5  6  6  0
    4  6  1   3   2   12  37  3   4   5  1  2  5  3  4  3  3  10 7   4   5   14  21  4   3  2  8  3  10 10 3
    4  3  5   3   4   5   31  8   3   3  4  7  5  3  5  4  3  7  2   6   6   12  24  2   4  5  8  2  4  7  5
    3  2  8   1   3   4   25  19  2   5  4  4  3  1  6  3  8  2  7   1   8   6   36  2   5  5  12 2  3  7  5
    1  4  2   4   1   6   15  16  8   3  2  3  6  3  4  5  5  3  5   4   7   2   26  7   2  3  5  5  4  2  0
    3  2  8   3   3   4   7   24  6   4  7  3  1  2  3  5  1  3  4   1   3   2   11  23  9  3  2  6  5  6  4
    3  4  0   8   1   3   4   24  5   10 4  7  6  4  2  8  2  5  8   4   4   0   11  25  6  2  1  4  1  3  4
    4  4  1   5   0   4   5   14  17  4  1  3  3  3  3  3  3  3  6   5   4   7   5   28  3  2  5  2  2  6  2
    3  7  6   6   3   1   2   10  25  5  1  4  3  2  0  4  0  4  3   6   10  6   4   25  13 3  5  3  3  2  3
    10 4  2   8   2   2   1   6   27  6  1  0  3  2  4  2  3  4  2   7   3   1   5   12  12 1  7  4  1  2  6
    5  3  4   3   5   4   4   3   25  9  3  2  3  2  5  3  3  2  5   8   1   6   3   18  19 3  1  3  3  7  5
    5  1  3   2   5   2   0   6   23  14 4  3  3  1  4  0  2  3  2   4   2   2   9   4   22 2  6  5  2  0  0
    2  2  2   0   3   1   2   5   9   17 1  3  0  4  2  3  4  5  0   5   7   5   3   3   23 10 3  6  3  2  1
    4  1  2   1   4   2   3   7   9   16 1  4  0  1  4  2  1  3  3   1   5   3   2   3   6  18 1  4  2  2  3
    2  2  2   0   4   5   2   0   4   22 4  4  3  5  0  2  2  4  0   3   1   2   2   0   9  22 3  1  0  1  2
    5  0  3   0   5   4   1   4   3   20 6  5  8  3  4  2  3  2  2   1   1   5   4   1   3  22 1  4  2  2  4
    3  3  5   0   5   8   3   2   2   8  12 2  4  2  4  2  1  2  1   0   2   2   6   2   1  17 5  4  4  1  1
    2  1  1   0   3   1   4   4   2   5  21 6  3  3  3  2  3  3  2   3   3   5   4   3   5  16 15 5  5  3  4
    2  2  8   2   4   4   4   1   3   3  23 6  6  1  3  1  2  2  4   5   3   5   1   1   3  10 20 4  5  2  9
    2  3  2   3   2   3   1   2   4   1  12 16 3  4  3  1  2  3  2   1   3   4   1   1   1  7  24 1  4  4  4
    2  0  0   2   2   2   4   1   2   2  17 19 2  5  0  1  4  2  3   3   5   6   2   4   2  0  18 10 2  3  4
    2  2  1   0   4   5   3   4   3   1  6  24 4  6  3  0  3  3  3   5   2   5   2   2   6  2  13 14 3  4  7
    1  0  3   2   2   4   5   1   4   0  3  11 3  1  3  2  1  9  3   1   0   4   3   1   4  4  5  14 2  5  2
    2  1  7   2   3   3   5   7   4   1  1  11 12 1  0  3  2  3  0   6   3   2   2   3   4  4  2  22 3  0  5
    3  2  2   0   6   4   12  1   3   3  4  13 12 7  1  0  4  2  1   2   1   1   6   4   3  2  6  12 13 4  4
    2  4  3   1   1   4   5   3   3   1  0  4  20 3  5  5  2  0  5   2   0   3   0   4   2  4  1  15 11 1  2
    3  3  1   3   7   4   5   1   3   5  1  3  15 8  1  1  1  2  2   5   4   1   6   4   4  4  4  10 20 4  3
    2  1  2   1   2   4   3   3   6   3  1  4  16 8  4  6  5  4  3   3   1   2   3   1   2  1  1  8  20 3  3
    3  5  4   3   3   3   3   2   6   1  2  3  9  19 6  2  2  2  1   2   1   2   3   2   2  5  3  2  16 5  2
    1  3  3   3   1   5   1   3   4   3  1  3  2  17 5  4  2  3  1   4   0   5   3   3   3  3  1  2  11 10 8
    4  4  2   2   4   1   2   4   2   3  6  2  3  15 5  1  1  2  4   0   5   4   6   4   2  2  4  5  6  17 2
    2  1  2   2   1   1   3   3   3   1  3  4  3  17 7  2  1  0  1   2   0   2   3   5   5  5  1  4  5  13 3
    2  0  2   1   2   1   4   4   4   2  1  0  1  11 10 5  2  3  3   7   3   0   0   2   0  2  2  2  1  18 6
    3  2  2   2   4   1   1   4   4   2  0  3  2  5  19 1  0  3  0   4   5   0   4   6   2  0  1  7  4  16 11
    0  0  4   2   0   2   4   1   4   4  2  2  2  4  17 3  3  3  2   2   2   3   1   2   2  2  4  5  0  8  13
    2  1  3   6   2   5   3   0   9   4  1  5  1  2  5  14 5  0  3   0   0   4   1   0   3  1  1  3  0  1  14
    4  2  3   2   2   1   3   2   6   4  5  4  1  2  7  9  4  2  3   3   0   1   3   2   6  2  1  4  6  3  10
    7  3  1   3   2   1   2   4   7   0  4  2  0  3  1  15 2  1  3   1   1   3   3   1   1  4  1  0  4  1  6
    14 4  2   2   2   1   7   2   1   2  2  3  3  3  4  16 4  3  3   1   2   1   5   3   1  0  2  5  2  2  5
    14 2  4   2   3   2   1   0   1   0  2  1  0  1  1  13 12 2  1   1   2   2   0   4   3  5  2  0  0  5  6
    19 2  1   1   2   3   2   0   2   4  5  2  1  5  3  9  11 3  1   2   0   6   1   0   3  5  2  1  4  3  1
    8  3  0   0   1   2   1   0   3   1  6  2  1  2  0  2  12 2  1   3   4   3   5   1   4  3  3  1  2  3  3
    9  9  2   2   1   2   1   2   2   0  3  3  2  3  3  1  18 11 2   3   0   2   3   4   2  5  1  2  2  2  1
    8  11 2   1   4   1   3   5   3   4  2  4  0  1  1  3  5  5  2   3   1   1   2   2   2  1  1  1  5  2  1
    0  18 2   2   2   1   4   2   4   0  3  4  3  1  4  3  7  14 1   3   1   5   3   3   5  2  4  3  4  3  1
    1  10 6   5   1   1   4   2   1   0  2  0  1  6  4  3  4  17 1   2   0   1   0   1   1  3  2  3  1  3  1
    1  6  15  1   4   2   3   1   1   1  2  0  3  3  1  4  3  13 9   1   0   1   2   1   0  3  2  1  1  2  3
    1  7  14  0   2   1   1   5   3   4  2  2  1  2  5  1  2  7  9   2   5   1   2   1   1  0  2  0  3  2  2
    0  4  8   5   2   2   2   3   2   0  3  2  0  1  2  2  3  4  9   3   1   1   0   1   3  0  1  1  2  0  1
    4  3  12  8   1   3   2   0   1   2  1  6  2  1  4  3  2  2  12  0   3   2   5   2   3  2  0  4  1  1  1
    1  4  7   8   3   1   2   1   2   1  0  5  3  5  3  1  1  2  6   6   0   2   3   3   4  3  4  6  1  0  1
    2  0  5   13  1   0   0   1   2   1  2  2  2  2  0  3  0  1  8   2   2   1   3   2   1  2  3  2  2  1  5
    1  0  3   12  0   2   1   3   2   3  4  0  4  2  0  2  1  1  5   13  2   3   1   1   1  1  0  1  3  2  2
    2  0  2   11  6   2   0   1   4   0  2  2  1  2  2  1  2  2  3   11  0   1   0   1   0  0  0  1  5  0  2
    2  2  2   5   9   4   3   4   2   1  2  3  0  3  2  0  0  2  4   10  5   0   1   1   3  2  1  2  3  0  3
    1  1  0   4   6   4   3   0   0   4  3  1  4  5  1  1  2  1  1   10  8   1   0   1   3  3  2  3  2  0  1
    0  0  1   1   12  1   2   0   1   1  2  4  2  0  3  1  1  3  1   10  13  0   3   1   1  2  3  0  0  1  2
    2  1  1   1   5   5   2   1   1   1  0  1  0  4  0  2  4  1  2   5   12  1   1   3   2  2  3  5  1  1  1
    1  4  2   3   7   8   1   1   0   1  5  4  0  5  2  1  0  2  0   2   18  3   6   2   3  1  2  2  1  3  0
    0  2  2   1   2   7   2   2   2   0  2  1  2  0  3  0  0  4  2   1   10  2   2   2   1  0  0  2  1  5  2
    0  2  3   0   0   15  2   0   1   2  1  0  0  4  0  2  0  4  2   1   2   10  3   0   0  0  4  2  2  3  0
    3  2  0   2   3   10  3   0   3   3  1  1  1  3  1  2  2  0  2   2   6   8   0   2   1  1  2  0  0  1  2
    0  2  1   1   0   5   5   2   0   3  2  4  1  0  1  2  2  1  2   0   2   8   1   0   0  1  2  0  1  2  0
    2  1  0   0   0   0   8   0   1   1  1  1  0  0  2  1  1  1  2   2   3   7   6   1   0  1  1  3  0  1  2
    0  0  1   1   1   3   12  3   2   2  1  3  2  1  1  2  0  0  0   2   2   6   6   2   1  0  5  0  0  3  4
    2  1  2   2   1   2   6   2   2   2  1  1  6  1  6  1  2  1  0   1   3   1   9   5   0  1  1  0  1  1  5
    2  0  0   2   0   5   9   2   2   0  2  1  1  1  0  4  1  0  0   2   0   1   5   0   0  1  4  3  2  1  1
    1  2  1   1   2   1   2   8   4   0  1  1  2  0  2  2  1  1  0   2   0   2   3   3   0  0  3  2  2  2  2
    1  1  0   2   4   1   1   7   1   2  1  2  3  1  3  0  0  0  1   2   1   2   4   6   2  1  1  0  1  0  1
    0  0  1   1   2   1   0   7   4   3  1  2  0  2  0  0  1  1  0   0   0   0   2   14  0  1  0  0  2  0  1
    3  0  2   0   0   0   1   6   6   2  3  0  2  2  2  2  6  0  5   0   0   0   0   11  1  1  3  1  0  1  2
    1  2  3   1   1   0   2   5   11  0  2  1  1  1  1  2  0  0  0   0   2   2   0   5   3  1  1  2  1  2  2
    5  1  1   1   3   3   2   0   16  0  2  2  1  2  1  0  0  1  0   0   3   0   1   5   3  2  1  3  2  0  2
    2  1  0   2   1   0   1   2   7   2  1  1  1  0  2  2  1  0  0   0   2   1   0   1   6  2  1  0  0  2  2
    1  1  1   2   1   1   1   0   7   4  0  1  2  3  1  1  2  1  0   0   1   1   1   2   10 3  1  1  1  3  0
    0  2  0   0   0   1   1   0   2   8  0  0  2  0  0  0  3  3  0   0   1   0   3   2   4  5  0  2  0  2  1
    2  1  0   1   1   1   2   0   2   13 1  2  2  1  1  3  1  1  1   0   1   1   0   0   2  7  0  2  0  4  0
    0  1  3   1   1   2   2   0   0   6  8  0  0  0  2  1  1  1  4   1   4   0   1   1   2  10 2  2  1  1  2
    4  0  1   1   0   2   2   2   1   3  4  0  1  2  5  2  1  1  0   1   1   2   1   1   2  9  3  3  0  0  2
    1  1  3   0   2   0   0   0   0   4  8  0  1  2  3  1  2  0  2   0   0   0   0   2   1  11 2  0  0  0  0
    2  1  1   1   4   1   3   0   1   2  2  0  3  3  0  0  0  1  1   2   0   0   1   1   0  0  9  0  1  2  0
    0  2  0   0   0   0   0   0   1   0  7  5  2  1  3  0  2  0  2   1   0   3   1   0   1  2  6  0  0  0  0
    1  1  0   4   0   0   1   2   0   2  4  1  2  0  0  1  1  1  4   1   1   2   0   1   1  2  5  2  1  1  2
    2  0  0   0   0   2   0   0   1   1  2  3  3  0  0  1  0  0  0   0   2   3   2   2   1  1  5  9  2  2  0
    1  0  0   2   2   1   0   0   2   0  0  8  1  3  2  2  0  0  2   1   3   2   0   0   2  2  2  4  0  2  1
    0  1  2   3   0   0   0   1   2   1  0  3  3  2  0  2  0  0  1   1   0   1   0   1   0  3  2  6  1  2  1
    1  3  0   1   0   1   1   0   3   0  0  3  6  1  2  0  1  2  3   2   2   3   0   1   0  0  2  4  3  1  1
    1  0  0   0   1   1   1   0   0   2  2  5  7  0  1  1  0  0  2   0   2   0   1   1   1  4  3  3  3  0  3
    0  0  1   0   1   1   1   3   0   1  0  1  7  0  1  0  0  2  1   1   1   0   0   1   0  1  0  8  4  0  1
    1  1  1   1   1   0   0   0   3   0  1  0  7  1  0  0  2  1  2   2   2   0   1   0   2  0  1  2  10 2  1
    2  1  2   1   1   1   0   0   0   2  0  1  4  6  2  1  3  0  1   1   0   1   0   2   1  0  0  0  8  4  2
    2  1  2   0   0   1   1   0   0   0  0  0  2  6  1  1  1  0  0   0   2   0   0   0   2  1  2  2  6  3  2
    1  0  1   1   0   2   1   0   0   1  0  0  2  5  2  0  2  3  0   3   2   0   3   0   1  0  1  1  3  9  1
    2  0  0   0   0   1   0   1   1   1  1  0  1  3  0  0  0  0  1   0   2   0   2   1   2  0  0  0  3  3  1
    2  1  0   0   0   2   2   2   2   2  1  1  0  1  5  3  0  1  0   2   2   1   1   0   2  0  0  0  2  5  1
    1  0  0   1   2   3   1   1   0   1  0  1  1  2  2  1  0  0  1   0   1   0   1   1   1  0  1  1  1  6  5
    1  0  1   1   0   0   1   1   0   1  2  1  1  0  6  0  0  1  0   0   0   0   2   1   0  2  1  2  0  2  2
    0  1  0   0   0   2   1   0   0   0  2  1  1  0  4  1  1  1  0   1   0   2   0   1   0  0  2  2  0  2  8
    0  1  2   0   2   3   1   0   1   1  1  0  1  2  4  4  1  1  2   1   1   0   0   1   0  2  0  0  0  0  10
    1  2  0   1   0   2   0   1   0   2  0  2  1  2  4  1  0  0  0   0   1   0   0   0   0  1  1  0  0  0  5
    6  0  0   1   1   0   1   1   0   0  3  2  2  1  1  6  0  1  2   4   3   0   3   1   2  1  0  0  2  0  3
    3  0  0   0   0   0   0   0   0   0  1  1  0  0  2  6  0  0  1   1   1   0   1   0   0  1  0  0  1  1  3
    4  0  2   0   1   0   6   0   0   2  0  1  1  2  1  1  4  1  0   1   1   2   2   2   2  0  0  0  0  0  1
    4  1  1   1   0   2   0   0   2   3  1  1  0  0  0  0  3  2  0   1   1   1   1   0   0  4  0  1  0  0  4
    1  3  2   1   1   2   1   1   0   1  2  0  0  0  1  2  6  1  1   2   0   1   1   0   2  1  0  0  0  1  0
    3  3  0   2   0   0   2   1   1   2  0  0  0  0  1  1  4  1  2   1   0   0   1   3   0  0  0  1  3  0  0
    2  7  2   1   0   2   2   4   1   0  1  1  0  1  0  0  3  1  0   1   0   1   0   1   0  1  2  0  1  0  0
    2  4  2   1   1   0   3   4   1   1  0  0  0  1  1  1  3  7  1   0   1   0   0   1   3  0  1  0  0  1  0
    3  3  2   0   1   1   0   3   1   1  1  1  0  0  2  0  1  3  0   1   0   1   0   1   0  0  0  1  2  0  1
    0  2  0   0   0   0   0   2   0   0  0  0  0  1  1  2  1  5  3   1   2   1   1   0   0  0  1  1  1  0  2
    0  1  3   1   2   0   0   2   0   0  1  1  2  1  1  1  1  2  4   0   0   1   0   0   1  1  1  5  0  1  0
    1  0  5   1   1   0   0   2   1   0  1  3  0  2  0  0  0  4  1   0   0   0   1   2   0  0  0  1  1  0  0
    0  1  5   0   0   1   0   4   2   1  1  2  3  2  1  0  0  0  7   0   0   0   0   0   3  0  0  0  0  0  1
    0  1  3   3   1   1   0   1   1   0  2  2  1  2  0  1  2  0  4   0   2   0   0   1   0  0  1  2  2  0  0
    1  3  0   6   0   1   1   0   0   0  1  0  1  1  0  1  1  1  5   4   1   0   1   0   1  2  1  2  1  0  2
    1  1  0   7   1   1   1   3   1   1  1  0  1  0  0  0  0  0  4   3   0   2   2   0   0  0  0  0  0  1  0
    0  0  1   7   2   0   0   0   2   2  2  0  1  1  1  0  0  0  0   3   3   0   0   0   1  0  2  0  1  0  0
    1  0  0   3   6   1   1   1   0   0  0  0  0  0  1  1  1  3  0   3   1   0   0   0   1  2  3  0  1  1  0
    1  1  1   1   6   0   0   0   0   0  2  1  1  0  0  0  2  0  3   8   4   0   0   0   0  0  1  1  2  1  0
    0  2  0   2   1   1   2   0   0   0  1  0  1  0  1  0  0  0  2   2   2   1   0   0   1  1  0  0  1  0  2
    2  0  1   0   2   3   0   0   0   0  1  0  1  0  2  0  0  0  0   0   6   2   1   0   1  1  0  0  1  1  0
    1  0  0   1   1   5   0   2   1   0  0  0  0  0  0  1  0  0  1   0   7   3   0   3   0  0  0  1  2  0  1
    1  0  1   0   3   2   0   1   2   3  0  0  1  0  1  0  1  1  0   0   1   6   0   0   0  1  1  1  1  1  0
    0  0  1   1   1   3   1   0   0   0  0  0  0  0  0  1  1  1  0   1   0   2   0   0   1  0  1  0  1  0  1
    0  1  0   0   1   2   4   1   0   0  0  2  2  0  0  0  0  0  3   0   0   6   1   2   0  1  1  0  1  1  0
    2  1  1   0   0   2   3   1   0   0  0  0  0  0  0  0  1  1  0   0   0   4   0   1   0  0  1  3  1  0  1
    0  0  2   0   0   2   3   2   0   1  0  1  2  0  1  0  0  0  2   2   0   0   5   0   1  0  0  3  0  1  1
    1  0  0   1   0   2   3   1   2   3  2  0  0  1  0  0  2  1  2   0   1   2   3   0   0  1  4  0  2  1  1
    0  0  3   0   2   3   2   2   1   0  0  1  1  0  0  0  0  0  1   0   0   1   3   1   0  0  1  0  1  0  1
    1  2  0   1   1   0   0   5   0   2  0  2  0  2  0  0  0  0  1   1   1   0   5   0   1  0  0  0  1  0  0
    1  0  0   1   1   0   0   3   0   0  0  0  1  0  1  0  2  1  0   3   0   0   2   1   0  1  2  0  0  0  1
    0  0  0   1   0   0   1   6   2   0  0  1  1  0  0  0  1  0  0   0   1   0   0   2   1  1  0  1  0  2  1
    1  0  1   0   0   0   0   0   1   0  0  0  0  0  0  0  1  1  0   1   1   2   0   3   0  2  1  0  1  1  1
    1  0  1   0   0   1   0   3   2   1  1  0  1  0  0  1  1  0  0   1   2   0   0   7   2  0  0  0  1  1  1
    0  0  1   0   0   0   0   0   4   0  0  0  0  1  0  0  0  1  1   1   0   2   0   4   3  0  0  0  0  0  0
    0  0  0   1   1   1   0   0   7   1  1  0  1  0  0  0  1  1  0   0   1   1   0   2   0  0  0  1  0  0  0
    0  0  0   0   1   0   3   1   1   6  2  0  0  0  0  0  0  0  1   0   0   0   1   0   6  0  1  0  0  1  1
    0  1  1   0   1   0   0   0   2   1  1  1  0  0  0  0  0  0  0   0   0   0   0   0   5  0  0  0  2  0  1
    0  2  1   0   0   0   1   4   1   4  2  1  0  0  0  0  1  1  0   0   0   0   1   0   5  4  1  0  0  0  0
    0  2  0   0   1   1   0   0   1   4  1  1  0  2  0  0  1  0  1   0   1   1   1   1   2  1  0  0  1  0  1
    1  0  0   0   1   2   0   1   1   4  2  0  1  2  0  0  0  0  0   0   0   0   1   1   1  13 0  0  0  0  0
    0  0  0   1   1   1   0   0   1   2  2  0  0  0  0  0  0  0  0   0   0   0   1   0   2  2  5  1  0  1  1
    0  1  0   0   0   1   0   0   0   2  8  1  1  1  0  2  0  0  0   0   0   0   1   1   1  4  1  2  1  1  0
    2  0  1   0   0   2   0   0   0   0  7  1  2  0  0  0  0  0  0   1   0   0   1   1   0  3  2  1  0  1  1
    0  0  0   0   1   0   2   0   0   0  5  4  0  1  1  2  1  0  0   0   0   0   0   0   1  0  3  1  0  1  2
    1  0  0   1   0   0   2   0   1   0  4  5  0  1  2  2  1  1  0   0   1   1   0   1   0  1  4  2  1  0  2
    1  0  1   1   1   0   0   0   0   1  0  3  0  0  0  0  0  0  2   1   3   1   0   0   1  0  1  4  0  2  1
    2  2  1   0   0   0   0   0   0   1  0  3  0  2  0  0  0  1  0   0   0   1   0   0   1  0  3  3  0  0  0
    0  0  0   0   2   0   1   0   1   2  0  1  2  0  0  0  0  0  0   1   0   1   0   0   0  1  0  5  0  1  0
    1  0  0   0   0   0   0   0   0   0  0  2  3  0  0  3  0  0  0   0   0   0   0   0   0  0  2  2  1  1  1
    1  0  1   0   0   0   3   1   1   0  0  0  5  1  2  0  0  1  0   0   2   0   0   0   0  0  0  2  2  0  0
    0  0  0   0   0   1   0   0   1   0  0  0  10 0  2  1  0  0  1   0   0   1   1   0   1  0  0  0  2  0  0
    0  0  1   0   0   1   1   0   0   0  1  2  4  2  0  0  1  0  1   0   1   0   0   1   0  0  0  0  7  1  0
    0  0  0   0   1   0   1   1   1   0  0  0  4  1  0  0  0  0  1   1   0   0   1   0   1  1  0  0  1  1  0
    0  0  0   0   0   1   0   2   0   1  1  1  3  4  1  0  0  0  0   0   1   0   0   0   2  0  0  0  1  4  0
    0  1  1   0   2   0   1   0   0   0  0  2  0  1  2  0  0  1  1   0   1   0   0   1   0  0  0  0  1  2  0
    0  0  0   0   2   0   0   0   0   0  1  0  1  4  1  0  0  0  0   1   0   1   0   0   0  0  0  1  0  1  0
    0  0  0   1   1   1   0   0   0   0  0  1  0  2  4  0  0  0  0   0   1   0   0   0   0  0  0  1  0  4  1
    0  1  1   1   0   0   0   1   0   0  0  1  0  0  2  0  2  0  2   0   1   1   1   1   0  0  0  0  0  1  3
    1  0  0   0   0   0   1   2   0   0  0  0  0  0  2  1  0  2  1   0   0   1   0   0   0  0  1  2  0  1  0
    1  1  1   0   1   0   2   1   0   0  0  0  1  1  1  3  0  0  1   0   0   0   0   1   1  2  2  4  0  1  2
    0  0  0   0   1   0   0   0   0   0  0  0  0  0  1  2  0  0  1   1   0   1   0   0   0  1  0  0  0  0  3
    0  0  1   0   0   0   0   0   0   0  0  2  0  0  1  3  0  0  0   0   0   3   0   0   2  0  0  0  0  0  1
    3  0  0   0   0   1   0   0   1   0  1  2  1  1  2  2  2  0  0   0   0   0   0   3   0  0  0  1  1  1  1
    3  1  0   1   0   1   0   0   1   0  0  1  0  1  0  0  4  0  0   0   1   0   0   2   0  0  0  0  2  0  1
    3  1  0   2   0   0   0   0   0   0  0  0  0  0  0  1  1  0  1   0   0   1   1   0   0  0  0  0  0  0  0
    1  1  0   0   1   0   0   0   0   0  0  0  1  0  0  0  2  1  2   0   1   0   0   0   0  0  1  0  0  0  0
    3  0  0   0   0   0   0   0   0   2  1  0  1  0  0  2  1  2  1   1   1   2   0   0   0  1  0  0  0  0  1
    1  2  0   0   0   0   0   2   0   0  1  0  0  1  1  1  1  0  1   2   0   0   1   0   0  0  1  1  0  0  0
    0  2  0   0   0   0   1   0   1   0  0  0  0  1  1  0  2  1  0   0   0   0   0   0   0  0  1  2  2  0  0
    0  2  0   0   2   0   1   1   0   1  0  0  0  0  2  0  2  1  2   0   1   1   0   1   2  0  0  0  0  0  0
    2  0  1   1   0   2   0   0   0   0  0  0  0  1  0  0  0  4  1   0   2   0   1   0   0  0  1  0  1  0  1
    0  0  3   0   2   2   0   0   2   0  1  0  0  0  1  1  1  3  0   0   0   0   0   0   0  1  0  1  1  1  1
    0  0  5   0   0   0   0   0   0   0  0  0  0  0  0  1  1  0  1   1   1   1   1   0   0  0  2  0  0  0  0
    0  1  4   0   1   0   0   2   0   0  0  0  1  1  1  0  0  0  3   1   0   0   1   0   0  0  0  0  1  0  0
    0  0  2   0   0   0   0   0   0   1  0  0  1  0  1  0  1  1  2   1   0   1   1   1   0  0  0  0  0  0  1
    0  0  1   1   0   0   0   1   0   0  0  0  0  0  0  1  0  0  1   0   1   2   1   0   3  0  0  0  0  0  0
    0  0  0   2   2   0   1   0   1   2  0  0  0  0  0  0  0  0  0   3   0   0   0   0   0  0  1  0  0  1  0
    0  1  2   1   2   0   1   0   0   1  0  0  2  0  0  0  0  0  0   1   0   1   0   1   0  0  0  1  0  1  1
    1  0  0   1   2   0   0   1))
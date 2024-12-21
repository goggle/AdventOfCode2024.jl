# AdventOfCode2024

[![Build Status](https://github.com/goggle/AdventOfCode2024.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/goggle/AdventOfCode2024.jl/actions/workflows/CI.yml?query=branch%3Amain)
<!-- [![CI](https://github.com/goggle/AdventOfCode2024.jl/workflows/CI/badge.svg)](https://github.com/goggle/AdventOfCode2024.jl/actions?query=workflow%3ACI+branch%3Amain) -->
<!-- [![Code coverage](https://codecov.io/gh/goggle/AdventOfCode2024.jl/branch/main/graphs/badge.svg?branch=main)](https://codecov.io/github/goggle/AdventOfCode2024.jl?branch=main) -->

This Julia package contains my solutions for [Advent of Code 2024](https://adventofcode.com/2024/).

## Overview

| Day | Problem | Time | Allocated memory | Source |
|----:|:-------:|-----:|-----------------:|:------:|
| 1 | [:white_check_mark:](https://adventofcode.com/2024/day/1) | 482.120 μs | 584.44 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day01.jl) |
| 2 | [:white_check_mark:](https://adventofcode.com/2024/day/2) | 2.070 ms | 3.64 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day02.jl) |
| 3 | [:white_check_mark:](https://adventofcode.com/2024/day/3) | 470.249 μs | 376.73 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day03.jl) |
| 4 | [:white_check_mark:](https://adventofcode.com/2024/day/4) | 1.798 ms | 3.06 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day04.jl) |
| 5 | [:white_check_mark:](https://adventofcode.com/2024/day/5) | 2.057 ms | 1.26 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day05.jl) |
| 6 | [:white_check_mark:](https://adventofcode.com/2024/day/6) | 22.057 s | 7.71 GiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day06.jl) |
| 7 | [:white_check_mark:](https://adventofcode.com/2024/day/7) | 218.393 ms | 212.72 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day07.jl) |
| 8 | [:white_check_mark:](https://adventofcode.com/2024/day/8) | 316.122 μs | 671.41 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day08.jl) |
| 9 | [:white_check_mark:](https://adventofcode.com/2024/day/9) | 1.099 s | 6.49 GiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day09.jl) |
| 10 | [:white_check_mark:](https://adventofcode.com/2024/day/10) | 578.868 μs | 633.67 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day10.jl) |
| 11 | [:white_check_mark:](https://adventofcode.com/2024/day/11) | 16.464 ms | 13.70 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day11.jl) |
| 12 | [:white_check_mark:](https://adventofcode.com/2024/day/12) | 12.506 ms | 10.00 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day12.jl) |
| 13 | [:white_check_mark:](https://adventofcode.com/2024/day/13) | 3.423 ms | 1.15 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day13.jl) |
| 14 | [:white_check_mark:](https://adventofcode.com/2024/day/14) | 75.842 ms | 275.06 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day14.jl) |
| 16 | [:white_check_mark:](https://adventofcode.com/2024/day/16) | TBD | 105.84 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day16.jl) |
| 17 | [:white_check_mark:](https://adventofcode.com/2024/day/17) | TBD | 706.30 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day17.jl) |
| 18 | [:white_check_mark:](https://adventofcode.com/2024/day/18) | TBD | 5.64 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day18.jl) |
| 19 | [:white_check_mark:](https://adventofcode.com/2024/day/19) | TBD | 3.41 MiB| [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day19.jl) |
| 20 | [:white_check_mark:](https://adventofcode.com/2024/day/20) | TBD | 224.97 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day20.jl) |
<!-- | 21 | [:white_check_mark:](https://adventofcode.com/2024/day/21) | 9.675 ms | 7.19 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day21.jl) | -->
<!-- | 22 | [:white_check_mark:](https://adventofcode.com/2024/day/22) | 790.712 ms | 631.26 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day22.jl) | -->
<!-- | 23 | [:white_check_mark:](https://adventofcode.com/2024/day/23) | 2.979 s | 9.69 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day23.jl) | -->
<!-- | 24 | [:white_check_mark:](https://adventofcode.com/2024/day/24) | 43.214 ms | 49.77 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day24.jl) | -->
<!-- | 25 | [:white_check_mark:](https://adventofcode.com/2024/day/25) | 69.476 ms | 62.03 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day25.jl) | -->
<!-- | 15 | [:white_check_mark:](https://adventofcode.com/2024/day/15) | 2.647 ms | 1.49 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day15.jl) | -->


The benchmarks have been measured on this machine:
```
Platform Info:
  OS: Linux (x86_64-linux-gnu)
  CPU: 8 × Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-14.0.6 (ORCJIT, skylake)
  Threads: 1 on 8 virtual cores
```


## Installation and Usage

Make sure you have [Julia 1.8 or newer](https://julialang.org/downloads/)
installed on your system.


### Installation

Start Julia and enter the package REPL by typing `]`. Create a new
environment:
```julia
(@v1.8) pkg> activate aoc
```

Install `AdventOfCode2024.jl`:
```
(aoc) pkg> add https://github.com/goggle/AdventOfCode2024.jl
```

Go back to the Julia REPL by pushing the `backspace` key.


### Usage

First, activate the package:
```julia
julia> using AdventOfCode2024
```

Each puzzle can now be run with `dayXY()`:
```julia
julia> day01()
2-element Vector{Int64}:
 1590491
 22588371
```

This will use my personal input. If you want to use another input, provide it
to the `dayXY` method as a string. You can also use the `readInput` method
to read your input from a text file:
```julia
julia> input = readInput("/path/to/input.txt")

julia> AdventOfCode2024.Day01.day01(input)
2-element Vector{Int64}:
 1590491
 22588371
```
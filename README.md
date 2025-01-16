# AdventOfCode2024

[![Build Status](https://github.com/goggle/AdventOfCode2024.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/goggle/AdventOfCode2024.jl/actions/workflows/CI.yml?query=branch%3Amain)
<!-- [![CI](https://github.com/goggle/AdventOfCode2024.jl/workflows/CI/badge.svg)](https://github.com/goggle/AdventOfCode2024.jl/actions?query=workflow%3ACI+branch%3Amain) -->
<!-- [![Code coverage](https://codecov.io/gh/goggle/AdventOfCode2024.jl/branch/main/graphs/badge.svg?branch=main)](https://codecov.io/github/goggle/AdventOfCode2024.jl?branch=main) -->

This Julia package contains my solutions for [Advent of Code 2024](https://adventofcode.com/2024/).

## Overview

| Day | Problem | Time | Allocated memory | Source |
|----:|:-------:|-----:|-----------------:|:------:|
| 1 | [:white_check_mark:](https://adventofcode.com/2024/day/1) | 459.477 μs | 461.83 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day01.jl) |
| 2 | [:white_check_mark:](https://adventofcode.com/2024/day/2) | 2.070 ms | 3.64 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day02.jl) |
| 3 | [:white_check_mark:](https://adventofcode.com/2024/day/3) | 470.249 μs | 376.73 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day03.jl) |
| 4 | [:white_check_mark:](https://adventofcode.com/2024/day/4) | 1.798 ms | 3.06 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day04.jl) |
| 5 | [:white_check_mark:](https://adventofcode.com/2024/day/5) | 2.104 ms | 1.26 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day05.jl) |
| 6 | [:white_check_mark:](https://adventofcode.com/2024/day/6) | 592.911 ms | 52.99 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day06.jl) |
| 7 | [:white_check_mark:](https://adventofcode.com/2024/day/7) | 221.356 ms | 212.55 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day07.jl) |
| 8 | [:white_check_mark:](https://adventofcode.com/2024/day/8) | 316.122 μs | 671.41 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day08.jl) |
| 9 | [:white_check_mark:](https://adventofcode.com/2024/day/9) | 32.603 ms | 9.58 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day09.jl) |
| 10 | [:white_check_mark:](https://adventofcode.com/2024/day/10) | 578.868 μs | 633.67 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day10.jl) |
| 11 | [:white_check_mark:](https://adventofcode.com/2024/day/11) | 16.464 ms | 13.70 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day11.jl) |
| 12 | [:white_check_mark:](https://adventofcode.com/2024/day/12) | 12.506 ms | 10.00 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day12.jl) |
| 13 | [:white_check_mark:](https://adventofcode.com/2024/day/13) | 3.423 ms | 1.15 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day13.jl) |
| 14 | [:white_check_mark:](https://adventofcode.com/2024/day/14) | 75.842 ms | 275.06 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day14.jl) |
| 15 | [:white_check_mark:](https://adventofcode.com/2024/day/15) | 1.944 ms | 3.16 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day15.jl) |
| 16 | [:white_check_mark:](https://adventofcode.com/2024/day/16) | 167.184 ms | 105.84 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day16.jl) |
| 17 | [:white_check_mark:](https://adventofcode.com/2024/day/17) | 6.921 ms | 706.30 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day17.jl) |
| 18 | [:white_check_mark:](https://adventofcode.com/2024/day/18) |2.964 ms | 5.64 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day18.jl) |
| 19 | [:white_check_mark:](https://adventofcode.com/2024/day/19) | 59.678 ms | 3.41 MiB| [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day19.jl) |
| 20 | [:white_check_mark:](https://adventofcode.com/2024/day/20) | 227.453 ms | 224.97 MiB| [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day20.jl) |
| 21 | [:white_check_mark:](https://adventofcode.com/2024/day/21) | 296.609 μs | 78.89 KiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day21.jl) |
| 22 | [:white_check_mark:](https://adventofcode.com/2024/day/22) | 241.724 ms | 78.80 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day22.jl) |
| 23 | [:white_check_mark:](https://adventofcode.com/2024/day/23) | 4.197 ms | 3.82 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day23.jl) |
| 24 | [:white_check_mark:](https://adventofcode.com/2024/day/24) | 5.080 s | 2.83 GiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day24.jl) |
| 25 | [:white_check_mark:](https://adventofcode.com/2024/day/25) | 2.178 ms | 3.47 MiB | [:white_check_mark:](https://github.com/goggle/AdventOfCode2024.jl/blob/main/src/day25.jl) |


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
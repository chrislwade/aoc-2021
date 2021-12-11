# 2021 Advent of Code (Ruby)

This repository implements solutions to the puzzles in the
[2021 Advent of Code](https://adventofcode.com/2021) using Ruby.


## Preface

Ruby used to be my go-to language but my day job has me doing the polyglot
thing most of the time. I wanted to revitalize my Ruby knowledge which led me
to use it for AoC 2021.

I'm certain some practices in this code are dated and frowned upon my modern
Ruby developers. I'm open to suggestions and improvements!


## Credits

- [John Dugan](https://github.com/jdugan): I "stole" his README layout. Because
  I am horrible at documentation!
- [aucinc123](https://github.com/aucinc123): I borrowed his
  [solution for Day 8](https://github.com/aucinc123/AdventOfCode-2021/blob/master/AdventOfCode/SevenSegmentPuzzle.cs),
  Part 2. Because my brain just wasn't finding a solution.


## Getting Started

### Prerequisites

The project requires `ruby 3.0.2`, but any reasonably current version of
Ruby will likely work.

If you use a Ruby version manager that responds to `.tool-versions`, you should
be switched to correct version automatically. I recommend
[ASDF](https://github.com/asdf-vm/asdf) for those on platforms that support it.

If you want to download the daily puzzle input programmatically, obtain your
`session` cooking from the AoC website. See [installation](#installation).

### Installation

This project uses [Bundler](https://bundler.io/) to manage dependencies. To
install them simply run the following:

```
$ bundle install
```

The project provides a utility script to fetch the daily puzzle input
programmatically. To enable this script, run the following:

```
$ echo 'session_cookie_value' > .env
```

### File Structure

- [bin](./bin):     Wrapper and utility scripts.
- [input](./input): Puzzle input organized by day.
- [lib](./lib):     Daily solutions and other bad programming.
- [spec](./spec):   A meta-programmed spec to make testing easier.


## Daily Solutions

### Scaffolding Daily Solution

The project provides a `scaffold` script that will generate the boilerplate
required to implement a new day.

It will attempt to download the puzzle input for the specified day if an
`ADVENT_SESSION` environment variable is set and is a valid session cookie from
the AoC website. This environment variable can also be provided in a `.env`
thanks to the [dotenv](https://github.com/bkeepers/dotenv) gem.

Below is an example usage and output:

```
$ ./bin/scaffold 11
Downloaded puzzle input and wrote .../input/day11.txt.
Wrote sample .../spec/fixtures/day11.txt.
**NOTE**: You must still copy the sample data into this file to enable testing of this day's puzzles.
Wrote scaffold .../lib/day11.rb.
```

### Running Daily Solutions

The project presents a wrapper command (`aoc`) that loads the implementation
for the specified day, processes the puzzle input, and generates output for
both puzzle parts.

Below is an example usage and output:

```
$ ./bin/aoc 1
--- Day 01: Sonar Sweep ---
How many measurements are larger than the previous measurement?
- Puzzle 1: 1655
How many sums are larger than the previous sum?
- Puzzle 2: 1683
```

### Running Tests

The tests for each day are automatically generated using meta-programming to
simplify the task of implementing a new day.

The scaffolding implementation includes a class method to provide the expected
sample answers from the puzzle page. These values must be fetched from the
puzzle and provided as the value for the appropriate hash key: `puzzle1` or
`puzzle2`.

The scaffolding also includes a class method to provide the expected puzzle
answers. This is provided as a method to be able to verify outputs after
potential refactoring. This may be redundant given the sample testing, but it
is provided for completeness. These values must be plugged in after validating
the solution with the AoC website.

All tests are setup to be skipped until expected values are provided.

To execute the tests run the following:

```
$ rspec
........................................

Finished in 1.59 seconds (files took 0.24563 seconds to load)
40 examples, 0 failures
```

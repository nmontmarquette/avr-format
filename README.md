# AVR Format

**WORK-IN-PROCESS DOESN'T DO ANYTHING AT THIS TIME.**

A simple command-line utility to reformat AVR-based assembly language source files.
It is written in C/C++ and uses a lexer and parser to reformat AVR assembly source code files.

## Features
- Tokenizes AVR assembly instructions and directives.
- Parses and reformats assembly code for better readability.
- Supports custom formatting rules.

## Requirements
* g++
* flex
* bison
* [Doctest lightweight C++ test framework](https://raw.githubusercontent.com/doctest/doctest/master/doctest/doctest.h)

## Build Instructions
1. Install a C/C++ compiler (e.g., GCC or Clang).
2. Run `make` to build the project.

## Usage
Run the executable with the input assembly file:
```bash
./avr-format input.asm -o output.asm
```

## Running Tests
```bash
make # the test executable currently requires building everything first
make test
```

## License
MIT License

## Debugging

* [Setting up Visual Studio Code](https://code.visualstudio.com/docs/cpp/launch-json-reference)
* Install the `CodeLLDB v1.9.0` Visual Studio Code plugin by `Vadim Chugunov`.

## LLDB Cheatsheet

* `image lookup -rn DOCTEST.*` — List all DOCTEST test functions.

## Links

* [Parameter Pack Documentation](https://en.cppreference.com/w/cpp/language/parameter_pack)


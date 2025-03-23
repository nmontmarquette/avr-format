#include <iostream>
#include <fstream>

#include "lines.h"
#include "parser.tab.hpp"

extern FILE *yyin;
extern int yyparse();


int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file>" << std::endl;
        return 1;
    }

    const char *input_file = argv[1];
    yyin = fopen(input_file, "r");

    if (!yyin) {
        std::cerr << "Error: Cannot open input file: " << input_file << std::endl;
        return 1;
    }

    if (yyparse() == 0) {
        for (const auto &line : gLines) {
            std::cout << line.format();
        }
    } else {
        std::cerr << "Error: Parsing failed" << std::endl;
    }

    fclose(yyin);
    return 0;
}

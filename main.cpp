#include <iostream>
#include <fstream>

#include "asmline.h"
#include "build/parser.tab.hpp"


extern FILE *yyin;
extern int yyparse();
extern std::vector<AsmLine> asm_lines;

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
        for (const auto &line : asm_lines) {
            if (!line.label.empty()) {
                std::cout << line.label << ":";
            }
            if (!line.instruction.empty()) {
                std::cout << "\t" << line.instruction;
            }
            std::cout << std::endl;
        }
    } else {
        std::cerr << "Error: Parsing failed" << std::endl;
    }

    fclose(yyin);
    return 0;
}

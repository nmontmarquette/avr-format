#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <iostream>
#include <vector>
#include "doctest.h"
#include "asmline.h"
#include "build/parser.tab.hpp"

extern int yyparse();
extern void yy_scan_string(const char* str);
extern std::vector<AsmLine> asm_lines;

// The format_asm function definition goes here

int parse(const std::string &input_string, std::string &output)
{
    yy_scan_string(input_string.c_str());
    int parse_result = yyparse();

    if (parse_result == 0) {

        for (const auto& line : asm_lines) {
        #if 0
            if (!line.label.empty()) {
                output << line.label << ":";
            }

            if (!line.instruction.empty()) {
                output << "\t" << line.instruction;
            }

            if (!line.directive.empty()) {
                output << "\t" << line.directive;
            }

            for (size_t i = 0; i < line.operands.size(); ++i) {
                if (i == 0) {
                    output << " ";
                } else {
                    output << ",";
                }
                output << line.operands[i];
            }

            if (!line.comment.empty()) {
                output << "\t;" << line.comment;
            }

            output << std::endl;
        #endif
        }
    } else {
        std::cerr << "Error: Parsing failed." << std::endl;
        return 1;
    }

    return 0;
}

TEST_CASE("Empty input") {
    std::string input = "";
    std::string expected_output = "";
    std::string output;
    //ormat_asm(input) == expected_output);
    int result = parse(input, output);
    REQUIRE(result == 1);
    REQUIRE(output == expected_output);
}

#if 0
TEST_CASE("Single instruction") {
    std::string input = "NOP";
    std::string expected_output = "NOP\n";
    REQUIRE(format_asm(input) == expected_output);
}

TEST_CASE("Instruction with one operand") {
    std::string input = "LDA r16";
    std::string expected_output = "LDA r16\n";
    REQUIRE(format_asm(input) == expected_output);
}

TEST_CASE("Instruction with multiple operands") {
    std::string input = "ADD r16, r17";
    std::string expected_output = "ADD r16, r17\n";
    REQUIRE(format_asm(input) == expected_output);
}

TEST_CASE("Comment") {
    std::string input = "; This is a comment";
    std::string expected_output = "; This is a comment\n";
    REQUIRE(format_asm(input) == expected_output);
}

TEST_CASE("Instruction with inline comment") {
    std::string input = "LDA r16 ; Load register 16";
    std::string expected_output = "LDA r16 ; Load register 16\n";
    REQUIRE(format_asm(input) == expected_output);
}

TEST_CASE("Directive with arguments") {
    std::string input = ".include \"myfile.inc\"";
    std::string expected_output = ".include \"myfile.inc\"\n";
    REQUIRE(format_asm(input) == expected_output);
}

TEST_CASE("Label and instruction") {
    std::string input = "start: LDI r16, 0x00";
    std::string expected_output = "start: LDI r16, 0x00\n";
    REQUIRE(format_asm(input) == expected_output);
}
#endif
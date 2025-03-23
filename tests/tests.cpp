#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <iostream>
#include <vector>
#include "doctest.h"
#include "src/lines.h"
#include "src/parser.tab.hpp"

extern int yyparse();
extern void yy_scan_string(const char* str);
extern Lines gLines;

// The format_asm function definition goes here

/**
 * @brief Returns 0 no parsing error or 1 error parsing the input.
 *
 * @param input_string
 * @param output
 * @return int
 */
int parse(const std::string &input_string, std::string &output)
{
    yy_scan_string(input_string.c_str());
    int parse_result = yyparse();

    if (parse_result == 0) {

        for (const auto& line : gLines) {
            output += line.format();
        #if 0
            if (!line.label.empty()) {
                output += line.label;
                output += ":";
            }

            if (!line.instruction.empty()) {
                output += "\t";
                output += line.instruction;
            }

            if (!line.comment.empty()) {
                output += "; ";
                output += line.comment;
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

        #endif
            // line format already add a newline character
            //output += "\n";
        }
    } else {
        std::cerr << "Error: Parsing failed." << std::endl;
        return 1;
    }

    return 0;
}

void setup() {
    // Setup code here
    gLines.clear();
}

TEST_CASE("Basic Tests") {

    SUBCASE("Empty input") {
        setup();
        std::string input = "";
        std::string expected_output = "";
        std::string output;
        REQUIRE(parse(input, output) == 0);
        REQUIRE(gLines.size() == 0);
        REQUIRE(output == expected_output);
    }

    SUBCASE("Empty line") {
        setup();
        std::string input = "\n";
        std::string expected_output = "\n";
        std::string output;
        CHECK_EQ(parse(input, output), 0);
        CHECK_EQ(gLines.size(), 1);
        CHECK_EQ(output, expected_output);
    }

    SUBCASE("Empty lines") {
        setup();
        std::string input = "\n\n\n";
        std::string expected_output = "\n\n\n";
        std::string output;
        CHECK_EQ(parse(input, output), 0);
        CHECK_EQ(gLines.size(), 3);
        CHECK_EQ(output, expected_output);
    }
}

#if 0

/**
 * @brief This fails, but is it would be an an invalid assembly or C/C++ statement.
 *
 */
TEST_CASE("Lines of text") {
    std::string input = "abcedfg\n0123456\nabcdefg\n";
    std::string expected_output = "abcedfg\n0123456\nabcdefg\n";
    std::string output;

    setup();
    REQUIRE(parse(input, output) == 0);
    REQUIRE(gLines.size() == 3);
    REQUIRE(output == expected_output);
}
#endif

TEST_CASE("Assembler Syntax Tests") {

    SUBCASE("Assembler style line comment at start of line") {
        std::string input = "; this is a test comment at the start of a line.\n";
        std::string expected_output = "; this is a test comment at the start of a line.\n";
        std::string output;

        setup();
        int result = parse(input, output);
        CHECK_EQ(result, 0);
        CHECK_EQ(gLines.size(), 2); // line 1 the comment, line 2 is empty
        auto fmt = gLines[0].format();
        CHECK_EQ(fmt, "this is a test comment at the start of a line.");
        CHECK_EQ(output, expected_output);
    }

    SUBCASE("Assembler style ine comment after whitespaces") {
        setup();
        std::string input = "    \t\t\t; this is a test comment following a few white spaces.\n";
        std::string expected_output = "; this is a test comment following a few white spaces.\n";
        std::string output;
        REQUIRE(parse(input, output) == 0);
        REQUIRE(gLines.size() == 1);
        REQUIRE(gLines[0].format() == "this is a test comment following a few white spaces.");
        REQUIRE(output == expected_output);
    }

    SUBCASE("Assembler style line comment after whitespaces") {
        setup();
        std::string input = "    \t\t\t; this is a test comment following a few white spaces.\n";
        std::string expected_output = "; this is a test comment following a few white spaces.\n";
        std::string output;
        REQUIRE(parse(input, output) == 0);
        REQUIRE(gLines.size() == 1);
        REQUIRE(gLines[0].format() == "this is a test comment following a few white spaces.");
        REQUIRE(output == expected_output);
    }

    SUBCASE("Assembler style include") {
        setup();
        std::string input = "\n.include \"avr_constants.inc\"\n\n";
        std::string expected_output = "; this is a test comment following a few white spaces.\n";
        std::string output;
        REQUIRE(parse(input, output) == 0);
        REQUIRE(gLines.size() == 3);
        REQUIRE(gLines[0].format() == "this is a test comment following a few white spaces.");
        REQUIRE(output == expected_output);
    }
}

#if 0
TEST_CASE("C/C++ Syntax Tests") {

    SUBCASE("C++ style line comment after whitespaces") {
        setup();
        std::string input = "    \t\t// this is a C++ style test comment following a few white spaces.\n";
        std::string expected_output = "; this is a C++ style test comment following a few white spaces.\n";
        std::string output;
        REQUIRE(parse(input, output) == 0);
        REQUIRE(gLines.size() == 1);
        REQUIRE(gLines[0].format() == "this is a C++ style test comment following a few white spaces.");
        REQUIRE(output == expected_output);
    }
}

TEST_CASE("Single instruction (Uppercase)") {
    setup();
    std::string input = "NOP";
    std::string expected_output = "NOP\n";
    std::string output;
    int result = parse(input, output);
    CHECK_EQ(result, 0);
    REQUIRE(output == expected_output);
}

TEST_CASE("Single instruction (Lowercase)") {
    setup();
    std::string input = "\tnop";
    std::string expected_output = "\tnop\n";
    std::string output;
    int result = parse(input, output);
    CHECK_EQ(result, 0);
    REQUIRE(output == expected_output);
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

TEST_CASE("Line-based classes Tests") {

    SUBCASE("Assembler style line comment at start of line") {
        setup();
        std::string input = "; this is a test comment at the start of a line.\n";
        std::string expected_output = "; this is a test comment at the start of a line.\n";
        std::string output;
        REQUIRE(parse(input, output) == 0);
        REQUIRE(gLines.size() == 1);
        REQUIRE(gLines[0].format() == "this is a test comment at the start of a line.");
        REQUIRE(output == expected_output);
    }
}
#endif
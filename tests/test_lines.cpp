#include <iostream>
#include "doctest.h"
#include "src/lines.h"

TEST_CASE("Line-based classes Tests") {

    SUBCASE("Test initializing an assembler directive without parameter.") {
        setup();

        Directive directive(".code");
        CHECK(directive.directive().text() ==  ".code");
        CHECK(directive.parameters().size() == 0);
    }

    SUBCASE("Test initializing an assembler include directive.") {
        setup();

        Directive directive(".include", "\"constants.inc\"");
        CHECK(directive.directive().text() == ".include");
        CHECK(directive.parameters().size() == 1);
        CHECK(directive.parameter(0).text() == "\"constants.inc\"");
    }

    SUBCASE("Test initializing an assembler C-Style include directive.") {
        setup();

        Directive directive("#include", "\"65xx_defs.h\"");
        CHECK(directive.directive().text() == "#include");
        CHECK(directive.parameters().size() == 1);
        CHECK(directive.parameter(0).text() == "\"65ssxx_defs.h\"");
    }

   SUBCASE("Test initializing an assembler directive with 2 parameters.") {
        setup();
        Directive directive(".code 0x1000 512");
        CHECK(directive.directive().text() == ".code");
        CHECK(directive.parameters().size() == 2);
        CHECK(directive.parameter(0).text().toInt() == 4096);
        CHECK(directive.parameter(1).text().toInt() == 512);
    }

   SUBCASE("Test initializing an assembler directive with 2 parameters.") {
        setup();

        Directive directive(".code", 0x1000, 512);
        CHECK(directive.directive().text() == ".code");
        CHECK(directive.parameters().size() == 2);
        CHECK(directive.parameter(0).text().toInt() == 4096);
        CHECK(directive.parameter(1).text().toInt() == 512);
    }

   SUBCASE("Test initializing a c-style include.") {
        setup();

        Directive directive(".code", 0x1000, 512);
        CHECK(directive.directive().text() == ".code");
        CHECK(directive.parameters().size() == 2);
        CHECK(directive.parameter(0).text().toInt() == 4096);
        CHECK(directive.parameter(1).text().toInt() == 512);
    }
}
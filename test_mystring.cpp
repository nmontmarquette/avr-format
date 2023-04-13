#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <iostream>
#include "doctest.h"
#include "mystring.h"


void setup() {
    // Setup code here
}

TEST_CASE("Mystring class Tests") {

    SUBCASE("Test simple constructor") {
        setup();

        MyString s1("");
        MyString s2("hello!");
        MyString s3(s2);
        CHECK_EQ(0, s1.size());
        CHECK_FALSE(!s1.empty());
        CHECK_EQ(s2, s3);
        CHECK_FALSE(s2.empty());
        CHECK_FALSE(s3.empty());
    }

    SUBCASE("Test a few operators.") {
        setup();

        MyString s1("Hello");
        CHECK_EQ(s1[0], 'H');
        CHECK_EQ(s1[4], 'o');

        MyString s2("World!");
        MyString s3 = s1;
        s3 += " ";
        s3 += s2;
        CHECK(0==strcmp(s3.c_str(), "Hello World!"));
        CHECK_EQ(s3, MyString("Hello World!"));

        CHECK(s3 == "Hello World!");
        CHECK(s3 != "hello world!");
    }

    SUBCASE("Test lower method.") {
        setup();

        CHECK(MyString("Hello World!").lower() == "hello world!");
        CHECK(MyString("123").lower() == "123");
        CHECK(MyString("").lower() == "");
    }

    SUBCASE("Test split method.") {
        setup();

        auto parts = MyString("Hello World!").split();
        CHECK(parts.size() == 2);
        CHECK(parts[0] == "Hello");
        CHECK(parts[1] == "World!");
    }

    SUBCASE("Test toInt method.") {
        setup();
        CHECK(MyString("0").toInt() == 0);
        CHECK(MyString("000").toInt() == 0);
        CHECK(MyString("0000").toInt() == 0);
        CHECK(MyString("987").toInt() == 987);
        CHECK(MyString("+987").toInt() == 987);
        CHECK(MyString("-987").toInt() == -987);
        // Adding a few whitespaces ...
        CHECK(MyString("   123\n  ").toInt() == 123);
        // Try a binary string
        //CHECK(MyString("01111b").toInt() == 15);
        // Try an octal string
        CHECK(MyString("0666").toInt() == 438);
        // Trying an hexadecimal string
        CHECK(MyString("0x1000").toInt() == 4096);
    }

    SUBCASE("Test trim method.") {
        setup();

        MyString s1("   123\n  ");
        CHECK(s1.trim() == "123");
        // not expecting s1 to be modified by the call to the trim method.
        CHECK_EQ(s1, MyString("   123\n  "));
    }

    SUBCASE("Test upper method.") {
        setup();

        CHECK(MyString("Hello World!").upper() == "HELLO WORLD!");
        CHECK(MyString("123").upper() == "123");
        CHECK(MyString("").upper() == "");
    }
}
CC = g++
CXX = g++
CXXFLAGS = -std=c++11 -Wno-deprecated-register -Wall -Wextra
TESTS_CXXFLAGS = $(CXXFLAGS) -g -O0 -DDEBUG
FLEX = flex
BISON = bison

SRC_DIR = .
BUILD_DIR = build
BIN_DIR = bin

EXECUTABLE = formatter
TEST_EXECUTABLES = $(BUILD_DIR)/test $(BUILD_DIR)/test_lines $(BUILD_DIR)/test_mystring

.PHONY: all clean test debug_test tests test_lines test_mystring

all: $(BUILD_DIR) $(BUILD_DIR)/$(EXECUTABLE) $(BUILD_DIR)/test

$(BUILD_DIR):
	@echo "Creating build folder ..."
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/$(EXECUTABLE): lines.h main.cpp $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp
	@echo "Generating binary ..."
	$(CC) $(CXXFLAGS) -o $@ main.cpp $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp

$(BUILD_DIR)/lexer.cpp: $(SRC_DIR)/lexer.l $(BUILD_DIR)/parser.tab.hpp
	@echo "Generating lexer ..."
	$(FLEX) -o $@ $<

$(BUILD_DIR)/parser.tab.cpp $(BUILD_DIR)/parser.tab.hpp: $(SRC_DIR)/parser.y
	@echo "Generating parser ..."
	$(BISON) -d -o $(BUILD_DIR)/parser.tab.cpp $<

debug_test: $(BUILD_DIR)/test
	lldb $(BUILD_DIR)/test

tests: $(TEST_EXECUTABLES)
	@echo "Running tests ..."
	$(BUILD_DIR)/test
	$(BUILD_DIR)/test_lines
	$(BUILD_DIR)/test_mystring

test: $(BUILD_DIR)/test
	@echo "Running tests ..."
	$(BUILD_DIR)/test

test_lines: $(BUILD_DIR)/test_lines doctest.h mystring.h lines.h test_lines.cpp
	@echo "Running $@ ..."
	$(BUILD_DIR)/test_lines

test_mystring: $(BUILD_DIR)/test_mystring doctest.h mystring.h test_mystring.cpp
	@echo "Running $@ ..."
	$(BUILD_DIR)/test_mystring

$(BUILD_DIR)/test_mystring: doctest.h mystring.h test_mystring.cpp
	@echo "Building '$<' executable ..."
	$(CC) $(TESTS_CXXFLAGS) -o $@ test_mystring.cpp

$(BUILD_DIR)/test_lines: $(BUILD_DIR) doctest.h mystring.h lines.h test_lines.cpp
	@echo "Building '$<' executable ..."
	$(CC) $(TESTS_CXXFLAGS) -o $@ test_lines.cpp

$(BUILD_DIR)/test: doctest.h lines.h tests.cpp $(BUILD_DIR)/parser.tab.cpp  $(BUILD_DIR)/lexer.cpp
	@echo "Building test executable ..."
	$(CC) $(TESTS_CXXFLAGS) -o $@ tests.cpp  $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp

clean:
	@echo "Cleaning up ..."
	@rm -rdf $(BUILD_DIR)

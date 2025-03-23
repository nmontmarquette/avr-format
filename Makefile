CC = g++
CXX = g++
CXXFLAGS = -std=c++17 -Wno-deprecated-register -Wall -Wextra
TESTS_CXXFLAGS = $(CXXFLAGS) -g -O0 -DDEBUG -I./ -I../src
FLEX = flex
BISON = bison

SRC_DIR = src
TESTS_DIR = tests
BUILD_DIR = build
BIN_DIR = bin

EXECUTABLE = avr-format

.PHONY: all clean test debug_test tests test_lines test_mystring help

SOURCES = $(SRC_DIR)/lexer.cpp $(SRC_DIR)/parser.tab.cpp $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SOURCES))

all: $(BUILD_DIR) $(BUILD_DIR)/$(EXECUTABLE) $(BUILD_DIR)/test

$(BUILD_DIR):
	@echo "Creating build folder ..."
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/$(EXECUTABLE): $(OBJECTS)

$(SRC_DIR)/parser.tab.cpp $(SRC_DIR)/parser.tab.hpp: $(SRC_DIR)/parser.y
	@echo "Generating parser ..."
	$(BISON) -d -o $(SRC_DIR)/parser.tab.cpp $<

$(SRC_DIR)/lexer.cpp: $(SRC_DIR)/lexer.l $(SRC_DIR)/parser.tab.hpp
	@echo "Generating lexer ..."
	$(FLEX) -o $@ $<

debug_test: $(BUILD_DIR)/test
	lldb $(BUILD_DIR)/test

test: $(BUILD_DIR)/test
	@echo "Running tests ..."
	$(BUILD_DIR)/test

$(SRC)/main.cpp: (SRC_DIR)/lines.h $(BUILD_DIR)/parser.tab.hpp

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@echo "Building '$<' object file ..."
	$(CC) $(CXXFLAGS) -c -o $@ $<

$(BUILD_DIR)/test: $(TESTS_DIR)/doctest.h $(SRC_DIR)/lines.h $(TESTS_DIR)/tests.cpp $(SRC_DIR)/parser.tab.cpp  $(SRC_DIR)/lexer.cpp
	@echo "Building test executable ..."
	$(CC) $(TESTS_CXXFLAGS) -o $@ $(TESTS_DIR)/tests.cpp $(SRC_DIR)/lexer.cpp $(SRC_DIR)/parser.tab.cpp

clean:
	@echo "Cleaning up ..."
	@rm -rdf $(BUILD_DIR)
	@rm -f $(SRC_DIR)/lexer.cpp $(SRC_DIR)/parser.tab.cpp $(SRC_DIR)/parser.tab.hpp $(SRC_DIR)/lex.yy.c

help:
	@echo "Available targets:"
	@echo "  all    - Build the project"
	@echo "  clean  - Remove build artifacts"
	@echo "  test   - Run the tests"
	@echo "  help   - Display this help message"

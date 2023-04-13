CC = g++
CXX = g++
CXXFLAGS = -std=c++11 -Wno-deprecated-register -Wall -Wextra
TESTS_CXXFLAGS = $(CXXFLAGS)
FLEX = flex
BISON = bison

SRC_DIR = .
BUILD_DIR = build
BIN_DIR = bin

EXECUTABLE = formatter

.PHONY: all clean test

all: $(BUILD_DIR) $(BUILD_DIR)/$(EXECUTABLE)

$(BUILD_DIR):
	@echo "Creating build folder ..."
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/$(EXECUTABLE): asmline.h main.cpp $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp
	@echo "Generating binary ..."
	$(CC) $(CXXFLAGS) -o $@ main.cpp $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp

$(BUILD_DIR)/lexer.cpp: $(SRC_DIR)/lexer.l $(BUILD_DIR)/parser.tab.hpp
	@echo "Generating lexer ..."
	$(FLEX) -o $@ $<

$(BUILD_DIR)/parser.tab.cpp $(BUILD_DIR)/parser.tab.hpp: $(SRC_DIR)/parser.y
	@echo "Generating parser ..."
	$(BISON) -d -o $(BUILD_DIR)/parser.tab.cpp $<

test: $(BUILD_DIR)/test
	@echo "Running tests ..."
	$(BUILD_DIR)/test

$(BUILD_DIR)/test: doctest.h asmline.h tests.cpp $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp
	@echo "Building test executable ..."
	$(CC) $(TESTS_CXXFLAGS) -o $@ tests.cpp  $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp

clean:
	@echo "Cleaning up ..."
	rm -rdf $(BUILD_DIR)

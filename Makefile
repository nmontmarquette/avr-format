CC = g++
CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra
FLEX = flex
BISON = bison

SRC_DIR = .
BUILD_DIR = build
BIN_DIR = bin

EXECUTABLE = formatter

.PHONY: all clean

all: $(BUILD_DIR)/$(EXECUTABLE)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/$(EXECUTABLE): main.cpp $(BUILD_DIR)/lexer.cpp $(BUILD_DIR)/parser.tab.cpp
	$(CC) $(CXXFLAGS) -o $@ $^

$(BUILD_DIR)/lexer.cpp: $(SRC_DIR)/lexer.l $(BUILD_DIR)/parser.tab.hpp
	$(FLEX) -o $@ $<

$(BUILD_DIR)/parser.tab.cpp $(BUILD_DIR) $(BUILD_DIR)/parser.tab.hpp: $(SRC_DIR)/parser.y
	$(BISON) -d -o $(BUILD_DIR)/parser.tab.cpp $<

clean:
	rm -f $(BUILD_DIR)/*.cpp $(BUILD_DIR)/*.hpp $(BIN_DIR)/$(EXECUTABLE)

#ifndef ASMLINE_H
#define ASMLINE_H

#include <string>
#include <vector>

class AsmLine {
public:
    std::string label;
    std::string instruction;
    std::string comment;
};

#endif // ASMLINE_H

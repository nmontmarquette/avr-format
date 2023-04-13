#include "build/parser.tab.hpp"

extern int yyparse();

int main() {
    yyparse();
    return 0;
}
